//
//  SocketDelegate.swift
//  NFTrack-Firebase4
//
//  Created by J C on 2021-05-29.
//

import UIKit
import web3swift

class SocketDelegate: Web3SocketDelegate {
    var socketProvider: InfuraWebsocketProvider? = nil
    
    // document ID for firestore
    var id: String!
    
    var contractAddress: String!
    // NFTrack
    // "0x656f9bf02fa8eff800f383e5678e699ce2788c5c"
    weak var delegate: MessageDelegate?
    
    init(contractAddress: String, id: String) {
        self.id = id
        self.contractAddress = contractAddress
        configure()
    }
    
    deinit {
        if socketProvider != nil {
            socketProvider!.disconnectSocket()
        }
    }
    
    // Protocol method, here will be messages, received from WebSocket server
    func received(message: Any) {
        if let dict = message as? [String: Any], let topics = dict["topics"] as? [String] {
            delegate?.didReceiveMessage(topics: topics)
        }
    }
    
    func gotError(error: Error) {
        print("error", error)
    }
    
    func configure() {
        self.socketProvider = InfuraWebsocketProvider("wss://rinkeby.infura.io/ws/v3/d011663e021f45e1b07ef4603e28ba90", delegate: self)
        self.socketProvider?.connectSocket()
        
        do {
            // NFTrack contract
            try self.socketProvider!.subscribeOnLogs(addresses: [EthereumAddress(contractAddress)!], topics: [])
            //0x3957f5858e98ff8e02f5866b2f2fb11cd4a7183f30cff52401b8d15c2a07b0c8
            //0x2fb30cfca4728c7f62d6787ef949fc7943d813f5093ebc6c343c6cc6f3ec1a56

        } catch {
            print("socket error", error)
        }
    }
}




//    func configureFirebase() {
//        let settings = FirestoreSettings()
//        Firestore.firestore().settings = settings
//        db = Firestore.firestore()
//    }

//"hexString": "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef",
//"topics": [
//"0x0000000000000000000000000000000000000000000000000000000000000000",
//"0x0000000000000000000000006879f0a123056b5bb56c7e787cf64a67f3a16a71",
//"0x0000000000000000000000000000000000000000000000000000000000000030"
//]
