//
//  MyDoneButtonVC.swift
//  NFTrack-Firebase4
//
//  Created by J C on 2021-05-22.
//

import UIKit

protocol HandleDone: AnyObject {
    func handleDone()
}
// you can optionally use a protocol for the delegate to be more precise

class MyDoneButtonVC : UIInputViewController {
    weak var delegate : UIViewController?
    override func viewDidLoad() {
        
        let iv = self.inputView!
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.allowsSelfSizing = true // crucial
        let b = UIButton(type: .system)
        b.tintColor = .black
        b.setTitle("Done", for: .normal)
//        b.sizeToFit()
        b.addTarget(self, action: #selector(doDone), for: .touchUpInside)
        b.backgroundColor = UIColor.lightGray
        b.layer.zPosition = 100
        iv.addSubview(b)
        b.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
//            iv.topAnchor.constraint(equalTo: view.topAnchor),
            iv.heightAnchor.constraint(equalToConstant: 50),
            iv.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            iv.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            iv.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            b.topAnchor.constraint(equalTo: iv.topAnchor),
            b.bottomAnchor.constraint(equalTo: iv.bottomAnchor),
            b.leadingAnchor.constraint(equalTo: iv.leadingAnchor),
            b.trailingAnchor.constraint(equalTo: iv.trailingAnchor),
        ])
    }
    
    @objc func doDone() {
        if let del = self.delegate {
            (del as AnyObject).doDone?()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func traitCollectionDidChange(_ prev: UITraitCollection?) {
        super.traitCollectionDidChange(prev)
    }
}
