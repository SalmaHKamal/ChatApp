//
//  ChatHistoryViewModel.swift
//  ChatApp
//
//  Created by Salma Hassan on 2/13/21.
//  Copyright © 2021 salma. All rights reserved.
//

import Foundation

protocol ChatHistoryViewModelProtocol {
	var viewController: ChatHistoryViewControllerProtocol? { get set }
	var chatHistoryCellModels: [ChatHistoryViewModel.ChatHistoryCellModel]? { get }
	var filteredChatHistoryCellModels: [ChatHistoryViewModel.ChatHistoryCellModel]? { get }
	var viewControllerState: ChatHistoryViewModel.ChatHistoryViewControllerState? { get }
	var receivers: [UserModel] { get }
	var cellModels: [ChatHistoryViewModel.ChatHistoryCellModel]? { get }
	
	func fetchData()
	func updateMessageIsReadState(at index: Int)
	func deleteChatHistory(at indexPath: IndexPath)
}

class ChatHistoryViewModel: ChatHistoryViewModelProtocol {
	
	// MARK: - Variabels
	weak var viewController: ChatHistoryViewControllerProtocol?
	var chatHistoryCellModels: [ChatHistoryViewModel.ChatHistoryCellModel]? = [ChatHistoryCellModel]()
	var filteredChatHistoryCellModels: [ChatHistoryViewModel.ChatHistoryCellModel]? = [ChatHistoryCellModel]()
	var viewControllerState: ChatHistoryViewModel.ChatHistoryViewControllerState? = .loading {
		didSet {
			viewController?.reloadTableView()
		}
	}
	var receivers: [UserModel] = []
	let chatManager = ChatManager()
	let firebaseManager = FirebaseManager()
	var isSearching: Bool = false
	var cellModels: [ChatHistoryCellModel]? {
		if isSearching && filteredChatHistoryCellModels?.count ?? 0 > 0 {
			return filteredChatHistoryCellModels
		} else {
			return chatHistoryCellModels
		}
	}
	
	struct ChatHistoryCellModel {
		var receiverUid: String?
		var receiverPhotoUrl: String?
		var receiverDisplayName: String?
		var lastMessage: String?
		var unSeenMessageCount: Int = 0
		var messageTime: Date?
		var chatHistoryId: String?
	}
	
	enum ChatHistoryViewControllerState {
		case loading
		case finished
	}
	
	// MARK: - Methods
	func fetchData() {
		chatManager.loadChatHistory { [weak self] result in
			self?.chatHistoryCellModels?.removeAll()
			self?.createCellModel(with: result)
		}
	}
	
	private func createCellModel(with result: [ChatHistoryModel]) {
		result.forEach { (model) in
			let cellModel = ChatHistoryCellModel(receiverUid: model.senderID,
												 receiverPhotoUrl: model.senderAvatar,
												 receiverDisplayName: model.senderName,
												 lastMessage: model.lastMessage,
												 unSeenMessageCount: model.unSeenMessageCount,
												 messageTime: model.date,
												 chatHistoryId: model.chatHistoryId)
			chatHistoryCellModels?.append(cellModel)
		}
		viewControllerState = .finished
	}
	
	func updateMessageIsReadState(at index: Int) {
		chatHistoryCellModels?[index].unSeenMessageCount = 0
	}
	
	func deleteChatHistory(at indexPath: IndexPath) {
		guard let selectedModel = chatHistoryCellModels?[indexPath.row],
			  let chatHistoryId = selectedModel.chatHistoryId else {
			return
		}
		
		firebaseManager.deleteChatHistory(with: chatHistoryId)
	}
}

extension ChatHistoryViewModel: SearchableDelegate {
	func didChangeSearchText(with text: String) {
		if text.isEmpty {
			filteredChatHistoryCellModels = chatHistoryCellModels
			
		} else {
			filteredChatHistoryCellModels = chatHistoryCellModels?.filter({ (model) -> Bool in
				guard let name = model.receiverDisplayName else {
					return false
				}
				return name.contains(text)
			})
		}

		viewController?.reloadTableView()
	}
	
	func didBeginSearching() {
		isSearching = true
		viewController?.reloadTableView()
	}
	
	func didCancelSearching() {
		isSearching = false
		filteredChatHistoryCellModels?.removeAll()
		viewController?.reloadTableView()
	}
}
