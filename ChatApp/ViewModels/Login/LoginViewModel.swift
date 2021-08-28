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
	let firebaseManager = FirebaseManager()
	
	func saveInUserDefaults(model: UserModel?) {
		guard let model = model,
			  let modelID = model.uid else { return }
		getRestOfUserData(with: modelID) { (userModel) in
			model.displayName = userModel?.displayName
			UserDefaultsManager().set(currentUser: model)
		}
	}
	
	private func getRestOfUserData(with userID: String, completion: @escaping (UserModel?) -> Void) {
		firebaseManager.getUserInfo(for: userID) { (model) in
			completion(model)
		}
	}
}
