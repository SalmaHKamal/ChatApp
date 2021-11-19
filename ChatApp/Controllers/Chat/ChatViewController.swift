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
	func showLoading()
	func hideLoading()
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
			receiverName.text = viewModel?.receiverModel?.displayName
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

		setupNavigationBar()
		viewModel?.loadChat()
    }

	private func setupNavigationBar() {
		title = viewModel?.receiverModel?.displayName
		navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
																   NSAttributedString.Key.font: UIFont.TrebuchetMS(fontSize: 16)]
		navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.09047514945, green: 0.6231926084, blue: 0.5705589652, alpha: 1)
		navigationController?.view.tintColor = .white
		navigationController?.navigationBar.topItem?.title = ""
		// right items
//		let phoneItem = UIBarButtonItem(image: UIImage(named: "phone.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.white),
//										style: .done,
//										target: self,
//										action: nil)
//		let videoItem = UIBarButtonItem(image: UIImage(named: "video.fill")?.withTintColor(.white),
//										style: .done,
//										target: self,
//										action: nil)
//		navigationItem.rightBarButtonItems = [phoneItem]
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
			guard let models = self.viewModel?.chatMessageCellModels,
				  models.count > 0 else {
				return
			}
			let indexPath = IndexPath(row: models.count - 1, section: 0)
			self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
		}
	}
	
	func showLoading() {
		showLoadingIndicator()
	}
	
	func hideLoading() {
		hideLoadingIndicator()
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
