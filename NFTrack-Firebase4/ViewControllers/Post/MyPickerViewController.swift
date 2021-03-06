//
//  MyPickerViewController.swift
//  NFTrack-Firebase4
//
//  Created by J C on 2021-05-22.
//

import UIKit

class MyPickerVC : UIInputViewController {
    var currentPep: String!
    var pep: [String]!
    
    init(currentPep: String, pep: [String]) {
        super.init(nibName: nil, bundle: nil)
        self.currentPep = currentPep
        self.pep = pep
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        let iv = self.inputView!
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        let p = UIPickerView()
        p.delegate = self
        p.dataSource = self
        iv.addSubview(p)
        p.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            p.topAnchor.constraint(equalTo: iv.topAnchor),
            p.bottomAnchor.constraint(equalTo: iv.bottomAnchor),
            p.leadingAnchor.constraint(equalTo: iv.leadingAnchor),
            p.trailingAnchor.constraint(equalTo: iv.trailingAnchor),
        ])
    }
}

extension MyPickerVC : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pep.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pep[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.currentPep = self.pep[row]
        return // interesting experiment but I think I'll enter it on dismissal
        //        let doc = self.textDocumentProxy
        //        if let s = doc.documentContextAfterInput {
        //            doc.adjustTextPosition(byCharacterOffset: s.count)
        //        }
        //        delay(0.1) {
        //            while doc.hasText {
        //                doc.deleteBackward()
        //            }
        //            doc.insertText(self.pep[row])
        //        }
    }
}
