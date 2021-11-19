//
//  ContactsViewModel.swift
//  ChatApp
//
//  Created by Salma Hassan on 2/12/21.
//  Copyright © 2021 salma. All rights reserved.
//

import UIKit

protocol ContactsViewModelProtocol: AnyObject {
	var contactsInfo: [UserModel]? { get }
	var viewController: ContactsViewControllerProtocol? { get set }
	func fetchData()
	func presentChatViewController(for indexPath: IndexPath)
}

class ContactsViewModel: ContactsViewModelProtocol {
	
	// MARK: - Variables
	var contactsInfo: [UserModel]? {
		didSet {
			viewController?.reloadCollectionView()
		}
	}
	weak var viewController: ContactsViewControllerProtocol?
	var isSearching: Bool = false
	
	// MARK: - Methods
	func fetchData() {
		FirebaseManager().getContacts(completion: { [weak self] (contacts) in
			self?.contactsInfo = contacts
		})
	}
	
	func presentChatViewController(for indexPath: IndexPath) {
		guard let model = contactsInfo?[indexPath.row] else {
			return
		}
		(viewController as? BaseViewController)?.coordinator?.chatRoom(receiverModel: model)
	}
	
}

extension ContactsViewModel: SearchableDelegate {
	func didChangeSearchText(with text: String) {
		
	}
}
