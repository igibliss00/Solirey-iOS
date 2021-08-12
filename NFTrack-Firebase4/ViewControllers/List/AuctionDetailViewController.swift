//
//  AuctionDetailViewController.swift
//  NFTrack-Firebase4
//
//  Created by J C on 2021-07-13.
//

/*
 Abstract:
 The screen for an auction prior to bidding
 Update the status and the date of each step: bid, ended, and transferred.  These three are for the ProgressCell indicator.
 */

import UIKit
import Combine
import web3swift
import BigInt
import FirebaseAuth
import FirebaseFirestore
import FirebaseMessaging

struct AuctionContract {
    enum AuctionMethods: String {
        case bid
        case withdraw
        case auctionEnd
        case getTheHighestBid
        case transferToken
    }
    
    enum AuctionProperties {
        case startingBid
        case highestBid
        case highestBidder
        case auctionEndTime
        case ended
        case pendingReturns(EthereumAddress)
        case beneficiary
  
        // tuple because some properties like mapping requires a key
        var value: (String, AnyObject?) {
            switch self {
                case .startingBid:
                    return ("startingBid", nil)
                case .highestBid:
                    return ("highestBid", nil)
                case .highestBidder:
                    return ("highestBidder", nil)
                case .auctionEndTime:
                    return ("auctionEndTime", nil)
                case .ended:
                    return ("ended", nil)
                case .pendingReturns(let parameter):
                    return ("pendingReturns", parameter as AnyObject)
                case .beneficiary:
                    return ("beneficiary", nil)
            }
        }
        
        func toDisplay() -> String {
            switch self {
                case .startingBid:
                    return "Starting Bid"
                case .highestBid:
                    return "Highest Bid"
                case .highestBidder:
                    return "Highest Bidder"
                case .auctionEndTime:
                    return "Auction End Time"
                case .ended:
                    return "Auction Status"
                case .pendingReturns(_):
                    return "Amount To Withdraw"
                case .beneficiary:
                    return "Beneficiary"
            }
        }
    
//        static func allCasesString() -> [String] {
//            return AuctionProperties.allCases.map { $0.rawValue }
//        }
    }
}

class AuctionDetailViewController: ParentDetailViewController {
    final var historyVC: HistoryViewController!
    lazy final var historyVCHeightConstraint: NSLayoutConstraint = historyVC.view.heightAnchor.constraint(equalToConstant: 100)
    final var auctionDetailTitleLabel: UILabel!
    final var moreDetailsButton: UIButton!
    final var auctionSpecView: SpecDisplayView!
    final var storage = Set<AnyCancellable>()
    final var bidContainer: UIView!
    final var bidTextField: UITextField!
    final var auctionButton: UIButton!
    final let LIST_DETAIL_MARGIN: CGFloat = 10
    final var propertiesToLoad: [AuctionContract.AuctionProperties]!
    lazy final var auctionDetailArr: [SmartContractProperty] = propertiesToLoad.map { SmartContractProperty(propertyName: $0.toDisplay(), propertyDesc: "loading...")}
    lazy final var auctionButtonNarrowConstraint: NSLayoutConstraint! = auctionButton.widthAnchor.constraint(equalTo: bidContainer.widthAnchor, multiplier: 0.45)
    lazy final var auctionButtonWideConstraint: NSLayoutConstraint! = auctionButton.widthAnchor.constraint(equalTo: bidContainer.widthAnchor, multiplier: 1)
    final var auctionContractAddress: EthereumAddress!
    final var socketDelegate: SocketDelegate!
    // indicator to show whether the transaction is pending or not
    // it means the current highest bidder/bidding price will likely change
    lazy var isPending: Bool = false {
        didSet {
            if isPending == true {
                DispatchQueue.main.async { [weak self] in
                    print("self?.pendingContainer.isHidden", self?.pendingContainer.isHidden as Any)
                    self?.pendingContainer.isHidden = false
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    print("self?.pendingContainer.isHidden", self?.pendingContainer.isHidden as Any)
                    self?.pendingContainer.isHidden = true
                }
            }
        }
    }
    final var pendingContainer: UIView!
    final var pendingLabel: UILabel!
    final var activityIndicatorView: UIActivityIndicatorView!
    final var pendingReturnButton: UIButton!
    final var txResult: TxResult!
    final var auctionButtonController: AuctionButtonController!
    final var pendingReturnButtonConstraints = [NSLayoutConstraint]()
    final var pendingReturnActivityIndicatorView: UIActivityIndicatorView!
    final var db: Firestore! {
        return FirebaseService.shared.db
    }
    
