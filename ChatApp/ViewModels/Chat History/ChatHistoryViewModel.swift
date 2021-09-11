//
//  ChatHistoryViewModel.swift
//  ChatApp
//
//  Created by Salma Hassan on 2/13/21.
//  Copyright © 2021 salma. All rights reserved.
//

import UIKit

protocol ChatHistoryViewModelProtocol {
	var viewController: ChatHistoryViewControllerProtocol? { get set }
	var viewControllerState: ChatHistoryViewModel.ChatHistoryViewControllerState? { get }
	var cellModels: [ChatHistoryViewModel.ChatHistoryCellModel]? { get }
	var viewControllerParentVC: BaseViewController? { get set }
	
	func fetchData()
	func updateMessageIsReadState(at index: Int)
	func deleteChatHistory(at indexPath: IndexPath)
	func getReceiverData(at indexPath: IndexPath) -> ChatRecieverData?
}

class ChatHistoryViewModel: ChatHistoryViewModelProtocol {
	
	// MARK: - Variabels
	weak var viewController: ChatHistoryViewControllerProtocol?
	private var chatHistoryCellModels: [ChatHistoryViewModel.ChatHistoryCellModel]? = [ChatHistoryCellModel]()
	private var filteredChatHistoryCellModels: [ChatHistoryViewModel.ChatHistoryCellModel]? = [ChatHistoryCellModel]()
	var viewControllerState: ChatHistoryViewModel.ChatHistoryViewControllerState? = .loading {
		didSet {
			viewController?.reloadTableView()
		}
	}
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
	var viewControllerParentVC: BaseViewController?
	
	struct ChatHistoryCellModel {
		var receiverUid: String?
		var receiverPhotoUrl: String?
		var receiverDisplayName: String?
		var lastMessage: String?
		var unSeenMessageCount: Int = 0
		var messageTime: Date?
		var chatHistoryId: String?
		var cellDisplayName: String?
	}
	
	enum ChatHistoryViewControllerState {
		case loading
		case finished
	}
	
	// MARK: - Methods
	func fetchData() {
		showLoadingIndicator()
		chatManager.loadChatHistory { [weak self] result in
			self?.hideLoadingIndicator()
			self?.chatHistoryCellModels?.removeAll()
			self?.createCellModel(with: result)
		}
	}
	
	private func createCellModel(with result: [ChatHistoryModel]) {
		result.forEach { (model) in
			let nameToDisplay = getNameToDisplay(from: model)
			let cellModel = ChatHistoryCellModel(receiverUid: model.senderID,
												 receiverPhotoUrl: model.senderAvatar,
												 receiverDisplayName: model.senderName,
												 lastMessage: model.lastMessage,
												 unSeenMessageCount: model.unSeenMessageCount,
												 messageTime: model.date,
												 chatHistoryId: model.chatHistoryId,
												 cellDisplayName: nameToDisplay)
			chatHistoryCellModels?.append(cellModel)
		}
		viewControllerState = .finished
	}
	
	private func getNameToDisplay(from model: ChatHistoryModel) -> String? {
		guard let userId = firebaseManager.getCurrentUserID() else {
			return nil
		}
		guard let name = model.membersNames?.filter({ !$0.contains(userId) }).first?.split(separator: "_").last else {
			return nil
		}
		return String(name)
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
	
	func getReceiverData(at indexPath: IndexPath) -> ChatRecieverData? {
		guard let model = cellModels?[indexPath.row] else {
			return nil
		}
		
		guard let receiverId = model.receiverUid,
			  let receiverName = model.cellDisplayName else {
			return nil
		}
		let receiverData: ChatRecieverData = (id: receiverId,
											  name: receiverName,
											  imageUrl: model.receiverPhotoUrl ?? "")
		
		return receiverData
	}
}

// MARK: - Helper Methods
extension ChatHistoryViewModel {
	private func showLoadingIndicator() {
		viewControllerParentVC?.showLoadingIndicator()
	}
	
	private func hideLoadingIndicator() {
		viewControllerParentVC?.hideLoadingIndicator()
	}
}
