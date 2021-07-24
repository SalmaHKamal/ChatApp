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
	
	
	// MARK: - Methods
	func fetchData() {
		FirebaseManager().getContacts(completion: { [weak self] (contacts) in
			self?.contactsInfo = contacts
		})
	}
	
	func presentChatViewController(for indexPath: IndexPath) {
		let dict = ["chatRoomID": "salma",
					"date": DateFormatter().string(from: Date()),
					"senderAvatar": nil,
					"senderName": "Salma",
					"lastMessage": "Hello Kimoo",
					"messagesCount": 1,
					"type": "private",
					"senderID": contactsInfo?[indexPath.row].uid] as [String : Any?]
		guard let model = ChatHistoryModel(dictionary: dict) else {
			return
		}
		FirebaseManager().saveChatHistory(model: model)
//		guard let receiverModel: UserModel = contactsInfo?[indexPath.row] else {
//			return
//		}
//		(viewController as? BaseViewController)?.coordinator?.chatRoom(receiverModel: receiverModel)
	}
	
}
