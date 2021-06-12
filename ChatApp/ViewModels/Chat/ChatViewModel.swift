//
//  ChatViewModel.swift
//  ChatApp
//
//  Created by Salma Hassan on 2/13/21.
//  Copyright © 2021 salma. All rights reserved.
//

import Foundation
import Firebase

enum ChatContentDirection {
	case left, right
}

protocol ChatViewModelProtocol {
	var viewController: ChatViewControllerProtocol? { get set }
	var receiverModel: UserModel? { get }
	var messages: [MessageModel]? { get }
	var chatMessageCellModels: [ChatMessageCellModel] { get }
	
	func loadChat()
	func saveMessage(content: String)
	func createCellModels(from messages: [MessageModel])
	
}

struct ChatMessageCellModel {
	var user: UserModel?
	var messageContent: String?
	var contentDirection: ChatContentDirection = .left
}

class ChatViewModel: ChatViewModelProtocol {
	weak var viewController: ChatViewControllerProtocol?
	var receiverModel: UserModel?
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
	var chatMessageCellModels: [ChatMessageCellModel] = []
	let userdafaultsManager = UserDefaultsManager()
	
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
	
	func createCellModels(from messages: [MessageModel]) {
		messages.forEach { (message) in
			guard let senderID: String = message.senderID else {
				return
			}
			chatManager.getUserInfo(uid: senderID, completion: { [weak self] user in
				guard let user = user,
					  let self = self else { return }
				self.chatMessageCellModels.append(ChatMessageCellModel(user: user,
																  messageContent: message.content,
																  contentDirection: self.getContentDirection(with: message.senderID ?? "")))
				self.viewController?.reloadTableView()
			})
		}
	}
	
	private func getContentDirection(with userId: String) -> ChatContentDirection {
		return (userdafaultsManager.get(with: .currentUser) as? UserModel)?.uid == userId ? .right : .left
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
			model.created = TimeInterval()
			model.senderName = result?.0
			model.senderID = result?.1
			
			completion(model)
		}
	}
}
