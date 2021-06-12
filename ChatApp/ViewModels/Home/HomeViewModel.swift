//
//  HomeViewModel.swift
//  ChatApp
//
//  Created by Salma Hassan on 2/13/21.
//  Copyright © 2021 salma. All rights reserved.
//

import UIKit

protocol HomeViewModelProtocol: AnyObject {
	func fetchData()
	var profileImageUrl: String? { get }
	var viewController: HomeViewControllerProtocol? { get set }
	func showSettingsViewController()
}

class HomeViewModel: HomeViewModelProtocol {
	
	var profileImageUrl: String? {
		didSet {
			viewController?.updateUserProfileImage()
		}
	}
	weak var viewController: HomeViewControllerProtocol?
	let userdefaultsManager = UserDefaultsManager()
	private var userModel: UserModel? {
		return userdefaultsManager.get(with: .currentUser) as? UserModel
	}
	
	func fetchData() {
		if let profileUrl = userModel?.photoUrl {
			self.profileImageUrl = profileUrl.absoluteString
		} else {
			FirebaseManager().getCurrentUserProfileImage(completion: { [weak self] (imageUrl) in
				self?.profileImageUrl = imageUrl
				self?.userdefaultsManager.set(profileUrl: imageUrl ?? "")
			})
		}
	}
	
	func showSettingsViewController() {
		guard let userModel = userModel else { return }
		(viewController as? BaseViewController)?.coordinator?.settings(userModel)
	}
	
	
}
