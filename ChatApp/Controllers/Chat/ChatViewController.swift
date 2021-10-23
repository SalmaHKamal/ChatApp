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
	func showImagePicker()
}

class ChatViewController: BaseViewController {

	// MARK: - Outlets
	@IBOutlet weak var sendMessageBtn: UIButton! {
		didSet {
			sendMessageBtn.rx.tap.subscribe({ [weak self] _ in
				let messageContent: String = self?.messageTextView.text ?? ""
				self?.viewModel?.saveMessage(content: messageContent, photo: nil)
				self?.messageTextView.text = ""
				self?.viewModel?.playSound()
				
				}).disposed(by: disposeBag)
		}
	}
	@IBOutlet weak var messageTextView: UITextView!
	@IBOutlet weak var receiverName: UILabel! {
		didSet {
			receiverName.text = viewModel?.receiverModel?.name
		}
	}
	@IBOutlet weak var chatTableView: UITableView! {
		didSet {
			chatTableView.delegate = self
			chatTableView.dataSource = self
			chatTableView.register(UINib(nibName: ChatMessageTableViewCell.nibName, bundle: nil),
								   forCellReuseIdentifier: ChatMessageTableViewCell.nibName)
			chatTableView.register(UINib(nibName: ChatPhotoMessageTableViewCell.reuseId, bundle: nil),
								   forCellReuseIdentifier: ChatPhotoMessageTableViewCell.reuseId)
		}
	}
	
	// MARK: - Variables
	private var viewModel: ChatViewModelProtocol?
	private let disposeBag: DisposeBag = DisposeBag()
	private var imagePicker: ImagePicker?
	
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

	// MARK: - Actions
	@IBAction private func attachmentButtonDidPressed(_ sender: UIButton) {
		viewModel?.presentActionSheet()
	}
}

extension ChatViewController: ChatViewControllerProtocol {
	func reloadTableView() {
		chatTableView.reloadData()
		scrollToBottom()
	}
	
	func showImagePicker() {
		imagePicker = ImagePicker(presentationController: self, delegate: self)
		imagePicker?.present(from: view)
	}
	
	func scrollToBottom(){
		DispatchQueue.main.async {
			let indexPath = IndexPath(row: (self.viewModel?.chatMessageCellModels.count ?? 0) - 1, section: 0)
			self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
		}
	}
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel?.chatMessageCellModels.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let model = viewModel?.chatMessageCellModels[indexPath.row] {
			if model.messageType == .text {
				return dequeueTextMessageCell(model, indexPath: indexPath)
			} else {
				return dequeuePhotoMessageCell(model, indexPath: indexPath)
			}
		}
		return UITableViewCell()
	}
	
	private func dequeueTextMessageCell(_ model: ChatMessageCellModel, indexPath: IndexPath) -> UITableViewCell {
		guard let cell = chatTableView.dequeueReusableCell(withIdentifier: ChatMessageTableViewCell.nibName,
														   for: indexPath) as? ChatMessageTableViewCell else {
			return UITableViewCell()
		}
		cell.setupView(with: model)
		return cell
	}
	
	private func dequeuePhotoMessageCell(_ model: ChatMessageCellModel, indexPath: IndexPath) -> UITableViewCell {
		guard let cell = chatTableView.dequeueReusableCell(withIdentifier: ChatPhotoMessageTableViewCell.reuseId,
														   for: indexPath) as? ChatPhotoMessageTableViewCell else {
			return UITableViewCell()
		}
		cell.setupView(with: model)
		return cell
	}
}

extension ChatViewController: ImagePickerDelegate {
	func didSelect(image: UIImage?) {
		viewModel?.saveMessage(content: nil, photo: image)
	}
}
