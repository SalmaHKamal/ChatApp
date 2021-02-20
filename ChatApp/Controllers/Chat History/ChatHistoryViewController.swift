//
//  ChatViewController.swift
//  ChatApp
//
//  Created by Salma Hassan on 1/25/21.
//  Copyright © 2021 salma. All rights reserved.
//

import UIKit

protocol ChatHistoryViewControllerProtocol: AnyObject {
	func reloadTableView()
}

class ChatHistoryViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView! {
		didSet {
			tableView.register(UINib(nibName: ChatHistoryTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: ChatHistoryTableViewCell.nibName)
		}
	}
	
	// MARK: - Variables
	var viewModel: ChatHistoryViewModelProtocol?
	
	// MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

		viewModel?.fetchData()
    }

	// MARK: - Inits
	convenience init(with viewModel: ChatHistoryViewModelProtocol) {
		self.init(nibName: nil, bundle: nil)
		self.viewModel = viewModel
		self.viewModel?.viewController = self
	}

}

extension ChatHistoryViewController: UITableViewDelegate {
	
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

extension ChatHistoryViewController: ChatHistoryViewControllerProtocol {
	func reloadTableView() {
		tableView.reloadData()
	}
}
