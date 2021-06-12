//
//  SettingsViewModel.swift
//  ChatApp
//
//  Created by Salma Hassan on 5/16/21.
//  Copyright © 2021 salma. All rights reserved.
//

import Foundation
import Firebase

protocol SettingsViewModelProtocol: AnyObject {
	init(with userModel: UserModel)
	var imageUrl: URL? { get }
	func logout()
	var viewController: SettingsViewController? { get set }
}

class SettingsViewModel: SettingsViewModelProtocol {
	
	// MARK: - Variables
	private(set) var userModel: UserModel?
	private let firebaseManager = FirebaseManager()
	var imageUrl: URL? {
		return userModel?.photoUrl
	}
	weak var viewController: SettingsViewController?
	
	// MARK: - Inits
	required init(with userModel: UserModel) {
		self.userModel = userModel
	}
	
	func logout() {
		firebaseManager.logout()
		showLoginVC()
	}
	
	private func showLoginVC() {
		viewController?.coordinator?.login()
	}
}
