//
//  ParentPostViewController + IntegralSimplePayment.swift
//  NFTrack-Firebase4
//
//  Created by J C on 2021-10-27.
//

/*
 Abtract:
 Direct sale revised is the most primitive method of payment where the buyer pays for an item and the ownership of the item is transferred right away, which means there is only one step for the buyer for the purchase.
 The seller mints a token and withdraws the fund after the purchase has been made, which means it takes two steps for the seller.
 It uses the NFTrack contract deployed by the admin and requires no deployments from the user's end.
 
 The code is in ParentPostVC because new sale and resale methods are to be used in tangible and digital both.
 
 The category parameter is needed to determine whether to use the integralTangibleSimplePaymentABI or the digital ABI. The difference between the two are whether the original creator of the token is accredited or not (former no, latter yes).
 */

import UIKit
import web3swift
import Combine
import BigInt

extension ParentPostViewController {
    // MARK: - processIntegralSimplePayment
    func processIntegralSimplePayment(
        method: SolireyContract.ContractMethods,
        transactionParameters: [AnyObject],
        isDigital: Bool
    ) -> AnyPublisher<TxPackage, PostingError> {
        Future<TxPackage, PostingError> { [weak self] promise in
            guard let integralTangibleSimplePaymentAddress = ContractAddresses.integralTangibleSimplePaymentAddress,
                  let integralDigitalSimplePaymentAddress = ContractAddresses.integralDigitalSimplePaymentAddress else {
                promise(.failure(PostingError.generalError(reason: "Unable to prepare the contract address.")))
                return
            }
            
            let contractAddress = isDigital ? integralDigitalSimplePaymentAddress : integralTangibleSimplePaymentAddress

            self?.transactionService.prepareTransactionForWritingWithGasEstimate(
                method: method.rawValue,
                abi: isDigital ? integralDigitalSimplePaymentABI : integralTangibleSimplePaymentABI,
                param: transactionParameters,
                contractAddress: contractAddress,
                amountString: nil,
                promise: promise
            )
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - executeIntegralAuction
    func executeIntegralSimplePayment(
        estimates: (totalGasCost: String, balance: String, gasPriceInGwei: String),
        mintParameters: MintParameters,
        txPackage: TxPackage,
        isDigital: Bool,
        isResale: Bool
    ) {
        guard let saleConfigValue = mintParameters.saleConfigValue else {
            self.alert.showDetail("Error", with: "Unable to get the sale to determine the sale type.", for: self)
            return
        }
        
        self.hideSpinner()

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
                    "Total Gas Units": txPackage.gasEstimate.description,
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

        self.hideSpinner()

        DispatchQueue.main.async { [weak self] in
            let alertVC = AlertViewController(height: 350, standardAlertContent: content)
            alertVC.action = { [weak self] (modal, mainVC) in
                mainVC.buttonAction = { _ in
                    guard let password = modal.dataDict[AlertModalDictionary.walletPasswordRequired],
                          !password.isEmpty else {
                        self?.alert.fading(text: "Password cannot be empty!", controller: mainVC, toBePasted: nil, width: 250)
                        return
                    }

                    self?.dismiss(animated: true, completion: {
                        guard let self = self else { return }

                        let progressModal = ProgressModalViewController(deliveryAndPaymentMethod: saleConfigValue)
                        progressModal.titleString = "Posting In Progress"
                        self.present(progressModal, animated: true, completion: {
                            Deferred { [weak self] () -> AnyPublisher<TxResult2, PostingError> in
                                guard let transactionService = self?.transactionService else {
                                    return Fail(error: PostingError.generalError(reason: "Unable to execute the transaction."))
                                        .eraseToAnyPublisher()
                                }

                                return transactionService.executeTransaction2(transaction: txPackage.transaction, password: password, type: .simplePayment)
                                    .eraseToAnyPublisher()
                            }
                            // get the topics of the mint event in the Solirey contract from the socket delegate and parse it
                            .flatMap { [weak self] (txResult) -> AnyPublisher<(txResult: TxResult2, tokenId: String), PostingError> in
                                let update: [String: PostProgress] = ["update": .estimatGas]
                                NotificationCenter.default.post(name: .didUpdateProgress, object: nil, userInfo: update)
                                                                
                                return Future<(txResult: TxResult2, tokenId: String), PostingError> { promise in
                                    self?.socketDelegate.didReceiveTopics = { webSocketMessage in
                                        print("webSocketMessage", webSocketMessage as Any)
                                        guard let txHash = webSocketMessage["transactionHash"] as? String,
                                                let topics = webSocketMessage["topics"] as? [String] else { return }
                                        
                                        let paddedTokenId = topics[3]
                                        
                                        guard let tokenId = Web3Utils.hexToBigUInt(paddedTokenId) else {
                                            promise(.failure(.generalError(reason: "Unable to parse the newly minted token ID.")))
                                            return
                                        }
                                        
                                        if txResult.txResult.hash == txHash {
                                            promise(.success((txResult: txResult, tokenId.description)))
                                        }
                                    }
                                }
                                .eraseToAnyPublisher()
                            }
                            .sink(receiveCompletion: { [weak self] (completion) in
                                switch completion {
                                    case .failure(let error):
                                        self?.processFailure(error)
                                    case .finished:
                                        break
                                }
                            }, receiveValue: { (returnedValue) in

                                // Get the Solirey ID by parsing the receipt from the minting transaction
                                self.transactionService.confirmReceipt(txHash: returnedValue.txResult.txResult.hash)
                                    .flatMap { (receipt) -> AnyPublisher<(id: String, tokenId: String, txPackage: TxResult2), PostingError> in
                                        Future<(id: String, tokenId: String, txPackage: TxResult2), PostingError> { promise in

                                            let web3 = Web3swiftService.web3instance
                                            guard let contract = web3.contract(
                                                    isDigital ? integralDigitalSimplePaymentABI : integralTangibleSimplePaymentABI,
                                                at: isDigital ? ContractAddresses.integralDigitalSimplePaymentAddress : ContractAddresses.integralTangibleSimplePaymentAddress,
                                                abiVersion: 2
                                            ) else {
                                                self.alert.showDetail("Error", with: "Unable to parse the transaction.", for: self)
                                                return
                                            }
  
                                            var id: String!
                                            
                                            for i in 0..<receipt.logs.count {
                                                let parsedEvent = contract.parseEvent(receipt.logs[i])
                                                
                                                switch parsedEvent.eventName {
                                                    case "CreatePayment":
                                                        if let parsedData = parsedEvent.eventData,
                                                           let _id = parsedData["id"] as? BigUInt {
                                                            id = _id.description
                                                        } else {
                                                            promise(.failure(.emptyResult))
                                                        }
                                                        break
//                                                    case "Transfer":
//                                                        if let parsedData = parsedEvent.eventData,
//                                                           let _tokenId = parsedData["tokenId"] as? BigUInt {
//                                                            tokenId = _tokenId.description
//                                                        } else {
//                                                            promise(.failure(.emptyResult))
//                                                        }
//                                                        break
                                                    default:
                                                        break
                                                }
                                            }
                                            promise(.success((id: id, tokenId: returnedValue.tokenId, txPackage: returnedValue.txResult)))
                                        }
                                        .eraseToAnyPublisher()
                                    }
                                    .sink { [weak self] (completion) in
                                        switch completion {
                                            case .failure(let error):
                                                self?.processFailure(error)
                                            case .finished:
                                                break
                                        }
                                    } receiveValue: { [weak self] (txInfo) in
                                        if self?.socketDelegate != nil {
                                            self?.socketDelegate.disconnectSocket()
                                        }
                                        
                                        let updateEvent: PostProgress = isResale ? .transferToken : .minting
                                        let update: [String: PostProgress] = ["update": updateEvent]
                                        NotificationCenter.default.post(name: .didUpdateProgress, object: nil, userInfo: update)
                                        self?.updateFirestoreForSimplePayment(
                                            txInfo: txInfo,
                                            mintParameters: mintParameters
                                        )
                                    }
                                    .store(in: &self.storage)
                            })
                            .store(in: &self.storage)
                        }) // self?.present
                    }) // self?.dismiss
                } // mainVC.buttonAction
            } // alertVC.action
            self?.present(alertVC, animated: true, completion: nil)
        } // dispatch
    }

    func updateFirestoreForSimplePayment(
        txInfo: (id: String, tokenId: String, txPackage: TxResult2),
        mintParameters: MintParameters
    ) {
//        guard let previewDataArr = self.previewDataArr, previewDataArr.count == 1 else {
//            alert.showDetail("Error", with: "A single digital asset is required.", for: self)
//            return
//        }

        var fileURLs: [AnyPublisher<String?, PostingError>]!

        // Use the existing file path if this is reselling. No need to upload to the Storage.
        // Since the remote image's url is used to display the digital image during the resale (not the local directory URL)
        // the attempt to use uploadFileWithPromise will result in no image found.
        if let post = self.post,
           let files = post.files,
           let filePath = files.first {

            let resellURLPromise = Future<String?, PostingError> { promise in
                promise(.success(filePath))
            }
            .eraseToAnyPublisher()

            fileURLs = [resellURLPromise]
        } else {
            fileURLs = previewDataArr.map { (previewData) -> AnyPublisher<String?, PostingError> in
                return Future<String?, PostingError> { promise in
                    self.uploadFileWithPromise(
                        fileURL: previewData.filePath,
                        userId: mintParameters.userId,
                        promise: promise
                    )
                }.eraseToAnyPublisher()
            }
        }

        Publishers.MergeMany(fileURLs)
            .collect()
            .eraseToAnyPublisher()
            // upload the details to Firestore
            .flatMap { [weak self] (urlStrings) -> AnyPublisher<Bool, PostingError> in
                let update: [String: PostProgress] = ["update": .images]
                NotificationCenter.default.post(name: .didUpdateProgress, object: nil, userInfo: update)

                guard let self = self,
                      let currentAddressString = Web3swiftService.currentAddressString else {
                    return Fail(error: PostingError.generalError(reason: "Unable to prepare data for the database update."))
                        .eraseToAnyPublisher()
                }

                return Future<Bool, PostingError> { promise in
                    self.transactionService.createFireStoreEntryRevised(
                        documentId: &self.documentId,
                        senderAddress: currentAddressString,
                        escrowHash: "N/A",
                        auctionHash: "N/A",
                        mintHash: txInfo.txPackage.txResult.hash,
                        itemTitle: mintParameters.itemTitle,
                        desc: mintParameters.desc,
                        price: mintParameters.price ?? "N/A",
                        category: mintParameters.category,
                        tokensArr: mintParameters.tokensArr,
                        convertedId: mintParameters.convertedId,
                        type: mintParameters.postType,
                        deliveryMethod: mintParameters.deliveryMethod,
                        saleFormat: mintParameters.saleFormat,
                        paymentMethod: mintParameters.paymentMethod,
                        tokenId: txInfo.tokenId,
                        urlStrings: urlStrings,
                        ipfsURLStrings: [],
                        shippingInfo: self.shippingInfo,
                        isWithdrawn: false,
                        isAdminWithdrawn: false,
                        solireyUid: txInfo.id,
                        contractFormat: mintParameters.contractFormat,
                        bidders: [self.userId],
                        promise: promise
                    )
                }
                .eraseToAnyPublisher()
            }
            .sink { [weak self] (completion) in
                switch completion {
                    case .failure(let error):
                        self?.processFailure(error)
                    case .finished:
                        self?.afterPostReset()

                        DispatchQueue.main.async { [weak self] in
                            guard let `self` = self else { return }
                            self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: self.SCROLLVIEW_CONTENTSIZE_DEFAULT_HEIGHT)
                            
                            UIView.animate(withDuration: 0.5) { [weak self] in
                                self?.view.layoutIfNeeded()
                            }
                        }

                        guard let documentId = self?.documentId else { return }
                        FirebaseService.shared.sendToTopicsVoid(
                            title: "New item has been listed on \(mintParameters.category)",
                            content: mintParameters.itemTitle,
                            topic: mintParameters.category,
                            docId: documentId
                        )

                        self?.storage.removeAll()
                    //  register spotlight?
                }
            } receiveValue: { (_) in
            }
            .store(in: &self.storage)
    }
//
//    // Revised SimplePayment embedded in NFTrack
//    // MARK: - New Sale
//    final func processIntegralSimplePayment(_ mintParameters: MintParameters, isAddressRequired: Bool, postType: PostType) {
//        guard let price = mintParameters.price,
//              !price.isEmpty,
//              let priceInWei = Web3.Utils.parseToBigUInt(price, units: .eth) else {
//            self.alert.showDetail("Incomplete", with: "Please specify the price.", for: self)
//            return
//        }
//
//        // change to this after testing
//        //        guard let convertedPrice = Double(price), convertedPrice > 0.01 else {
//        //            self.alert.showDetail("Price Limist", with: "The price has to be greater than 0.01 ETH.", for: self)
//        //            return
//        //        }
//
//        if isAddressRequired {
//            guard let shippingAddress = self.addressLabel.text, !shippingAddress.isEmpty else {
//                self.alert.showDetail("Incomplete", with: "Please select the shipping restrictions.", for: self)
//                return
//            }
//        }
//
//        guard let NFTrackABIRevisedAddress = ContractAddresses.NFTrackABIRevisedAddress else {
//            self.alert.showDetail("Error", with: "Unable to get the smart contract address.", for: self)
//            return
//        }
//
//        // ** important ** this is not deprecated
//        // create an ID for the new item to be saved into the _simplePayment mapping.
////        let combinedString = self.ref.document().documentID + mintParameters.userId
////        let inputData = Data(combinedString.utf8)
////        let hashedId = SHA256.hash(data: inputData)
////        let hashString = hashedId.compactMap { String(format: "%02x", $0) }.joined()
////        self.simplePaymentId = hashString
//
//        // The parameters for the createSimplePayment method
//        let param: [AnyObject] = [priceInWei] as [AnyObject]
//
//        Deferred { [weak self] in
//            Future<Bool, PostingError> { promise in
//                self?.db.collection("post")
//                    .whereField("itemIdentifier", isEqualTo: mintParameters.convertedId)
//                    .whereField("status", isNotEqualTo: "complete")
//                    .getDocuments() { (querySnapshot, err) in
//                        if let err = err {
//                            print("error from the duplicate check", err)
//                            promise(.failure(PostingError.generalError(reason: "Unable to check for the Unique Identifier duplicates")))
//                            return
//                        }
//
//                        if let querySnapshot = querySnapshot, querySnapshot.isEmpty {
//                            promise(.success(true))
//                        } else {
//                            promise(.failure(PostingError.generalError(reason: "The item already exists. Please resell it through the app instead of selling it as a new item.")))
//                        }
//                    }
//            }
//        }
//        .flatMap { (_) -> AnyPublisher<TxPackage, PostingError> in
//            Future<TxPackage, PostingError> { [weak self] promise in
//                self?.transactionService.prepareTransactionForWritingWithGasEstimate(
//                    method: NFTrackContract.ContractMethods.createSimplePayment.rawValue,
//                    abi: NFTrackABIRevisedABI,
//                    param: param,
//                    contractAddress: NFTrackABIRevisedAddress,
//                    amountString: nil,
//                    promise: promise
//                )
//            }
//            .eraseToAnyPublisher()
//        }
//        .flatMap({ [weak self] (txPackage) -> AnyPublisher<(totalGasCost: String, balance: String, gasPriceInGwei: String), PostingError> in
//            self?.txPackageArr.append(txPackage)
//            return Future<(totalGasCost: String, balance: String, gasPriceInGwei: String), PostingError> { promise in
//                self?.transactionService.estimateGas(
//                    gasEstimate: txPackage.gasEstimate,
//                    promise: promise
//                )
//            }
//            .eraseToAnyPublisher()
//        })
//        .sink { [weak self] (completion) in
//            switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    self?.processFailure(error)
//                    break
//            }
//        } receiveValue: { [weak self] (estimates) in
//            self?.hideSpinner()
//            self?.executeTransaction(
//                estimates: estimates,
//                mintParameters: mintParameters,
//                postType: postType
//            )
//        }
//        .store(in: &storage)
//    }
    
    private func executeTransaction(
        estimates: (totalGasCost: String, balance: String, gasPriceInGwei: String),
        mintParameters: MintParameters,
        postType: PostType
    ) {
        var txResultRetainer: TransactionSendingResult!
        var tokenIdRetainer: String!
        
        guard let txPackageRetainer = self.txPackageArr.first,
              let NFTrackABIRevisedAddress = ContractAddresses.integralTangibleSimplePaymentAddress else { return }
        
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
                    self?.socketDelegate = SocketDelegate(contractAddress: NFTrackABIRevisedAddress, topics: [Topics.SimplePaymentMint])
                    
                    self?.dismiss(animated: true, completion: {
                        let progressModal = ProgressModalViewController(paymentMethod: .directTransfer)
                        progressModal.titleString = "Posting In Progress"
                        self?.present(progressModal, animated: true, completion: {
                            Deferred {
                                Future<TransactionSendingResult, PostingError> { promise in
                                    DispatchQueue.global().async {
                                        do {
                                            let result = try txPackageRetainer.transaction.send(password: password, transactionOptions: nil)
                                            promise(.success(result))
                                        } catch {
                                            promise(.failure(.generalError(reason: "Unable to execute the transaction.")))
                                        }
                                    }
                                }
                                .eraseToAnyPublisher()
                            }
                            // get the topics of the paymentMade event from the socket delegate and parse it
                            .flatMap { [weak self] (txResult) -> AnyPublisher<String, PostingError> in
                                let update: [String: PostProgress] = ["update": .estimatGas]
                                NotificationCenter.default.post(name: .didUpdateProgress, object: nil, userInfo: update)
                                
                                txResultRetainer = txResult
                                
                                return Future<String, PostingError> { promise in
                                    self?.socketDelegate.didReceiveTopics = { webSocketMessage in
                                        guard let topics = webSocketMessage["topics"] as? [String] else { return }
                                        
                                        let fromAddress = topics[2]
                                        let paddedTokenId = topics[3]
                                        
                                        guard let tokenId = Web3Utils.hexToBigUInt(paddedTokenId) else {
                                            promise(.failure(.generalError(reason: "Unable to parse the newly minted token ID.")))
                                            return
                                        }
                                        
                                        let data = Data(hex: fromAddress)
                                        guard let decodedFromAddress = ABIDecoder.decode(types: [.address], data:data)?.first as? EthereumAddress else {
                                            promise(.failure(.generalError(reason: "Unable to decode the contract address.")))
                                            return
                                        }
                                        
                                        if decodedFromAddress == Web3swiftService.currentAddress {
                                            promise(.success(tokenId.description))
                                        }
                                    }
                                }
                                .eraseToAnyPublisher()
                            }
                            .flatMap({ [weak self] (tokenId) -> AnyPublisher<[String?], PostingError> in
                                tokenIdRetainer = tokenId
                                
                                let update: [String: PostProgress] = ["update": .minting]
                                NotificationCenter.default.post(name: .didUpdateProgress, object: nil, userInfo: update)
                                
                                // upload images/files to the Firebase Storage and get the array of URLs
                                if let previewDataArr = self?.previewDataArr, previewDataArr.count > 0 {
                                    let fileURLs = previewDataArr.map { (previewData) -> AnyPublisher<String?, PostingError> in
                                        return Future<String?, PostingError> { promise in
                                            self?.uploadFileWithPromise(
                                                fileURL: previewData.filePath,
                                                userId: mintParameters.userId,
                                                promise: promise
                                            )
                                        }.eraseToAnyPublisher()
                                    }
                                    return Publishers.MergeMany(fileURLs)
                                        .collect()
                                        .eraseToAnyPublisher()
                                } else {
                                    // if there are none to upload, return an empty array
                                    return Result.Publisher([] as [String]).eraseToAnyPublisher()
                                }
                            })
                            // upload the details to Firestore
                            .flatMap { [weak self] (urlStrings) -> AnyPublisher<Bool, PostingError> in
                                let update: [String: PostProgress] = ["update": .images]
                                NotificationCenter.default.post(name: .didUpdateProgress, object: nil, userInfo: update)
                                
                                guard let self = self,
                                      let currentAddressString = Web3swiftService.currentAddressString else {
                                    return Fail(error: PostingError.generalError(reason: "Unable to prepare data for the database update."))
                                        .eraseToAnyPublisher()
                                }
                                
                                return Future<Bool, PostingError> { promise in
                                    self.transactionService.createFireStoreEntryRevised(
                                        documentId: &self.documentId,
                                        senderAddress: currentAddressString,
                                        escrowHash: "N/A",
                                        auctionHash: "N/A",
                                        mintHash: txResultRetainer.hash,
                                        itemTitle: mintParameters.itemTitle,
                                        desc: mintParameters.desc,
                                        price: mintParameters.price!,
                                        category: mintParameters.category,
                                        tokensArr: mintParameters.tokensArr,
                                        convertedId: mintParameters.convertedId,
                                        type: postType.asString(),
                                        deliveryMethod: mintParameters.deliveryMethod,
                                        saleFormat: mintParameters.saleFormat,
                                        paymentMethod: mintParameters.paymentMethod,
                                        tokenId: tokenIdRetainer,
                                        urlStrings: urlStrings,
                                        ipfsURLStrings: [],
                                        shippingInfo: self.shippingInfo,
                                        solireyUid: "something",
                                        contractFormat: mintParameters.contractFormat,
                                        promise: promise
                                    )
                                }
                                .eraseToAnyPublisher()
                            }
                            .sink { [weak self] (completion) in
                                switch completion {
                                    case .failure(let error):
                                        self?.processFailure(error)
                                    case .finished:
                                        self?.afterPostReset()
                                        
                                        guard let documentId = self?.documentId else { return }
                                        FirebaseService.shared.sendToTopicsVoid(
                                            title: "New item has been listed on \(mintParameters.category)",
                                            content: mintParameters.itemTitle,
                                            topic: mintParameters.category,
                                            docId: documentId
                                        )
                                        
                                    //  register spotlight?
                                }
                            } receiveValue: { [weak self] (_) in
                                if self?.socketDelegate != nil {
                                    self?.socketDelegate.disconnectSocket()
                                }
                            }
                            .store(in: &self!.storage)
                        }) // ProgressVC
                    }) // self.dismiss
                } // mainVC
            } // alertVC
            self?.present(alertVC, animated: true, completion: nil)
        } // DispatchQueue
    }
}