    init(auctionContractAddress: EthereumAddress, myContractAddress: EthereumAddress) {
        super.init(nibName: nil, bundle: nil)
        
        self.contractAddress = myContractAddress
        self.auctionContractAddress = auctionContractAddress
        
        self.propertiesToLoad = [
            AuctionContract.AuctionProperties.startingBid,
            AuctionContract.AuctionProperties.highestBid,
            AuctionContract.AuctionProperties.highestBidder,
            AuctionContract.AuctionProperties.auctionEndTime,
            AuctionContract.AuctionProperties.ended,
            AuctionContract.AuctionProperties.pendingReturns(myContractAddress),
            AuctionContract.AuctionProperties.beneficiary
        ]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    final override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        if let container = container as? HistoryViewController {
            // the height of the child VC's view has to be increased accordingly since it's set to be unscrollable.
            // this is so that the child VC's view doesn't scroll independently of the parent VC's view.
            historyVCHeightConstraint.constant = container.preferredContentSize.height
            
            var adjustedSize: CGSize!
            if let files = post.files, files.count > 0 {
                adjustedSize = CGSize(width: container.preferredContentSize.width, height: container.preferredContentSize.height + descLabel.bounds.size.height + 1500)
            } else {
                adjustedSize = CGSize(width: container.preferredContentSize.width, height: container.preferredContentSize.height + descLabel.bounds.size.height + 1250)
            }
            
            self.scrollView.contentSize =  adjustedSize
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let auctionHash = post.auctionHash else { return }
        getAuctionInfo(transactionHash: auctionHash, contractAddress: auctionContractAddress)
        addKeyboardObserver()
    }
    
    final override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if socketDelegate != nil {
            socketDelegate.disconnectSocket()
        }
        removeKeyboardObserver()
        
        if let timer = auctionButtonController.timer {
            timer.invalidate()
        }
    }
    
    deinit {
        if let timer = auctionButtonController.timer {
            timer.invalidate()
        }
    }
}

