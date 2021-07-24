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
		let dict = ["chatRoomId": "nadra",
					"date": Date().timestamp,
					"senderAvatar": nil,
					"senderName": "Nadra",
					"lastMessage": "Ezayek ya Soso !",
					"unSeenMessageCount": 1,
					"type": "private",
					"senderID": contactsInfo?[indexPath.row].uid] as [String : Any?]
//		guard let model = ChatHistoryModel(dictionary: dict) else {
//			return
//		}
		FirebaseManager().saveChatHistory(dictionary: dict)
//		guard let receiverModel: UserModel = contactsInfo?[indexPath.row] else {
//			return
//		}
//		(viewController as? BaseViewController)?.coordinator?.chatRoom(receiverModel: receiverModel)
	}
	
}
