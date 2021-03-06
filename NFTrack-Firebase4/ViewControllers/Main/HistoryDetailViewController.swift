//
//  HistoryDetailViewController.swift
//  NFTrack-Firebase4
//
//  Created by J C on 2021-06-04.
//

import UIKit

class HistoryDetailViewController: ParentDetailViewController {
    private var ownerTitleHash: UILabel!
    private var ownerHash: UILabelPadding!
    private var escrowHashTitleLabel: UILabel!
    private var escrowHashLabel: UILabelPadding!
    private var mintHashTitleLabel: UILabel!
    private var mintHashLabel: UILabelPadding!
    private var confirmPurchaseHashTitleLabel: UILabel!
    private var confirmPurchaseLabel: UILabelPadding!
    private var transferTitleLabel: UILabel!
    private var transferLabel: UILabel!
    private var confirmReceivedHashTitleLabel: UILabel!
    private var confirmReceivedHashLabel: UILabelPadding!
    
    final override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if post.status != "ready",
           let _ = post.confirmPurchaseHash,
           let _ = post.confirmReceivedHash {
            scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: descLabel.bounds.size.height + 1700)
        } else {
            scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: descLabel.bounds.size.height + 1400)
        }
    }
}

extension HistoryDetailViewController {
    final override func configureUI() {
        super.configureUI()
        title = post.title
        
        ownerTitleHash = createTitleLabel(text: "Owner Address")
        scrollView.addSubview(ownerTitleHash)
        
        ownerHash = createLabel(text: post.sellerHash, hashType: .address, target: self, action: #selector(tapped))
        ownerHash.tag = 3
        ownerHash.lineBreakMode = .byClipping
        ownerHash.numberOfLines = 0
        ownerHash.sizeToFit()
        scrollView.addSubview(ownerHash)
        
        escrowHashTitleLabel = createTitleLabel(text: "Escrow Tx Hash")
        scrollView.addSubview(escrowHashTitleLabel)
        
        escrowHashLabel = createLabel(text: post.escrowHash ?? "N/A", hashType: .tx, target: self, action: #selector(tapped))
        escrowHashLabel.tag = 2
        escrowHashLabel.lineBreakMode = .byClipping
        escrowHashLabel.numberOfLines = 0
        escrowHashLabel.sizeToFit()
        scrollView.addSubview(escrowHashLabel)
        
        mintHashTitleLabel = createTitleLabel(text: "Mint Tx Hash")
        scrollView.addSubview(mintHashTitleLabel)
        
        mintHashLabel = createLabel(text: post.mintHash, hashType: .tx, target: self, action: #selector(tapped))
        mintHashLabel.tag = 2
        mintHashLabel.lineBreakMode = .byClipping
        mintHashLabel.numberOfLines = 0
        mintHashLabel.sizeToFit()
        scrollView.addSubview(mintHashLabel)

        if post.status != "ready",
           let confirmPurchaseHash = post.confirmPurchaseHash,
           let confirmReceivedHash = post.confirmReceivedHash {
            confirmPurchaseHashTitleLabel = createTitleLabel(text: "Purchase Tx Hash")
            scrollView.addSubview(confirmPurchaseHashTitleLabel)
            
            confirmPurchaseLabel = createLabel(text: confirmPurchaseHash, hashType: .tx, target: self, action: #selector(tapped))
            confirmPurchaseLabel.tag = 2
            confirmPurchaseLabel.lineBreakMode = .byClipping
            confirmPurchaseLabel.numberOfLines = 0
            confirmPurchaseLabel.sizeToFit()
            scrollView.addSubview(confirmPurchaseLabel)
            
            transferTitleLabel = createTitleLabel(text: "Transfer Tx Hash")
            scrollView.addSubview(transferTitleLabel)
            
            transferLabel = createLabel(text: confirmReceivedHash, hashType: .tx, target: self, action: #selector(tapped))
            transferLabel.tag = 2
            transferLabel.lineBreakMode = .byClipping
            transferLabel.numberOfLines = 0
            transferLabel.sizeToFit()
            scrollView.addSubview(transferLabel)
            
            confirmReceivedHashTitleLabel = createTitleLabel(text: "Confirm Received Tx Hash")
            scrollView.addSubview(confirmReceivedHashTitleLabel)
            
            confirmReceivedHashLabel = createLabel(text: confirmReceivedHash, hashType: .tx, target: self, action: #selector(tapped))
            confirmReceivedHashLabel.tag = 2
            confirmReceivedHashLabel.lineBreakMode = .byClipping
            confirmReceivedHashLabel.numberOfLines = 0
            confirmReceivedHashLabel.sizeToFit()
            scrollView.addSubview(confirmReceivedHashLabel)
        }
    }
    
    final override func setConstraints() {
        super.setConstraints()
        
        NSLayoutConstraint.activate([
            ownerTitleHash.topAnchor.constraint(equalTo: listingSpecView.bottomAnchor, constant: 40),
            ownerTitleHash.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
            ownerTitleHash.trailingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor),
            
            ownerHash.topAnchor.constraint(equalTo: ownerTitleHash.bottomAnchor, constant: 10),
            ownerHash.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
            ownerHash.trailingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor),
            ownerHash.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            
            escrowHashTitleLabel.topAnchor.constraint(equalTo: ownerHash.bottomAnchor, constant: 40),
            escrowHashTitleLabel.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
            escrowHashTitleLabel.trailingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor),
            
            escrowHashLabel.topAnchor.constraint(equalTo: escrowHashTitleLabel.bottomAnchor, constant: 10),
            escrowHashLabel.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
            escrowHashLabel.trailingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor),
            escrowHashLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            
            mintHashTitleLabel.topAnchor.constraint(equalTo: escrowHashLabel.bottomAnchor, constant: 40),
            mintHashTitleLabel.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
            mintHashTitleLabel.trailingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor),
            
            mintHashLabel.topAnchor.constraint(equalTo: mintHashTitleLabel.bottomAnchor, constant: 10),
            mintHashLabel.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
            mintHashLabel.trailingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor),
            mintHashLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
        ])
        
        if post.status != "ready",
           let _ = post.confirmPurchaseHash,
           let _ = post.confirmReceivedHash {
            
            NSLayoutConstraint.activate([
                confirmPurchaseHashTitleLabel.topAnchor.constraint(equalTo: mintHashLabel.bottomAnchor, constant: 40),
                confirmPurchaseHashTitleLabel.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
                confirmPurchaseHashTitleLabel.trailingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor),
                
                confirmPurchaseLabel.topAnchor.constraint(equalTo: confirmPurchaseHashTitleLabel.bottomAnchor, constant: 10),
                confirmPurchaseLabel.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
                confirmPurchaseLabel.trailingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor),
                confirmPurchaseLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
                
                transferTitleLabel.topAnchor.constraint(equalTo: confirmPurchaseLabel.bottomAnchor, constant: 40),
                transferTitleLabel.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
                transferTitleLabel.trailingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor),
                
                transferLabel.topAnchor.constraint(equalTo: transferTitleLabel.bottomAnchor, constant: 10),
                transferLabel.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
                transferLabel.trailingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor),
                transferLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
                
