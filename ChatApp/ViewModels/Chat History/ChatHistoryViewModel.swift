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
}

class ChatHistoryViewModel: ChatHistoryViewModelProtocol {
	
	// MARK: - Variabels
	weak var viewController: ChatHistoryViewControllerProtocol?
	var chatHistoryCellModels: [ChatHistoryCellModel]?
	var viewControllerState: ChatHistoryViewModel.ChatHistoryViewControllerState? = .loading {
		didSet {
			viewController?.reloadTableView()
		}
	}
	struct ChatHistoryCellModel {
		var receiverUid: String
		var receiverPhotoUrl: URL
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
			
			let model = ChatHistoryCellModel(receiverUid: id,
											 receiverPhotoUrl: photoUrl,
											 receiverDisplayName: name,
											 lastMessage: message)
			
			chatHistoryCellModels?.append(model)
		}
		
		viewControllerState = .finished
	}
}
