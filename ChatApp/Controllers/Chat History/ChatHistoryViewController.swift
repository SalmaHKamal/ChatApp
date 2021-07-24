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

class ChatHistoryViewController: BaseViewController {

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

extension ChatHistoryViewController: ChatHistoryViewControllerProtocol {
	func reloadTableView() {
		tableView.reloadData()
	}
}
