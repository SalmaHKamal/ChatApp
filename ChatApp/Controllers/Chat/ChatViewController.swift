//
//  ChatViewController.swift
//  ChatApp
//
//  Created by Salma Hassan on 2/13/21.
//  Copyright © 2021 salma. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol ChatViewControllerProtocol: AnyObject {
	func reloadTableView()
}

class ChatViewController: UIViewController {

	// MARK: - Outlets
	@IBOutlet weak var sendMessageBtn: UIButton! {
		didSet {
			sendMessageBtn.rx.tap.subscribe({ [weak self] _ in
				let messageContent: String = self?.messageTextView.text ?? ""
				self?.viewModel?.saveMessage(content: messageContent)
				
				}).disposed(by: disposeBag)
		}
	}
	@IBOutlet weak var messageTextView: UITextView!
	
	// MARK: - Variables
	var viewModel: ChatViewModelProtocol?
	let disposeBag: DisposeBag = DisposeBag()
	
	// MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

		viewModel?.loadChat()
    }
	
	// MARK: - Inits
	convenience init(with viewModel: ChatViewModelProtocol) {
		self.init(nibName: nil, bundle: nil)
		self.viewModel = viewModel
		self.viewModel?.viewController = self
	}

}

extension ChatViewController: ChatViewControllerProtocol {
	func reloadTableView() {
		
	}
}
