//
//  IntegratedSimplePaymentDetailViewController.swift
//  NFTrack-Firebase4
//
//  Created by J C on 2021-10-20.
//

/*
 Abstract:
 The revised version of SimplePaymentDetailVC. It interacts with NFTrack instead of the SimplePayment contract.
 Displays the details of the item for sale.
 */

import UIKit
import FirebaseFirestore
import Combine

// for testing
import web3swift
import BigInt

class IntegratedSimplePaymentDetailViewController: ParentDetailViewController {
    final var historyVC: HistoryViewController!
    lazy final var historyVCHeightConstraint: NSLayoutConstraint = historyVC.view.heightAnchor.constraint(equalToConstant: 100)
    private var payButton: UIButton!
    final lazy var isPending: Bool = false {
        didSet {
            if isPending == true {
                DispatchQueue.main.async { [weak self] in
                    self?.pendingIndicatorView.isHidden = false
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.pendingIndicatorView.isHidden = true
                }
            }
        }
    }
    private var pendingIndicatorView: PendingIndicatorView!
    private var db: Firestore! {
        return FirebaseService.shared.db
    }
    private var socketDelegate: SocketDelegate!
    private var activityIndicatorView: UIActivityIndicatorView!
    private var txPackageRetainer: TxPackage!

    final override func userInfoDidSet() {
        super.userInfoDidSet()
 
        if userInfo.uid != userId {
            configureBuyerNavigationBar()
            fetchSavedPostData()
        } else if post.sellerUserId == userId {
            configureSellerNavigationBar()
        }
    }
    
    final override func viewDidLoad() {
        super.viewDidLoad()
        createSocket()        
    }
    
    final override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getStatus()
        // if the socket timed out, reconnect
        if let isSocketConnected = self.socketDelegate.socketProvider?.socket.isConnected,
           isSocketConnected == false {
            self.createSocket()
        }
    }
    
    final override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if socketDelegate != nil {
            socketDelegate.disconnectSocket()
        }
    }
    
    final override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        if let container = container as? HistoryViewController {
            // the height of the child VC's view has to be increased accordingly since it's set to be unscrollable.
            // this is so that the child VC's view doesn't scroll independently of the parent VC's view.
            historyVCHeightConstraint.constant = container.preferredContentSize.height
            
            var adjustedSize: CGSize!
            if let files = post.files, files.count > 0 {
                adjustedSize = CGSize(width: container.preferredContentSize.width, height: container.preferredContentSize.height + descLabel.bounds.size.height + 1200)
            } else {
                adjustedSize = CGSize(width: container.preferredContentSize.width, height: container.preferredContentSize.height + descLabel.bounds.size.height + 950)
            }
            
            self.scrollView.contentSize =  adjustedSize
        }
    }
    
    final override func configureSellerNavigationBar() {
        super.configureSellerNavigationBar()
        
        // 2 conditions have to be met for the edit button to be displayed:
        //  1. The user is the seller of this post.
        //  2. The status of the post is "ready" since no modification is allowed after the purchase.
        guard let status = SimplePaymentStatus(rawValue: post.status),
              status == .ready else {
            return
        }
        
        if self.navigationItem.rightBarButtonItems?.filter({ $0.tag == 11 }).count == 0 {
            self.postEditButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.buttonPressed(_:)))
            self.postEditButtonItem.tag = 11
            guard let postEditButtonItem = self.postEditButtonItem else { return }
            self.navigationItem.rightBarButtonItems?.append(postEditButtonItem)
        }
    }
}