// MARK: - Resale
extension ParentPostViewController {
    final func processDirectResaleRevised(_ mintParameters: MintParameters, isAddressRequired: Bool, postType: PostType) {
        
        // ** important now deprecated
        // create an ID for the existing item to be saved into the _simplePayment mapping as a new posting.
//        let combinedString = self.ref.document().documentID + mintParameters.userId
//        let inputData = Data(combinedString.utf8)
//        let hashedId = SHA256.hash(data: inputData)
//        let hashString = hashedId.compactMap { String(format: "%02x", $0) }.joined()
//        self.simplePaymentId = hashString
        
        guard let tokenID = post?.tokenID,
              let tokenIDNumber = NumberFormatter().number(from: tokenID) else {
            self.alert.showDetail("Error", with: "Unable to retrieve the token ID to resell. Please try restarting the app.", for: self)
            return
        }
        
        guard let price = mintParameters.price,
              !price.isEmpty,
              let priceInWei = Web3.Utils.parseToBigUInt(price, units: .eth) else {
            self.alert.showDetail("Incomplete", with: "Please specify the price.", for: self)
            return
        }
        
        // change to this after testing
        //        guard let convertedPrice = Double(price), convertedPrice > 0.01 else {
        //            self.alert.showDetail("Price Limist", with: "The price has to be greater than 0.01 ETH.", for: self)
        //            return
        //        }
        
        if isAddressRequired {
            guard let shippingAddress = self.addressLabel.text, !shippingAddress.isEmpty else {
                self.alert.showDetail("Incomplete", with: "Please select the shipping restrictions.", for: self)
                return
            }
        }
        
        guard let NFTrackABIRevisedAddress = ContractAddresses.NFTrackABIRevisedAddress else {
            self.alert.showDetail("Error", with: "Unable to get the smart contract address.", for: self)
            return
        }
        
        let param: [AnyObject] = [priceInWei, tokenIDNumber] as [AnyObject]
        
        Deferred { [weak self] in
            Future<Bool, PostingError> { promise in
                self?.db.collection("post")
                    .whereField("itemIdentifier", isEqualTo: mintParameters.convertedId)
                    .whereField("status", isNotEqualTo: "complete")
                    .getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print(err)
                            promise(.failure(PostingError.generalError(reason: "Unable to check for the Unique Identifier duplicates")))
                            return
                        }
                        
                        if let querySnapshot = querySnapshot, querySnapshot.isEmpty {
                            promise(.success(true))
                        } else {
                            promise(.failure(PostingError.generalError(reason: "The item already exists. Please resell it through the app instead of selling it as a new item.")))
                        }
                    }
            }
        }
        .flatMap { (isDuplicate) -> AnyPublisher<TxPackage, PostingError> in
            Future<TxPackage, PostingError> { [weak self] promise in
                self?.transactionService.prepareTransactionForWritingWithGasEstimate(
                    method: NFTrackContract.ContractMethods.resell.rawValue,
                    abi: NFTrackABIRevisedABI,
                    param: param,
                    contractAddress: NFTrackABIRevisedAddress,
                    amountString: nil,
                    promise: promise
                )
            }
            .eraseToAnyPublisher()
        }
        .flatMap({ [weak self] (txPackage) -> AnyPublisher<(totalGasCost: String, balance: String, gasPriceInGwei: String), PostingError> in
            self?.txPackageArr.append(txPackage)
            return Future<(totalGasCost: String, balance: String, gasPriceInGwei: String), PostingError> { promise in
                self?.transactionService.estimateGas(
                    gasEstimate: txPackage.gasEstimate,
                    promise: promise
                )
            }
            .eraseToAnyPublisher()
        })
        .sink { [weak self] (completion) in
            switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.processFailure(error)
                    break
            }
        } receiveValue: { [weak self] (estimates) in
            self?.hideSpinner()
            self?.executeTransactionForResale(
                estimates: estimates,
                mintParameters: mintParameters,
                postType: postType
            )
        }
        .store(in: &storage)
    }
    
    private func executeTransactionForResale(
        estimates: (totalGasCost: String, balance: String, gasPriceInGwei: String),
        mintParameters: MintParameters,
        postType: PostType
    ) {
        var txResultRetainer: TransactionSendingResult!
        
        guard let txPackageRetainer = self.txPackageArr.first,
              let NFTrackABIRevisedAddress = ContractAddresses.NFTrackABIRevisedAddress else { return }
        
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
                    self?.socketDelegate = SocketDelegate(contractAddress: NFTrackABIRevisedAddress, topics: [Topics.SimplePaymentMint])
                    
                    self?.dismiss(animated: true, completion: {
                        Deferred {
                            Future<TransactionSendingResult, PostingError> { promise in
                                DispatchQueue.global().async {
                                    do {
                                        let result = try txPackageRetainer.transaction.send(password: password, transactionOptions: nil)
                                        promise(.success(result))
                                    } catch {
                                        promise(.failure(.generalError(reason: "Unable to execute the transaction.")))
                                    }
                                }
                            }
                            .eraseToAnyPublisher()
                        }
                        .flatMap({ [weak self] (txResult) -> AnyPublisher<[String?], PostingError> in
                            txResultRetainer = txResult
                            
                            // upload images/files to the Firebase Storage and get the array of URLs
                            if let previewDataArr = self?.previewDataArr, previewDataArr.count > 0 {
                                let fileURLs = previewDataArr.map { (previewData) -> AnyPublisher<String?, PostingError> in
                                    return Future<String?, PostingError> { promise in
                                        self?.uploadFileWithPromise(
                                            fileURL: previewData.filePath,
                                            userId: mintParameters.userId,
                                            promise: promise
                                        )
                                    }.eraseToAnyPublisher()
                                }
                                return Publishers.MergeMany(fileURLs)
                                    .collect()
                                    .eraseToAnyPublisher()
                            } else {
                                // if there are none to upload, return an empty array
                                return Result.Publisher([] as [String]).eraseToAnyPublisher()
                            }
                        })
                        // upload the details to Firestore
                        .flatMap { [weak self] (urlStrings) -> AnyPublisher<Bool, PostingError> in
                            guard let self = self,
                                  let currentAddressString = Web3swiftService.currentAddressString,
                                  let tokenId = self.post?.tokenID else {
                                return Fail(error: PostingError.generalError(reason: "Unable to prepare data for the database update."))
                                    .eraseToAnyPublisher()
                            }
                            
                            return Future<Bool, PostingError> { promise in
                                self.transactionService.createFireStoreEntryRevised(
                                    documentId: &self.documentId,
                                    senderAddress: currentAddressString,
                                    escrowHash: "N/A",
                                    auctionHash: "N/A",
                                    mintHash: txResultRetainer.hash,
                                    itemTitle: mintParameters.itemTitle,
                                    desc: mintParameters.desc,
                                    price: mintParameters.price!,
                                    category: mintParameters.category,
                                    tokensArr: mintParameters.tokensArr,
                                    convertedId: mintParameters.convertedId,
                                    type: postType.asString(),
                                    deliveryMethod: mintParameters.deliveryMethod,
                                    saleFormat: mintParameters.saleFormat,
                                    paymentMethod: mintParameters.paymentMethod,
                                    tokenId: tokenId,
                                    urlStrings: urlStrings,
                                    ipfsURLStrings: [],
                                    shippingInfo: self.shippingInfo,
                                    solireyUid: "something",
                                    contractFormat: mintParameters.contractFormat,
                                    promise: promise
                                )
                            }
                            .eraseToAnyPublisher()
                        }
                        .sink { [weak self] (completion) in
                            switch completion {
                                case .failure(let error):
                                    self?.processFailure(error)
                                case .finished:
                                    self?.alert.showDetail(
                                        "Success!",
                                        with: "You have successfully posted your item.",
                                        for: self,
                                        buttonAction: {
                                            self?.dismiss(animated: true, completion: {
                                                self?.navigationController?.popToRootViewController(animated: true)
                                            })
                                        }
                                    )
                                    
                                    self?.afterPostReset()
                                    
                                    guard let documentId = self?.documentId else { return }
                                    FirebaseService.shared.sendToTopicsVoid(
                                        title: "New item has been listed on \(mintParameters.category)",
                                        content: mintParameters.itemTitle,
                                        topic: mintParameters.category,
                                        docId: documentId
                                    )
                                    
                                //  register spotlight?
                            }
                        } receiveValue: { [weak self] (_) in
                            if self?.socketDelegate != nil {
                                self?.socketDelegate.disconnectSocket()
                            }
                        }
                        .store(in: &self!.storage)
                    }) // self.dismiss
                } // mainVC
            } // alertVC
            self?.present(alertVC, animated: true, completion: nil)
        } // DispatchQueue
    }
}
