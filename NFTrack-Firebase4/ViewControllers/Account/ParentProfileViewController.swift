//
//  ParentProfileViewController.swift
//  NFTrack-Firebase4
//
//  Created by J C on 2021-06-09.
//

import UIKit

class ParentProfileViewController: UIViewController, UIScrollViewDelegate {
    var scrollView: UIScrollView!
    var profileImageButton = UIButton(type: .custom)
    var displayNameTextField = UITextField()
    var userInfo: UserInfo! {
        didSet {
            if let photoURL = userInfo.photoURL, photoURL != "NA" {
                configureCustomProfileImage(from: photoURL)
            } else {
                guard let image = UIImage(systemName: "person.crop.circle.fill") else {
                    self.dismiss(animated: true, completion: nil)
                    return
                }
                let configuration = UIImage.SymbolConfiguration(pointSize: 60, weight: .bold, scale: .large)
                let configuredImage = image.withTintColor(.orange, renderingMode: .alwaysOriginal).withConfiguration(configuration)
                
                profileImageButton.setImage(configuredImage, for: .normal)
            }
            
            displayNameTextField.text = userInfo.displayName
        }
    }
    var displayNameTitleLabel: UILabel!
    var alert: Alerts!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

extension ParentProfileViewController {
    @objc func configureUI() {
        alert = Alerts()
        view.backgroundColor = .white
        scrollView = UIScrollView()
//        scrollView.automaticallyAdjustsScrollIndicatorInsets = false
//        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: 1200)
        scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.fill()
        
        profileImageButton = UIButton(type: .custom)
        profileImageButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        profileImageButton.tag = 1
        profileImageButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(profileImageButton)
        
        displayNameTitleLabel = createTitleLabel(text: "Display Name")
        scrollView.addSubview(displayNameTitleLabel)
        
        displayNameTextField.setLeftPaddingPoints(10)
        displayNameTextField.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        displayNameTextField.delegate = self
        displayNameTextField.layer.cornerRadius = 10
        displayNameTextField.layer.borderColor = UIColor.lightGray.cgColor
        displayNameTextField.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(displayNameTextField)
        
        NSLayoutConstraint.activate([
            profileImageButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 80),
            profileImageButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            profileImageButton.heightAnchor.constraint(equalToConstant: 100),
            profileImageButton.widthAnchor.constraint(equalToConstant: 100),
            
            displayNameTitleLabel.topAnchor.constraint(equalTo: profileImageButton.bottomAnchor, constant: 50),
            displayNameTitleLabel.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor, constant: 20),
            displayNameTitleLabel.trailingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor, constant: -20),
            displayNameTitleLabel.heightAnchor.constraint(equalToConstant: 50),
            
            displayNameTextField.topAnchor.constraint(equalTo: displayNameTitleLabel.bottomAnchor, constant: 10),
            displayNameTextField.heightAnchor.constraint(equalToConstant: 50),
            displayNameTextField.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor, constant: 20),
            displayNameTextField.trailingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor, constant: -20),
        ])
    }

    @objc func configureCustomProfileImage(from url: String) {
        
    }
    
    @objc func buttonPressed(_ sender: UIButton!) {

    }
}

extension ParentProfileViewController: UITextFieldDelegate {
    func createProfileImageButton(_ button: UIButton, image: UIImage) -> UIButton {
        button.setImage(image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: button.bounds.width - button.bounds.height)
        button.imageView?.layer.cornerRadius = button.bounds.height/2.0
        button.imageView?.contentMode = .scaleToFill
        button.imageView?.layer.masksToBounds = true
        return button
    }
}