                confirmReceivedHashTitleLabel.topAnchor.constraint(equalTo: transferLabel.bottomAnchor, constant: 40),
                confirmReceivedHashTitleLabel.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
                confirmReceivedHashTitleLabel.trailingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor),
                
                confirmReceivedHashLabel.topAnchor.constraint(equalTo: confirmReceivedHashTitleLabel.bottomAnchor, constant: 10),
                confirmReceivedHashLabel.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
                confirmReceivedHashLabel.trailingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor),
                confirmReceivedHashLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            ])
        }
    }
    
    override func configureResale() {
        mintHashLabel.isUserInteractionEnabled = false
    }
}

extension HistoryDetailViewController {
    @objc override func tapped(_ sender: UITapGestureRecognizer) {
        super.tapped(sender)
        
        let tag = sender.view?.tag
        switch tag {
            case 2:
                if let label = sender.view as? UILabel, let text = label.text {
                    let webVC = WebViewController()
                    let hashType = "tx"
                    webVC.urlString = "https://rinkeby.etherscan.io/\(hashType)/\(text)"
                    self.navigationController?.pushViewController(webVC, animated: true)
                }
            case 3:
                if let label = sender.view as? UILabel, let text = label.text {
                    let webVC = WebViewController()
                    let hashType = "address"
                    webVC.urlString = "https://rinkeby.etherscan.io/\(hashType)/\(text)"
                    self.navigationController?.pushViewController(webVC, animated: true)
                }
            default:
                break
        }
    }
}
