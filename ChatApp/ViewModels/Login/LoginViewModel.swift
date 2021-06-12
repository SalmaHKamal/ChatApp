//
//  LoginViewModel.swift
//  ChatApp
//
//  Created by Salma Hassan on 5/16/21.
//  Copyright © 2021 salma. All rights reserved.
//

import Foundation

protocol LoginViewModelProtocol: AnyObject {
	func saveInUserDefaults(model: UserModel?)
}

class LoginViewModel: LoginViewModelProtocol {
	func saveInUserDefaults(model: UserModel?) {
		guard let model = model else { return }
		UserDefaultsManager().set(currentUser: model)
	}
}
