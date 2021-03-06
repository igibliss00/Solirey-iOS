//
//  ToolBarView.swift
//  NFTrack-Firebase4
//
//  Created by J C on 2021-06-10.
//

import UIKit
import CryptoKit

class ToolBarView : UIView {
    var textView: UITextView!
    //    var textViewHeight: CGFloat = 50
    var sendButton: UIButton!
    var buttonAction: ((Int)->Void)?
    var imageButton: UIButton!
    
    var internalHeight : CGFloat = 200 {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    override var intrinsicContentSize: CGSize {
        return CGSize(width:300, height:self.internalHeight)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ToolBarView: UITextViewDelegate {
    func configure() {
        self.backgroundColor = .white
        
        addSeparator()
        
        let photoImageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light, scale: .small)
        guard let image = UIImage(systemName: "photo")?.withTintColor(.gray, renderingMode: .alwaysOriginal).withConfiguration(photoImageConfig) else { return }
        imageButton = UIButton.systemButton(with: image, target: self, action: #selector(buttonHandler))
        imageButton.tag = 1
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageButton)
        
        textView = UITextView(frame: CGRect(x: 4, y: 4, width: 0, height: 0))
        textView.delegate = self
        textView.text = "Enter your message"
        textView.font = UIFont.systemFont(ofSize: 18)
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        //        textView.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textView.frame.size = CGSize(width: fixedWidth, height: newSize.height)
        internalHeight = newSize.height
        textView.textColor = .lightGray
        textView.layer.cornerRadius = 30
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textView)
        
        var sendImage: UIImage!
        if #available(iOS 14.0, *) {
            sendImage = UIImage(systemName: "paperplane.circle.fill")
        } else {
            sendImage = UIImage(systemName: "arrow.up.circle.fill")
        }
        
        let configuration = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .medium)
        let configuredImage = sendImage.withConfiguration(configuration)
        sendButton = UIButton.systemButton(with: configuredImage, target: self, action: #selector(buttonHandler))
        sendButton.tag = 2
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(sendButton)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            imageButton.widthAnchor.constraint(equalToConstant: 60),
            imageButton.heightAnchor.constraint(equalToConstant: 60),
            imageButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageButton.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),

            textView.leadingAnchor.constraint(equalTo: imageButton.trailingAnchor, constant: 0),
            textView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -10),
            textView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -20),
            textView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            sendButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2),
            sendButton.heightAnchor.constraint(equalTo: self.heightAnchor),
            sendButton.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    @objc func buttonHandler(_ sender: UIButton!) {
        if let buttonAction = self.buttonAction {
            buttonAction(sender.tag)
        }
    }
    
    func addSeparator() {
        let v = UIView()
        v.backgroundColor = UIColor.lightGray
        v.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(v)
        
        NSLayoutConstraint.activate([
            v.topAnchor.constraint(equalTo: self.topAnchor),
            v.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            v.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = UIColor.black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter your message"
            textView.textColor = UIColor.lightGray
        }
    }
}