extension IntegratedSimplePaymentDetailViewController {
    final override func configureUI() {
        super.configureUI()
        title = post.title
        
        pendingIndicatorView = PendingIndicatorView()
        pendingIndicatorView.isHidden = true
        pendingIndicatorView.buttonAction = { [weak self] _ in
            let infoVC = InfoViewController(infoModelArr: [InfoModel(title: "Pending Transaction", detail: InfoText.pending)])
            self?.present(infoVC, animated: true, completion: nil)
        }
        pendingIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(pendingIndicatorView)
        
        payButton = UIButton()
        payButton.backgroundColor = .black
        payButton.layer.cornerRadius = 5
        payButton.isEnabled = false
        payButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        payButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(payButton)
        
        activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = .white
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
        historyVC = HistoryViewController()
        historyVC.itemIdentifier = post.id
        addChild(historyVC)
        historyVC.view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(historyVC.view)
        historyVC.didMove(toParent: self)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        NSLayoutConstraint.activate([
            pendingIndicatorView.bottomAnchor.constraint(equalTo: listingSpecView.topAnchor, constant: -10),
            pendingIndicatorView.heightAnchor.constraint(equalTo: listDetailTitleLabel.heightAnchor, multiplier: 1.2),
            pendingIndicatorView.widthAnchor.constraint(equalToConstant: 100),
            pendingIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            payButton.topAnchor.constraint(equalTo: listingSpecView.bottomAnchor, constant: 40),
            payButton.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
            payButton.trailingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor),
            payButton.heightAnchor.constraint(equalToConstant: 50),
            
            activityIndicatorView.centerYAnchor.constraint(equalTo: payButton.centerYAnchor),
            activityIndicatorView.centerXAnchor.constraint(equalTo: payButton.centerXAnchor),
            
            historyVC.view.topAnchor.constraint(equalTo: payButton.bottomAnchor, constant: 40),
            historyVC.view.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
            historyVC.view.trailingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor),
            historyVCHeightConstraint,
        ])
    }
    
    @objc final override func buttonPressed(_ sender: UIButton) {
        switch sender.tag {
            case 0:
                callContractMethod(for: .abort, param: [post.solireyUid] as [AnyObject])
                break
            case 1:
                callContractMethod(for: .pay, param: [post.solireyUid] as [AnyObject], price: post.price)
                break
            case 2:
                callContractMethod(for: .withdraw, param: [post.solireyUid] as [AnyObject])
                break
            case 3:
                // resell
                let resaleVC = ResaleViewController()
                resaleVC.post = post
                resaleVC.title = "Resale"
                navigationController?.pushViewController(resaleVC, animated: true)
                break
            case 11:
                guard let postType = PostType(rawValue: self.post.type) else { return }
                
                if postType == .digital {
                    let listEditVC = DigitalListEditViewController()
                    listEditVC.delegate = self
                    listEditVC.post = post
                    self.navigationController?.pushViewController(listEditVC, animated: true)
                } else {
                    let listEditVC = TangibleListEditViewController()
                    listEditVC.delegate = self
                    listEditVC.post = post
                    listEditVC.userId = userId
                    self.navigationController?.pushViewController(listEditVC, animated: true)
                }
                break
            default:
                break
        }
    }
    
    // MARK: - configureStatusButton
    /// configures the pay button
    private func configureStatusButton(buttonTitle: String, tag: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.payButton.tag = tag
            self?.payButton.isEnabled = true
            self?.payButton.setTitle(buttonTitle, for: .normal)
        }
    }
}

extension IntegratedSimplePaymentDetailViewController: HandleError {
    // Dynamically determine what Solirey Integral Simplay Payment contract method to call
    private func callContractMethod(for method: SolireyContract.ContractMethods, param: [AnyObject] = [AnyObject](), price: String? = nil) {
        showSpinner()
        guard let integralTangibleSimplePaymentAddress = ContractAddresses.integralTangibleSimplePaymentAddress,
              let integralDigitalSimplePaymentAddress = ContractAddresses.integralDigitalSimplePaymentAddress else {
            self.alert.showDetail("Contract Address Needed", with: "Unable to retrieve the smart contract address.", for: self)
            return
        }
        
        guard let postType = PostType(rawValue: post.type) else {
            self.alert.showDetail("Error", with: "Unable to determine the item category.", for: self)
            return
        }
        
        // Since this detail VC is being used by both tangible and digital, the ABI and the address should be determined
        let isDigital = postType == .digital
        
        Deferred {
            Future<TxPackage, PostingError> { [weak self] promise in
                self?.transactionService.prepareTransactionForWritingWithGasEstimate(
                    method: method.rawValue,
                    abi: isDigital ? integralDigitalSimplePaymentABI : integralTangibleSimplePaymentABI,
                    param: param,
                    contractAddress: isDigital ? integralDigitalSimplePaymentAddress : integralTangibleSimplePaymentAddress,
                    amountString: price,
                    promise: promise
                )
            }
            .eraseToAnyPublisher()
        }
        .flatMap({ [weak self] (txPackage) -> AnyPublisher<(totalGasCost: String, balance: String, gasPriceInGwei: String), PostingError> in
            self?.txPackageRetainer = txPackage
            return Future<(totalGasCost: String, balance: String, gasPriceInGwei: String), PostingError> { promise in
                self?.transactionService.estimateGas(gasEstimate: txPackage.gasEstimate, promise: promise)
            }
            .eraseToAnyPublisher()
        })
        .sink {[weak self] (completion) in
            switch completion {
                case .failure(let error):
                    self?.processFailure(error)
                default:
                    break
            }
        } receiveValue: { [weak self] (estimates) in
            self?.hideSpinner()
            self?.executeTransaction(estimates: estimates, method: method)
        }
        .store(in: &storage)
    }
    
