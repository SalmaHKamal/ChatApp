//
//  ChatViewModel.swift
//  ChatApp
//
//  Created by Salma Hassan on 2/13/21.
//  Copyright © 2021 salma. All rights reserved.
//

import Foundation
import Firebase

protocol ChatViewModelProtocol {
	var viewController: ChatViewControllerProtocol? { get set }
	var receiverModel: UserModel? { get }
	var messages: [MessageModel]? { get }
	
	func loadChat()
	func saveMessage(content: String)
}

class ChatViewModel: ChatViewModelProtocol {
	weak var viewController: ChatViewControllerProtocol?
	var receiverModel: UserModel?
	var messages: [MessageModel]? {
		didSet {
			viewController?.reloadTableView()
		}
	}
	var docRef: DocumentReference?
	let chatManager: ChatManager = ChatManager()
	
	init(receiverModel: UserModel) {
		self.receiverModel = receiverModel
	}
	
	func loadChat() {
		guard let model: UserModel = receiverModel else {
			return
		}
		chatManager.loadChat(with: model) { [weak self] messages, docRef in
			self?.messages = messages
			self?.docRef = docRef
		}
	}
	
	func saveMessage(content: String) {
		
		createMessage(with: content) { [weak self] (message) in
			guard let message: MessageModel = message else {
				return
			}
			self?.chatManager.save(message: message, docRef: self?.docRef)
		}
	}
	
	private func createMessage(with content: String, completion: @escaping (_ messageModel: MessageModel?) -> Void) {
		guard let receiverModel = receiverModel else {
			completion(nil)
			return
		}
		
		chatManager.getSenderInfo(receiverModel: receiverModel) { (result) in
			var model: MessageModel = MessageModel()
			model.id = "0"
			model.content = content
			model.created = "Today"
			model.senderName = result?.0
			model.senderID = result?.1
			
			completion(model)
		}
	}
}
