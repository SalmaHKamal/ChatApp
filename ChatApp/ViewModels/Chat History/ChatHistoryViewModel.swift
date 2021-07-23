//
//  ChatHistoryViewModel.swift
//  ChatApp
//
//  Created by Salma Hassan on 2/13/21.
//  Copyright © 2021 salma. All rights reserved.
//

import Foundation

protocol ChatHistoryViewModelProtocol {
	func fetchData()
	var viewController: ChatHistoryViewControllerProtocol? { get set }
	var chatHistoryCellModels: [ChatHistoryViewModel.ChatHistoryCellModel]? { get }
	var viewControllerState: ChatHistoryViewModel.ChatHistoryViewControllerState? { get }
	var receivers: [UserModel] { get }
	func updateMessageIsReadState(at index: Int)
}

class ChatHistoryViewModel: ChatHistoryViewModelProtocol {
	
	// MARK: - Variabels
	weak var viewController: ChatHistoryViewControllerProtocol?
	var chatHistoryCellModels: [ChatHistoryViewModel.ChatHistoryCellModel]? = [ChatHistoryCellModel]()
	var viewControllerState: ChatHistoryViewModel.ChatHistoryViewControllerState? = .loading {
		didSet {
			viewController?.reloadTableView()
		}
	}
	var receivers: [UserModel] = []
	
	struct ChatHistoryCellModel {
		var receiverUid: String
		var receiverPhotoUrl: URL?
		var receiverDisplayName: String
		var lastMessage: MessageModel
	}
	
	enum ChatHistoryViewControllerState {
		case loading
		case finished
	}
	
	
	func fetchData() {
		ChatManager().loadChatHistory { [weak self] (result) in
			self?.createCellModel(result)
		}
	}
	
//	private func createCellModel(_ result: [(receivers: [String], lastMessage: MessageModel?)]) {
//
//		result.forEach { (dic) in
//			guard let id = dic.receivers.first,
//				let message: MessageModel = dic.lastMessage else {
//					return
//			}
//
//			let name: String = "receiver.displayName"
//
////			receivers.append(receiver)
//			let model = ChatHistoryCellModel(receiverUid: id,
//											 receiverPhotoUrl: nil,
//											 receiverDisplayName: name,
//											 lastMessage: message)
//
//			chatHistoryCellModels?.append(model)
//		}
//
//		viewControllerState = .finished
//	}
	
	private func createCellModel(_ result: [String : (receiver: UserModel, messages: [MessageModel])]) {

		result.forEach { (dic) in
			let receiver = dic.value.receiver
			let messages = dic.value.messages

			guard let id = receiver.uid,
				let photoUrl: URL = receiver.photoUrl,
				let name: String = receiver.displayName,
				let message: MessageModel = messages.last else {
					return
			}

			receivers.append(receiver)
			let model = ChatHistoryCellModel(receiverUid: id,
											 receiverPhotoUrl: photoUrl,
											 receiverDisplayName: name,
											 lastMessage: message)

			chatHistoryCellModels?.append(model)
		}

		viewControllerState = .finished
	}
	
	func updateMessageIsReadState(at index: Int) {
		chatHistoryCellModels?[index].lastMessage.isRead = true
	}
}
