//
//  SignUpViewController.swift
//  ChatApp
//
//  Created by Salma Hassan on 1/22/21.
//  Copyright © 2021 salma. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class SignUpViewController: BaseViewController, RegisterationProtocol {

	// MARK: - Outlets
	@IBOutlet weak var username: UIView! {
		didSet {
			guard let view = CustomTextFieldView.create() else {
				return
			}
			view.setupView(imageName: "username", placeholderText: "Username")
			username.addSubview(view)
			view.frame = username.bounds
		}
	}
	@IBOutlet weak var email: UIView! {
		didSet {
			guard let view = CustomTextFieldView.create() else {
				return
			}
			view.setupView(imageName: "email", placeholderText: "Email")
			email.addSubview(view)
			view.frame = email.bounds
		}
	}
	@IBOutlet weak var password: UIView! {
		didSet {
			guard let view = CustomTextFieldView.create() else {
				return
			}
			view.setupView(imageName: "password", placeholderText: "Password")
			password.addSubview(view)
			view.frame = password.bounds
		}
	}
	@IBOutlet weak var confirmPassword: UIView! {
		didSet {
			guard let view = CustomTextFieldView.create() else {
				return
			}
			view.setupView(imageName: "password", placeholderText: "Confirm Password")
			confirmPassword.addSubview(view)
			view.frame = confirmPassword.bounds
		}
	}
	
	@IBOutlet weak var userImageView: LiveImageView!
	@IBOutlet weak var wholeScrollView: UIScrollView! 
	
	// MARK: - Variables
	var imagePicker: ImagePicker!
	var scrollView: UIScrollView!
	
	// MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker = ImagePicker(presentationController: self, delegate: self)
		scrollView = wholeScrollView
		addNotificationObservers(self)
		// setup keyboard event
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		removeNotificationObservers(for: self)
	}
	
	// MARK: - Actions
	@IBAction func loginButtonPressed(_ sender: UIButton) {
		coordinator?.login()
//		let vc = LoginViewController(with: LoginViewModel())
//		self.navigationController?.pushViewController(vc, animated: true)
	}
	@IBAction func selectImageBtnPressed(_ sender: UIButton) {
		imagePicker.present(from: sender)
	}
	
	@IBAction func registerButtonPressed(_ sender: Any) {
		
		guard let email = (email.subviews.first as? CustomTextFieldView)?.textField.text , !email.isEmpty else { return }
		guard let password = (password.subviews.first as? CustomTextFieldView)?.textField.text, !password.isEmpty else { return }
		guard let username = (username.subviews.first as? CustomTextFieldView)?.textField.text, !username.isEmpty  else { return }
		
		self.showLoadingIndicator(with: "Registering")
		FirebaseManager().register(with: email, and: password, and: username, and: userImageView.image) { [weak self] (registerResult) in
			if let error = registerResult.error {
				self?.showLoadingIndicator(with: error, hideAfter: 3.0)
			} else {
				self?.hideLoadingIndicator()
				self?.coordinator?.login()
			}
		}
	}
	
//	// MARK: - Helper Methods
//	private func pushLoginViewController() {
//		let vc = LoginViewController(with: LoginViewModel())
//		self.navigationController?.pushViewController(vc, animated: true)
//	}
}

extension SignUpViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        userImageView.image = image
    }
}