    private func executeTransaction(
        estimates: (totalGasCost: String, balance: String, gasPriceInGwei: String),
        method: SolireyContract.ContractMethods
    ) {
        guard let txPackageRetainer = self.txPackageRetainer else { return }
        
        let content = [
            StandardAlertContent(
                titleString: "Enter Your Password",
                body: [AlertModalDictionary.walletPasswordRequired: ""],
                isEditable: true,
                fieldViewHeight: 40,
                messageTextAlignment: .left,
                alertStyle: .withCancelButton
            ),
            StandardAlertContent(
                index: 1,
                titleString: "Gas Estimate",
                titleColor: UIColor.white,
                body: [
                    "Total Gas Units": txPackageRetainer.gasEstimate.description,
                    "Gas Price": "\(estimates.gasPriceInGwei) Gwei",
                    "Total Gas Cost": "\(estimates.totalGasCost) Ether",
                    "Your Current Balance": "\(estimates.balance) Ether"
                ],
                isEditable: false,
                fieldViewHeight: 40,
                messageTextAlignment: .left,
                alertStyle: .noButton
            ),
            StandardAlertContent(
                index: 2,
                titleString: "Tip",
                titleColor: UIColor.white,
                body: [
                    "": "\"Failed to locally sign a transaction\" usually means wrong password.",
                ],
                isEditable: false,
                fieldViewHeight: 100,
                messageTextAlignment: .left,
                alertStyle: .noButton
            )
        ]
        
        DispatchQueue.main.async { [weak self] in
            let alertVC = AlertViewController(height: 350, standardAlertContent: content)
            alertVC.action = { [weak self] (modal, mainVC) in
                mainVC.buttonAction = { _ in
                    guard let password = modal.dataDict[AlertModalDictionary.walletPasswordRequired],
                          !password.isEmpty else {
                        self?.alert.fading(text: "Password cannot be empty!", controller: mainVC, toBePasted: nil, width: 250)
                        return
                    }
                    self?.showSpinner()

                    // if the socket timed out, reconnect
                    if let isSocketConnected = self?.socketDelegate.socketProvider?.socket.isConnected,
                       isSocketConnected == false {
                        self?.createSocket()
                    }
                    
                    self?.dismiss(animated: true, completion: {
                        Deferred {
                            Future<TransactionSendingResult, PostingError> { promise in
                                do {
                                    guard let result = try self?.txPackageRetainer.transaction.send(password: password, transactionOptions: nil) else {
                                        promise(.failure(.generalError(reason: "Unable to execute the transaction.")))
                                        return
                                    }
                                    
                                    promise(.success(result))
                                } catch {
                                    promise(.failure(.generalError(reason: "Unable to execute the transaction.")))
                                }
                            }
                            .eraseToAnyPublisher()
                        }
                        .flatMap { [weak self] (txResult) -> AnyPublisher<Bool, PostingError> in
                            Future<Bool, PostingError> { promise in
                                self?.updateFirestore(
                                    txResult: txResult,
                                    method: method,
                                    promise: promise
                                )
                            }
                            .eraseToAnyPublisher()
                        }
                        .sink { [weak self] (completion) in
                            switch completion {
                                case .failure(let error):
                                    self?.processFailure(error)
                                    break
                                case .finished:
                                    switch method {
                                        case .pay:
                                            self?.alert.showDetail(
                                                "Success!",
                                                with: "You have successfully purchased the item.",
                                                for: self) {
                                                DispatchQueue.main.async {
                                                    self?.dismiss(animated: true, completion: nil)
                                                    self?.navigationController?.popViewController(animated: true)
                                                }
                                            } completion: {}
                                            break
                                        case .withdraw:
                                            self?.alert.showDetail(
                                                "Success!",
                                                with: "You have successfully withdrawn the fund to your account.",
                                                for: self) {
                                                DispatchQueue.main.async {
                                                    self?.dismiss(animated: true, completion: nil)
                                                    self?.navigationController?.popToRootViewController(animated: true)
                                                }
                                            } completion: {}
                                            break
                                        case .abort:
                                            self?.alert.showDetail(
                                                "Success!",
                                                with: "You have successfully aborted the sale.",
                                                for: self) {
                                                DispatchQueue.main.async {
                                                    self?.dismiss(animated: true, completion: nil)
                                                    self?.navigationController?.popViewController(animated: true)
                                                }
                                            } completion: {}
                                            break
                                        default:
                                            break
                                    }
                                    break
                            }
                        } receiveValue: { (finalValue) in
                            self?.hideSpinner()
                            print("finalValue", finalValue)
                        }
                        .store(in: &self!.storage)
                        
                    }) // dismiss
                } // mainVC
            } // alertVC
            self?.present(alertVC, animated: true, completion: nil)
        } // DispathQueue
    }
    
