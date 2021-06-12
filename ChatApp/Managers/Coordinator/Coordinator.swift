//
//  Coordinator.swift
//  ChatApp
//
//  Created by Salma Hassan on 11/06/2021.
//  Copyright © 2021 salma. All rights reserved.
//

import UIKit
import Firebase

class MainCoordinator: Coordinator {
	var childCoordinators = [Coordinator]()
	internal var navigationController: UINavigationController

	init(_ navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	func start() {
		Auth.auth().currentUser?.uid != nil ? home() : login()
	}
	
	func login() {
		let vc = LoginViewController(with: LoginViewModel())
		push(vc, isNavBarHidden: true)
	}
	
	func signup() {
		let vc = SignUpViewController()
		push(vc, isNavBarHidden: true)
	}
	
	func home() {
		let vc = HomeViewController(with: HomeViewModel())
		push(vc, isNavBarHidden: true)
	}
	
	func chatHistory() {
		let vc = ChatHistoryViewController(with: ChatHistoryViewModel())
		push(vc, isNavBarHidden: true)
	}
	
	func settings(_ userModel: UserModel) {
		let vc = SettingsViewController(with: SettingsViewModel(with: userModel))
		push(vc, isNavBarHidden: false)
	}
	
	func chatRoom(receiverModel model: UserModel) {
		let vc = ChatViewController(with: ChatViewModel(receiverModel: model))
		push(vc, isNavBarHidden: false)
	}
	
	func groupChat() {
	}
}

// MARK: - Helper Methods
extension MainCoordinator {
	fileprivate func push(_ vc: BaseViewController, isNavBarHidden: Bool) {
		vc.coordinator = self
		navigationController.navigationBar.isHidden = isNavBarHidden
		navigationController.pushViewController(vc, animated: true)
	}
	
	func showNavigationBar(_ isShown: Bool) {
		navigationController.navigationBar.isHidden = !isShown
	}
}
