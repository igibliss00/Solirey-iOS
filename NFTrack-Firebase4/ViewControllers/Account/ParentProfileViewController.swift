//
//  ParentProfileViewController.swift
//  NFTrack-Firebase4
//
//  Created by J C on 2021-06-09.
//

import UIKit

class ParentProfileViewController: UIViewController {
    var profileImageButton: UIButton!
    var userInfo: UserInfo!
    var displayNameTitleLabel: UILabel!
    var displayNameTextField: UITextField!
    
    let alert = Alerts()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
}

extension ParentProfileViewController {
    @objc func configureUI() {
        profileImageButton = UIButton(type: .custom)
        if let url = userInfo.photoURL {
            configureCustomProfileImage(from: url)
        } else {
            guard let image = UIImage(systemName: "person.crop.circle.fill") else {
                self.dismiss(animated: true, completion: nil)
                return
            }
            let configuration = UIImage.SymbolConfiguration(pointSize: 60, weight: .bold, scale: .large)
            let configuredImage = image.withTintColor(.orange, renderingMode: .alwaysOriginal).withConfiguration(configuration)
            profileImageButton.setImage(configuredImage, for: .normal)
        }
        
        profileImageButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        profileImageButton.tag = 1
        profileImageButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImageButton)
        
        displayNameTitleLabel = createTitleLabel(text: "Display Name")
        view.addSubview(displayNameTitleLabel)
        
        displayNameTextField = createTextField(content: userInfo.displayName, delegate: self)
        view.addSubview(displayNameTextField)
    }
    
    @objc func setConstraints() {
        NSLayoutConstraint.activate([
            profileImageButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            profileImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageButton.heightAnchor.constraint(equalToConstant: 100),
            profileImageButton.widthAnchor.constraint(equalToConstant: 100),
            
            displayNameTitleLabel.topAnchor.constraint(equalTo: profileImageButton.bottomAnchor, constant: 50),
            displayNameTitleLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 20),
            displayNameTitleLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -20),
            
            displayNameTextField.topAnchor.constraint(equalTo: displayNameTitleLabel.bottomAnchor, constant: 10),
            displayNameTextField.heightAnchor.constraint(equalToConstant: 50),
            displayNameTextField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 20),
            displayNameTextField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -20),
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
        return button
    }
}