    private func updateFirestore(
        txResult: TransactionSendingResult,
        method: SolireyContract.ContractMethods,
        promise: @escaping (Result<Bool, PostingError>) -> Void
    ) {
        
        let ref = self.db.collection("post")
        var postData: [String: Any]!
        
        switch method {
            case .pay:
                guard let buyerHash = Web3swiftService.currentAddressString else {
                    promise(.failure(.generalError(reason: "Unable to fetch your wallet address.")))
                    return
                }
                
                guard let userId = self.userId else {
                    promise(.failure(.generalError(reason: "Unable to fetch the user information.")))
                    return
                }
                
                postData = [
                    "confirmPurchaseHash": txResult.hash,
                    "buyerHash": buyerHash,
                    "confirmPurchaseDate": Date(),
                    "transferDate": Date(),
                    "confirmReceivedDate": Date(),
                    "buyerUserId": userId,
                    "status": SimplePaymentStatus.transferred.rawValue,
                    "isWithdrawn": false,
                    "isAdminWithdrawn": false
                ]
                break
            case .withdraw:
                postData = [
                    "status": SimplePaymentStatus.complete.rawValue,
                    "isWithdrawn": true
                ]
                break
            case .abort:
                postData = ["status": SimplePaymentStatus.aborted.rawValue]
                break
            default:
                break
        }
        
        // txHash is either minting or transferring the ownership
        ref.document(post.documentId).updateData(postData) { (error) in
            if let _ = error {
                promise(.failure(.generalError(reason: "Error in updating the database.")))
            } else {
                promise(.success(true))
            }
        }
    }
}

extension IntegratedSimplePaymentDetailViewController {
    private func createSocket() {
        guard let contractAddress = ContractAddresses.integralTangibleSimplePaymentAddress else { return }
        Deferred {
            Future<[String:Any], PostingError> { [weak self] promise in
                self?.socketDelegate = SocketDelegate(contractAddress: contractAddress, promise: promise)
            }
        }
        .sink { (completion) in
            print(completion)
        } receiveValue: { [weak self] (WebSocketMessage) in
            guard let topics = WebSocketMessage["topics"] as? [String],
                  let txHash = WebSocketMessage["transactionHash"] as? String else { return }
            
            print("topics", topics)
            print("txHash", txHash)
            switch topics {
                case _ where topics.contains(Topics.SimplePaymentPurchased):
                    self?.isPending = true
                    self?.activityIndicatorView.startAnimating()
                    self?.payButton.isEnabled = false
                    self?.payButton.setTitle("", for: .normal)
//                    guard let executeReadTransaction = self?.executeReadTransaction else { return }
//                    self?.getContractInfo(transactionHash: txHash, executeReadTransaction: executeReadTransaction, contractAddress: contractAddress)
                default:
                    print("other events")
            }
        }
        .store(in: &storage)
    }
    
    func getStatus() {
        guard let status = SimplePaymentStatus(rawValue: post.status) else { return }
        
        guard let userId = self.userId else {
            self.alert.showDetail("User Info Needed", with: "Unable to retrieve your user info. Please try restarting the app.", for: self)
            return
        }
        
        switch status {
            case .ready:
                if userId == post.sellerUserId {
                    configureStatusButton(buttonTitle: "Abort", tag: 0)
                } else {
                    configureStatusButton(buttonTitle: "Pay Now", tag: 1)
                }
                break
            case .purchased, .transferred, .complete:
                if userId == post.sellerUserId {
                    configureStatusButton(buttonTitle: "Withdraw", tag: 2)
                } else if userId == post.buyerUserId {
                    configureStatusButton(buttonTitle: "Sell", tag: 3)
                } else {
                    configureStatusButton(buttonTitle: "Inactive", tag: 100)
                }
                break
            case .aborted:
                if userId == post.sellerUserId {
                    configureStatusButton(buttonTitle: "Sell", tag: 3)
                } else {
                    configureStatusButton(buttonTitle: "Inactive", tag: 100)
                }
                break
        }
        
        activityIndicatorView.stopAnimating()
    }
}
