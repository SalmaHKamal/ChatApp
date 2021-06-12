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
		receiverProfileImageView.sd_setImage(with: model.receiverPhotoUrl, placeholderImage: UIImage(named: "person.fill"))
		lastMessageLabel.text = model.lastMessage.content
		receiverNameLabel.text = model.receiverDisplayName
		messageReadIndicatorView.backgroundColor = model.lastMessage.isRead ? .clear : .darkGray
	}
    
}