extension AuctionDetailViewController: UITextFieldDelegate {
    final override func configureUI() {
        super.configureUI()
        self.hideKeyboardWhenTappedAround()
        auctionButtonController = AuctionButtonController()
        
        title = post.title

        historyVC = HistoryViewController()
        historyVC.itemIdentifier = post.id
        addChild(historyVC)
        historyVC.view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(historyVC.view)
        historyVC.didMove(toParent: self)
        
        auctionDetailTitleLabel = createTitleLabel(text: "Auction Detail")
        auctionDetailTitleLabel.isUserInteractionEnabled = true
        auctionDetailTitleLabel.sizeToFit()
        scrollView.addSubview(auctionDetailTitleLabel)
        
        pendingContainer = UIView()
        pendingContainer.isHidden = true
        pendingContainer.translatesAutoresizingMaskIntoConstraints = false
        pendingContainer.backgroundColor = UIColor(red: 204/255, green: 255/255, blue: 204/255, alpha: 1)
        pendingContainer.layer.cornerRadius = 8
        pendingContainer.tag = 3
        let pendingContainerTap = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        pendingContainer.addGestureRecognizer(pendingContainerTap)
        scrollView.addSubview(pendingContainer)

        activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.startAnimating()
        activityIndicatorView.color = UIColor(red: 0/255, green: 155/255, blue: 0/255, alpha: 1)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        pendingContainer.addSubview(activityIndicatorView)

        pendingLabel = createTitleLabel(text: "Pending", weight: .light)
        pendingLabel.font = UIFont.systemFont(ofSize: 12)
        pendingLabel.textColor = UIColor(red: 0/255, green: 155/255, blue: 0/204, alpha: 1)
        pendingContainer.addSubview(pendingLabel)
        
        moreDetailsButton = UIButton(type: .system)
        moreDetailsButton.setTitle("More Details", for: .normal)
        moreDetailsButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        moreDetailsButton.layer.borderWidth = 0.5
        moreDetailsButton.layer.borderColor = UIColor.lightGray.cgColor
        moreDetailsButton.layer.cornerRadius = 7
        moreDetailsButton.tag = 2
        moreDetailsButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        moreDetailsButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(moreDetailsButton)
        
        auctionSpecView = SpecDisplayView(listingDetailArr: auctionDetailArr)
        auctionSpecView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(auctionSpecView)
        
        bidContainer = UIView()
        bidContainer.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(bidContainer)
        
        bidTextField = createTextField(placeHolder: "In ETH", delegate: self)
        bidTextField.keyboardType = .decimalPad
        bidContainer.addSubview(bidTextField)
        
        auctionButton = UIButton()
        auctionButton.backgroundColor = .black
        auctionButton.layer.cornerRadius = 5
        auctionButton.setTitle("Bid Now", for: .normal)
        auctionButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        auctionButton.translatesAutoresizingMaskIntoConstraints = false
        bidContainer.addSubview(auctionButton)
    }
    
    final override func setConstraints() {
        super.setConstraints()
        
        auctionButtonNarrowConstraint.isActive = true

        NSLayoutConstraint.activate([
            auctionDetailTitleLabel.topAnchor.constraint(equalTo: listingSpecView.bottomAnchor, constant: 40),
            auctionDetailTitleLabel.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
            
            pendingContainer.topAnchor.constraint(equalTo: listingSpecView.bottomAnchor, constant: 40),
            pendingContainer.leadingAnchor.constraint(equalTo: auctionDetailTitleLabel.trailingAnchor, constant: 20),
            pendingContainer.heightAnchor.constraint(equalTo: auctionDetailTitleLabel.heightAnchor),
            pendingContainer.widthAnchor.constraint(equalToConstant: 100),

            activityIndicatorView.leadingAnchor.constraint(equalTo: pendingContainer.leadingAnchor),
            activityIndicatorView.heightAnchor.constraint(equalToConstant: 30),
            activityIndicatorView.centerYAnchor.constraint(equalTo: pendingContainer.centerYAnchor),
            activityIndicatorView.widthAnchor.constraint(equalTo: activityIndicatorView.heightAnchor),

            pendingLabel.leadingAnchor.constraint(equalTo: activityIndicatorView.trailingAnchor, constant: 5),
            pendingLabel.trailingAnchor.constraint(equalTo: pendingContainer.trailingAnchor),
            pendingLabel.heightAnchor.constraint(equalTo: pendingContainer.heightAnchor),

            moreDetailsButton.topAnchor.constraint(equalTo: listingSpecView.bottomAnchor, constant: 40),
            moreDetailsButton.trailingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor),
            moreDetailsButton.heightAnchor.constraint(equalTo: auctionDetailTitleLabel.heightAnchor),
            moreDetailsButton.widthAnchor.constraint(equalToConstant: 100),
            
            auctionSpecView.topAnchor.constraint(equalTo: auctionDetailTitleLabel.bottomAnchor, constant: 10),
            auctionSpecView.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
            auctionSpecView.trailingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor),
            auctionSpecView.heightAnchor.constraint(equalToConstant: CGFloat(auctionDetailArr.count) * LIST_DETAIL_HEIGHT + LIST_DETAIL_MARGIN),
            
            bidContainer.topAnchor.constraint(equalTo: auctionSpecView.bottomAnchor, constant: 40),
            bidContainer.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
            bidContainer.trailingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor),
            bidContainer.heightAnchor.constraint(equalToConstant: 50),
            
