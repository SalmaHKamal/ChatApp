//
//  LoginViewController.swift
//  ChatApp
//
//  Created by Salma Hassan on 1/1/21.
//  Copyright © 2021 salma. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
	
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

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
