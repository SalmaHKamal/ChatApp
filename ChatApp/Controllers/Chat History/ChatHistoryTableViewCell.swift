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
	
	// MARK: - Constants
	static let nibName = String(describing: ChatHistoryTableViewCell.self)
    
	
	var model: ChatHistoryViewModel.ChatHistoryCellModel? {
		didSet {
			if model != nil {
				setupView()
			}
		}
	}
	

	func setupView() {
		receiverProfileImageView.sd_setImage(with: model?.receiverPhotoUrl, placeholderImage: UIImage(named: "person.fill"))
		lastMessageLabel.text = model?.lastMessage.content
		receiverNameLabel.text = model?.receiverDisplayName
	}
    
}
