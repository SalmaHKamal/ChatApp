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
	func playSound()
	func presentActionSheet()
	
}

struct ChatMessageCellModel {
	var senderName: String?
	var senderID: String?
	var profileImageUrl: URL?
	var messageContent: String?
	var isFromRightToLeft: Bool = false
}

class ChatViewModel: ChatViewModelProtocol {
	
	// MARK: - Variables
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
	var currentUser: UserModel? {
		return UserDefaultsManager().get(with: .currentUser) as? UserModel
	}
	private let soundPlayer = SoundPlayer()
	private let actionSheet = ActionSheet()
	
	// MARK: - Inits
	init(receiverModel: ChatRecieverData) {
		self.receiverModel = receiverModel
	}
	
	// MARK: - Methods
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
			let cellModel = ChatMessageCellModel(senderName: message.senderName,
												 senderID: message.senderID,
												 profileImageUrl: nil,
												 messageContent: message.content,
												 isFromRightToLeft: message.senderID == currentUser?.uid)
			cellModels.append(cellModel)
		}
		
		chatMessageCellModels = cellModels
	}
	
	func saveMessage(content: String) {
		
		guard let currentUser = currentUser else {
			return
		}
		
		var model = MessageModel()
		model.id = UUID().uuidString
		model.content = content
		model.created = Date()
		model.senderName = currentUser.displayName
		model.senderID = currentUser.uid
		model.isRead = true
		
		chatManager.save(message: model,
						 docRef: docRef)
	}
	
	func playSound() {
		soundPlayer.play(sound: .sendMessage)
	}
	
	func presentActionSheet() {
		let actionModel = ActionSheetModel(actions: [.uploadPhoto,
													 .uploadDocument],
										   hasCloseAction: true)
		actionSheet.present(with: actionModel,
							in: viewController as! UIViewController)
	}
}
