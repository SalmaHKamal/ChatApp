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
		var receiverUid: String?
		var receiverPhotoUrl: String?
		var receiverDisplayName: String?
		var lastMessage: String?
	}
	
	enum ChatHistoryViewControllerState {
		case loading
		case finished
	}
	
	func fetchData() {
		ChatManager().loadChatHistory { [weak self] result in
			self?.chatHistoryCellModels?.removeAll()
			self?.createCellModel(with: result)
		}
	}
	
	private func createCellModel(with result: [ChatHistoryModel]) {
		result.forEach { (model) in
			let cellModel = ChatHistoryCellModel(receiverUid: model.senderID,
												 receiverPhotoUrl: model.senderAvatar,
												 receiverDisplayName: model.senderName,
												 lastMessage: model.lastMessage)
			chatHistoryCellModels?.append(cellModel)
		}
		viewControllerState = .finished
	}
	
	func updateMessageIsReadState(at index: Int) {
//		chatHistoryCellModels?[index].lastMessage.isRead = true
	}
}
