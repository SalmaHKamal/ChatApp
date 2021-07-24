//
//  ChatHistoryVC+TableView.swift
//  ChatApp
//
//  Created by Salma Hassan on 24/07/2021.
//  Copyright © 2021 salma. All rights reserved.
//

import UIKit

extension ChatHistoryViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		updateTableViewCellReadState(at: indexPath)
		navigateToChatVC(selectedIndex: indexPath)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 100
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let muteAction = UIContextualAction(style: .normal, title: "Mute") { (action, view, bool) in
			// TODO: - implement mute functionality later
		}
		let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { [weak self] _,_,_  in
			self?.viewModel?.deleteChatHistory(at: indexPath)
		})
		return UISwipeActionsConfiguration(actions: [muteAction, deleteAction])
	}
}


extension ChatHistoryViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch viewModel?.viewControllerState {
		case .loading:
			return 0
		case .finished:
			return viewModel?.chatHistoryCellModels?.count ?? 0
		default:
			return 0
		}
		
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatHistoryTableViewCell.nibName, for: indexPath) as? ChatHistoryTableViewCell else {
			
			return UITableViewCell()
		}
		cell.model = viewModel?.chatHistoryCellModels?[indexPath.row]
		return cell
	}
}

// MARK: - Helper Methods
extension ChatHistoryViewController {
	private func updateTableViewCellReadState(at indexPath: IndexPath) {
		viewModel?.updateMessageIsReadState(at: indexPath.row)
		guard let selectedCell = tableView.cellForRow(at: indexPath) as? ChatHistoryTableViewCell else {
			return
		}
		selectedCell.model = viewModel?.chatHistoryCellModels?[indexPath.row]
	}
	
	private func navigateToChatVC(selectedIndex indexPath: IndexPath) {
		guard let receiver = viewModel?.receivers[indexPath.row] else {
			return
		}
		coordinator?.chatRoom(receiverModel: receiver)
	}
}