            bidTextField.leadingAnchor.constraint(equalTo: bidContainer.leadingAnchor),
            bidTextField.widthAnchor.constraint(equalTo: bidContainer.widthAnchor, multiplier: 0.45),
            bidTextField.heightAnchor.constraint(equalTo: bidContainer.heightAnchor),
            
            auctionButton.trailingAnchor.constraint(equalTo: bidContainer.trailingAnchor),
            auctionButton.heightAnchor.constraint(equalTo: bidContainer.heightAnchor),

            historyVC.view.topAnchor.constraint(equalTo: auctionButton.bottomAnchor, constant: 40),
            historyVC.view.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
            historyVC.view.trailingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor),
            historyVCHeightConstraint,
        ])
    }
    
    func createPendingContainer() {
        pendingContainer = UIView()
        pendingContainer.isHidden = true
        pendingContainer.translatesAutoresizingMaskIntoConstraints = false
        pendingContainer.backgroundColor = UIColor(red: 204/255, green: 255/255, blue: 204/255, alpha: 1)
        pendingContainer.layer.cornerRadius = 8
        pendingContainer.tag = 3
        let pendingContainerTap = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        pendingContainer.addGestureRecognizer(pendingContainerTap)
        scrollView.addSubview(pendingContainer)
        
        activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.startAnimating()
        activityIndicatorView.color = UIColor(red: 0/255, green: 155/255, blue: 0/255, alpha: 1)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        pendingContainer.addSubview(activityIndicatorView)
        
        pendingLabel = createTitleLabel(text: "Pending", weight: .light)
        pendingLabel.font = UIFont.systemFont(ofSize: 12)
        pendingLabel.textColor = UIColor(red: 0/255, green: 155/255, blue: 0/204, alpha: 1)
        pendingContainer.addSubview(pendingLabel)
        
        NSLayoutConstraint.activate([
            pendingContainer.topAnchor.constraint(equalTo: listingSpecView.bottomAnchor, constant: 40),
            pendingContainer.leadingAnchor.constraint(equalTo: auctionDetailTitleLabel.trailingAnchor, constant: 20),
            pendingContainer.heightAnchor.constraint(equalTo: auctionDetailTitleLabel.heightAnchor),
            pendingContainer.widthAnchor.constraint(equalToConstant: 100),
            
            activityIndicatorView.leadingAnchor.constraint(equalTo: pendingContainer.leadingAnchor),
            activityIndicatorView.heightAnchor.constraint(equalToConstant: 30),
            activityIndicatorView.centerYAnchor.constraint(equalTo: pendingContainer.centerYAnchor),
            activityIndicatorView.widthAnchor.constraint(equalTo: activityIndicatorView.heightAnchor),
            
            pendingLabel.leadingAnchor.constraint(equalTo: activityIndicatorView.trailingAnchor, constant: 5),
            pendingLabel.trailingAnchor.constraint(equalTo: pendingContainer.trailingAnchor),
            pendingLabel.heightAnchor.constraint(equalTo: pendingContainer.heightAnchor),
        ])
    }
    
    @objc final func buttonPressed(_ sender: UIButton) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator.impactOccurred()
        
        switch sender.tag {
            case 0:
                bid()
                break
            case 1:
                callAuctionMethod(for: .auctionEnd)
                break
            case 2:
                // more details button
                guard let auctionContractAddress = auctionContractAddress else { return }
                let webVC = WebViewController()
                webVC.urlString = "https://rinkeby.etherscan.io/address/\(auctionContractAddress.address)"
                self.navigationController?.pushViewController(webVC, animated: true)
                break
            case 3:
                callAuctionMethod(for: .getTheHighestBid)
            case 5:
                callAuctionMethod(for: .transferToken)
            case 60:
                callAuctionMethod(for: .withdraw)
            case 61:
                let infoVC = InfoViewController(infoModelArr: [InfoModel(title: "Withdrawal", detail: InfoText.withdrawPrior)])
                self.present(infoVC, animated: true, completion: nil)
            case 62:
                let infoVC = InfoViewController(infoModelArr: [InfoModel(title: "Status", detail: InfoText.auctionStatus)])
                self.present(infoVC, animated: true, completion: nil)
            default:
                break
        }
    }
    
    @objc override func tapped(_ sender: UITapGestureRecognizer!) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator.impactOccurred()
        super.tapped(sender)
        let tag = sender.view?.tag

        switch tag {
            case 3:
                let infoVC = InfoViewController(infoModelArr: [InfoModel(title: "Pending Transaction", detail: InfoText.pending)])
                self.present(infoVC, animated: true, completion: nil)
            default:
                break
        }
    }
    
    // the big button
    final func setButtonStatus(as status: AuctionContract.AuctionMethods) {
        DispatchQueue.main.async { [weak self] in
            guard self?.auctionButtonNarrowConstraint != nil,
                  self?.auctionButtonWideConstraint != nil else { return }
            
            switch status {
                case .bid:
                    self?.bidTextField.isEnabled = true
                    self?.bidTextField.alpha = 1
                    
                    // might already be narrow
                    self?.auctionButtonNarrowConstraint.isActive = false
                    self?.auctionButtonWideConstraint.isActive = false
                    self?.auctionButtonNarrowConstraint.isActive = true
                    
                    self?.auctionButton.setTitle("Bid Now", for: .normal)
                    self?.auctionButton.tag = 0
                case .auctionEnd:
                    self?.bidTextField.isEnabled = false
                    self?.bidTextField.alpha = 0
                    
                    self?.auctionButtonNarrowConstraint.isActive = false
                    self?.auctionButtonWideConstraint.isActive = true
                    self?.auctionButton.setTitle("End Auction", for: .normal)
                    self?.auctionButton.tag = 1
                case .getTheHighestBid:
                    self?.auctionButtonNarrowConstraint.isActive = false
                    self?.auctionButtonWideConstraint.isActive = true
                    self?.auctionButton.setTitle("Claim The Final Bid", for: .normal)
                    self?.auctionButton.tag = 3
                case .transferToken:
                    self?.bidTextField.isEnabled = false
                    self?.bidTextField.alpha = 0
                    
                    self?.auctionButtonNarrowConstraint.isActive = false
                    self?.auctionButtonWideConstraint.isActive = true
                    
                    self?.auctionButton.setTitle("Transfer the Ownership", for: .normal)
                    self?.auctionButton.tag = 5
                default:
                    break
            }
            
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    final func bid() {
        guard auctionButtonController.isAuctionEnded == false else {
            self.alert.showDetail("Sorry", with: "The auction has already ended", for: self)
            return
        }
        
        guard let bidAmount = bidTextField.text, !bidAmount.isEmpty else {
            self.alert.showDetail("Bid Amount Error", with: "The bid amount cannot be empty.", for: self)
            return
        }

        guard Double(bidAmount) != nil else {
            self.alert.showDetail("Bid Format Error", with: "The bid amount has to be in a numeric form", for: self)
            return
        }
        
        guard let bidAmountNumber = NumberFormatter().number(from: bidAmount), bidAmountNumber.doubleValue > 0 else {
            self.alert.showDetail("Bid Amount Error", with: "The bid amount has to be greater than zero.", for: self)
            return
        }
        
        callAuctionMethod(for: AuctionContract.AuctionMethods.bid, amountString: bidAmount)
    }
    
    func callAuctionMethod(for method: AuctionContract.AuctionMethods, amountString: String? = nil) {
        var content = [
            StandardAlertContent(
                index: 0,
                titleString: "Password",
                body: [AlertModalDictionary.passwordSubtitle: ""],
                isEditable: true,
                fieldViewHeight: 40,
                messageTextAlignment: .left,
                alertStyle: .withCancelButton
            ),
            StandardAlertContent(
                index: 1,
                titleString: "Details",
                body: [
                    AlertModalDictionary.gasLimit: "",
                    AlertModalDictionary.gasPrice: "",
                    AlertModalDictionary.nonce: ""
                ],
                isEditable: true,
                fieldViewHeight: 40,
                messageTextAlignment: .left,
                alertStyle: .noButton
            )
        ]
        
        // auxiliary info to be displayed to the user before the execution
        let withDrawInfo = StandardAlertContent(
            index: 2,
            titleString: "Withdrawal",
            body: [
                "": InfoText.withdraw
            ],
            messageTextAlignment: .left
        )
        
        switch method {
            case .withdraw:
                content.append(withDrawInfo)
            default:
                break
        }
        
        let alertVC = AlertViewController(height: 350, standardAlertContent: content)
        alertVC.action = { [weak self] (modal, mainVC) in
            // responses to the main vc's button
            mainVC.buttonAction = { _ in
                guard let password = modal.dataDict[AlertModalDictionary.passwordSubtitle],
                      !password.isEmpty else {
                    self?.alert.fading(text: "Email cannot be empty!", controller: mainVC, toBePasted: nil, width: 200)
                    return
                }
                
                guard let self = self else { return }
                self.dismiss(animated: true, completion: {
                    self.showSpinner {
                        
                        Future<WriteTransaction, PostingError> { promise in
                            guard let auctionContractAddress = self.auctionContractAddress else {
                                promise(.failure(.generalError(reason: "Unable to load the address for the auction contract.")))
                                return
                            }
                            
                            // if the socket timed out, reconnect
                            if let isSocketConnected = self.socketDelegate.socketProvider?.socket.isConnected,
                               isSocketConnected == false {
                                self.createSocket()
                            }
                            
                            self.transactionService.prepareTransactionForWriting(
                                method: method.rawValue,
                                abi: auctionABI,
                                contractAddress: auctionContractAddress,
                                amountString: amountString ?? "0",
                                promise: promise
                            )
                        }
                        .flatMap { (transaction) -> Future<TxResult, PostingError> in
                            self.transactionService.executeTransaction(
                                transaction: transaction,
                                password: password,
                                type: .AuctionContract
                            )
                        }
                        .flatMap({ (txResult) -> AnyPublisher<Data, PostingError> in
                            self.txResult = txResult
                            switch method {
                                case .bid:
                                    // let's every user involved in the auction (who has previously bid before) know through the push notification that there's been a new bid
                                    if let fcmToken = UserDefaults.standard.string(forKey: UserDefaultKeys.fcmToken),
                                       let userId = UserDefaults.standard.string(forKey: UserDefaultKeys.userId) {
                                        
                                        // the update of the status and the date is to display the progress on ProgressCell
                                        self.db.collection("post").document(self.post.documentId).updateData([
                                            "bidderTokens": FieldValue.arrayUnion([fcmToken]),
                                            "bidders": FieldValue.arrayUnion([userId]),
                                            "status": AuctionStatus.bid.rawValue,
                                            "bidDate": Date()
                                        ], completion: { (error) in
                                            if let error = error {
                                                print("firebase error", error)
                                            }
                                        })
                                    }

                                    Messaging.messaging().unsubscribe(fromTopic: self.post.documentId) { error in
                                        print("unsubscribed to \(self.post.documentId ?? "")")
                                    }

                                    return FirebaseService.shared.sendToTopics(
                                        title: "Auction Bid",
                                        topic: self.post.documentId,
                                        content: "A new bid was made in your auction."
                                    )
                                case .auctionEnd:
                                    // socket will utimately pick up the topics of the event emitted at the time the "auctionEnd" method is called
                                    // but setting the isAuctionOfficiallyEnded property here to true as an insurance in case the socket doesn't pick up the topics (i.e. the internet connection failure)
                                    self.auctionButtonController.isAuctionOfficiallyEnded = true
                                    
                                    self.db.collection("post").document(self.post.documentId).updateData([
                                        "status": AuctionStatus.ended.rawValue,
                                        "auctionEndDate": Date()
                                    ])
                                    return FirebaseService.shared.unsubscribeToTopic(topic: self.post.documentId)
                                case .withdraw:
                                    NotificationCenter.default.post(name: .auctionDidWithdraw, object: true)
                                    return Result.Publisher(Data()).eraseToAnyPublisher()
                                case .transferToken:
                                    self.db.collection("post").document(self.post.documentId).updateData([
                                        "status": AuctionStatus.transferred.rawValue,
                                        "auctionTransferredDate": Date()
                                    ])
                                    return Result.Publisher(Data()).eraseToAnyPublisher()
                                default:
                                    return Result.Publisher(Data()).eraseToAnyPublisher()
                            }
                        })
                        .sink { (completion) in
                            switch completion {
                                case .failure(let error):
                                    switch error {
                                        case .generalError(reason: let msg):
                                            self.alert.showDetail("Error", with: msg, for: self)
                                        case .apiError(.decodingError):
                                            self.alert.showDetail("Decoding Error", with: "There was a decoding error from HTTP's response.", for: self)
                                        case .apiError(.generalError(reason: let err)):
                                            self.alert.showDetail("Network Error", with: err, for: self)
                                        default:
                                            self.alert.showDetail("Error", with: "There was an error executing this process.", for: self)
                                    }
                                    break
                                case .finished:
                                    switch method {
                                        case .auctionEnd:
                                            self.alert.showDetail("Auction Ended", with: "Congratulations. You have officially ended the auction! The winner can now transfer the item and the beneficiary can withdraw the fund.", for: self)
                                            self.tableViewRefreshDelegate?.didRefreshTableView(index: 2)
                                        case .bid:
                                            self.alert.showDetail("Bid Success!", with: "You have made a successful bid. It'll take a few moment to be reflected on the blockchain.", for: self, completion:  {
                                                self.bidTextField.text?.removeAll()
                                                
                                                Messaging.messaging().subscribe(toTopic: self.post.documentId) { error in
                                                    print("Subscribed to \(self.post.documentId ?? "") topic")
                                                }
                                            })
                                        case .getTheHighestBid:
                                            self.alert.showDetail("Success!", with: "You have successfully withdrawn the final bid. It'll be reflected on your wallet soon.", for: self)
                                        case .transferToken:
                                            self.alert.showDetail("Congratulations!", with: "You are now the proud owner of the item. It'll take a few moment to be reflected on the app.", for: self)
                                        case .withdraw:
                                            self.alert.showDetail("Bid Withdraw", with: "You have successfully withdrawn the previous bid amount.", for: self)
                                            // the properties has to be manually refetched because the withDraw method doesn't have the events (which means no topics), therefore doesn't trigger the socket event
                                            print("self.txResult.txHash", self.txResult.txHash)
                                            DispatchQueue.main.async {
                                                self.getAuctionInfo(transactionHash: self.txResult.txHash, contractAddress: self.auctionContractAddress)
                                            }
                                    }
                                    break
                            }
                        } receiveValue: { (_) in }
                        .store(in: &self.storage)
                    } // showSpinner
                }) // self.dismiss
            } // mainVC
        } // alertVC
        self.present(alertVC, animated: true, completion: nil)
    } // callAuctionMethod
}

extension AuctionDetailViewController {
    // MARK: - addKeyboardObserver
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - removeKeyboardObserver
    private func removeKeyboardObserver(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        //Need to calculate keyboard exact size due to Apple suggestions
        let info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize!.height, right: 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.bidTextField {
            if (!aRect.contains(activeField.frame.origin)){
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        //Once keyboard disappears, restore original positions
        self.scrollView.contentInset = .zero
        self.scrollView.scrollIndicatorInsets = .zero
        self.view.endEditing(true)
    }
}

