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
	var receiverModel: ChatRecieverData? { get }
	var messages: [MessageModel]? { get }
	var chatMessageCellModels: [ChatMessageCellModel] { get }
	
	func loadChat()
	func saveMessage(content: String)
	func createCellModels(from messages: [MessageModel])
	
}

struct ChatMessageCellModel {
	var profileImageUrl: URL?
	var messageContent: String?
}

class ChatViewModel: ChatViewModelProtocol {
	weak var viewController: ChatViewControllerProtocol?
	var receiverModel: ChatRecieverData?
	var messages: [MessageModel]? {
		didSet {
			guard let messages = messages else {
				return
			}
			createCellModels(from: messages)
		}
	}
	var docRef: DocumentReference?
	let chatManager: ChatManager = ChatManager()
	var chatMessageCellModels: [ChatMessageCellModel] = [] {
		didSet {
			viewController?.reloadTableView()
		}
	}
	
	init(receiverModel: ChatRecieverData) {
		self.receiverModel = receiverModel
	}
	
	func loadChat() {
		guard let model: ChatRecieverData = receiverModel else {
			return
		}
		chatManager.loadChat(with: model.id) { [weak self] messages, docRef in
			self?.messages = messages
			self?.docRef = docRef
		}
	}
	
	func createCellModels(from messages: [MessageModel]) {
		var cellModels = [ChatMessageCellModel]()
		messages.forEach { (message) in
			let cellModel = ChatMessageCellModel(profileImageUrl: nil,
												 messageContent: message.content)
			cellModels.append(cellModel)
		}
		
		chatMessageCellModels = cellModels
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
//		guard let receiverModel = receiverModel else {
//			completion(nil)
//			return
//		}
//
//		chatManager.getSenderInfo(receiverModel: receiverModel) { (result) in
//			var model: MessageModel = MessageModel()
//			model.id = "0"
//			model.content = content
//			model.created = TimeInterval()
//			model.senderName = result?.0
//			model.senderID = result?.1
//
//			completion(model)
//		}
	}
}
