//
//  HomeViewModel.swift
//  ChatApp
//
//  Created by Salma Hassan on 2/13/21.
//  Copyright © 2021 salma. All rights reserved.
//

import Foundation

protocol HomeViewModelProtocol: AnyObject {
	func fetchData()
	var profileImageUrl: String? { get }
	var viewController: HomeViewControllerProtocol? { get set }
}

class HomeViewModel: HomeViewModelProtocol {
	
	var profileImageUrl: String? {
		didSet {
			viewController?.updateUserProfileImage()
		}
	}
	weak var viewController: HomeViewControllerProtocol?
	
	func fetchData() {
		FirebaseManager().getCurrentUserProfileImage(completion: { [weak self] (imageUrl) in
			self?.profileImageUrl = imageUrl
		})
	}
}
