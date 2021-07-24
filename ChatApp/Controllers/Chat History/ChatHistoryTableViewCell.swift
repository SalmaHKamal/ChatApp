//
//  TableViewCell.swift
//  ChatApp
//
//  Created by Salma Hassan on 1/24/21.
//  Copyright © 2021 salma. All rights reserved.
//

import UIKit

class ChatHistoryTableViewCell: UITableViewCell {

	// MARK: - Outlets
	@IBOutlet weak var receiverProfileImageView: LiveImageView!
	@IBOutlet weak var receiverNameLabel: UILabel!
	@IBOutlet weak var lastMessageLabel: UILabel!
	@IBOutlet weak var messageReadIndicatorView: LiveView!
	@IBOutlet weak var tempProfileImage: LiveView!
	@IBOutlet weak var nameFirstLettersLabel: UILabel!
	
	// MARK: - Constants
	static let nibName = String(describing: ChatHistoryTableViewCell.self)
    
	
	var model: ChatHistoryViewModel.ChatHistoryCellModel? {
		didSet {
			guard let model = model else {
				return
			}
			setupView(with: model)
		}
	}
	

	func setupView(with model: ChatHistoryViewModel.ChatHistoryCellModel) {
		setupProfileImage(with: model)
		lastMessageLabel.text = model.lastMessage
		receiverNameLabel.text = model.receiverDisplayName
		messageReadIndicatorView.backgroundColor = .clear //model.lastMessage.isRead ?  : .darkGray
	}
	
	private func setupProfileImage(with model: ChatHistoryViewModel.ChatHistoryCellModel) {
		guard let urlString = model.receiverPhotoUrl else {
			setupTempProfileImage(with: model.receiverDisplayName ?? "")
			return
		}
		
		let url = URL(string: urlString)
		receiverProfileImageView.sd_setImage(with: url)
		showProfileImage(true)
	}
	
	private func setupTempProfileImage(with userName: String) {
		showProfileImage(false)
		tempProfileImage.backgroundColor = .orange //FFB59B
		nameFirstLettersLabel.text = userName.pickFirstLetters()
	}
	
	private func showProfileImage(_ isShown: Bool) {
		receiverProfileImageView.isHidden = !isShown
		tempProfileImage.isHidden = isShown
	}
}
