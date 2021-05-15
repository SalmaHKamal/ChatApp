//
//  LoginViewController.swift
//  ChatApp
//
//  Created by Salma Hassan on 1/1/21.
//  Copyright © 2021 salma. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController, RegisterationProtocol {
	// MARK: - Outlets
	@IBOutlet weak var usernameTextFieldView: UIView! {
		didSet {
			guard let view = CustomTextFieldView.create() else {
				return
			}
			view.setupView(imageName: "username", placeholderText: "Username")
			usernameTextFieldView.addSubview(view)
			view.frame = usernameTextFieldView.bounds
		}
	}
	
	@IBOutlet weak var passwordTextFieldView: UIView! {
		didSet {
			guard let view = CustomTextFieldView.create() else {
				return
			}
			view.setupView(imageName: "password", placeholderText: "Password")
			passwordTextFieldView.addSubview(view)
			view.frame = passwordTextFieldView.bounds
		}
	}
	
	@IBOutlet weak var wholeScrollView: UIScrollView!
	
	// MARK: - Variables
	var scrollView: UIScrollView!

	// MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

		scrollView = wholeScrollView
		addNotificationObservers(self)
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		removeNotificationObservers(for: self)
	}
	
	// MARK: - Actions
	@IBAction func loginBtnPressed(_ sender: Any) {
		guard let password = (passwordTextFieldView.subviews.first as? CustomTextFieldView)?.textField.text, !password.isEmpty else { return }
		guard let username = (usernameTextFieldView.subviews.first as? CustomTextFieldView)?.textField.text, !username.isEmpty  else { return }
		
		self.showLoadingIndicator(with: "Please Wait")
		FirebaseManager().login(with: username, and: password, completion: { [weak self] authResult in
			if let error = authResult.error {
				self?.showLoadingIndicator(with: error, hideAfter: 3.0)
			} else {
				self?.hideLoadingIndicator()
				self?.pushToHomeViewController()
				self?.persistInUserDefaults(model: authResult.user)
			}
		})
	}
	
	@IBAction func registerBtnPressed(_ sender: Any) {
		let vc = SignUpViewController()
		self.navigationController?.pushViewController(vc, animated: true)
	}
	
	@IBAction func forgetPasswordPressed(_ sender: Any) {
		
	}
	
	@IBAction func loginFBPressed(_ sender: Any) {
	}
	
	@IBAction func loginGooglePressed(_ sender: Any) {
	}
	
	@IBAction func loginTwitterPressed(_ sender: Any) {
	}
	
	// MARK: - Helper Methods
	private func pushToHomeViewController() {
		let vc = HomeViewController()
		self.navigationController?.pushViewController(vc, animated: true)
	}
	
	private func persistInUserDefaults(model: UserModel?) {
		guard let model = model else { return }
		do {
			try UserDefaultsManager().set(currentUser: model)
		} catch {
			print("couldn't save user model into userDefaults")
		}
	}
}
