//
//  LoginViewController.swift
//  ChatApp
//
//  Created by Salma Hassan on 1/1/21.
//  Copyright © 2021 salma. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
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
//	var scrollView: UIScrollView!
	private var viewModel: LoginViewModelProtocol?
	
	// MARK: - Inits
	convenience init(with viewModel: LoginViewModelProtocol) {
		self.init(nibName: nil, bundle: nil)
		self.viewModel = viewModel
	}

	// MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

		scrollView = wholeScrollView
		addNotificationObservers()
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		removeNotificationObservers()
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
				self?.coordinator?.home()
				self?.viewModel?.saveInUserDefaults(model: authResult.user)
			}
		})
	}
	
	@IBAction func registerBtnPressed(_ sender: Any) {
		coordinator?.signup()
	}
	
	@IBAction func forgetPasswordPressed(_ sender: Any) {
		
	}
	
	@IBAction func loginFBPressed(_ sender: Any) {
	}
	
	@IBAction func loginGooglePressed(_ sender: Any) {
	}
	
	@IBAction func loginTwitterPressed(_ sender: Any) {
	}
}
