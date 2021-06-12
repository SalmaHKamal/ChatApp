//
//  ChatMessageTableViewCell.swift
//  ChatApp
//
//  Created by Salma Hassan on 3/13/21.
//  Copyright © 2021 salma. All rights reserved.
//

import UIKit

class ChatMessageTableViewCell: UITableViewCell {

	@IBOutlet weak var textView: UITextView!
	@IBOutlet weak var userProfileImage: LiveImageView!
	
	static let nibName: String = String(describing: ChatMessageTableViewCell.self)
	
	func setupView(with model: ChatMessageCellModel) {
		textView.text = model.messageContent
		userProfileImage.sd_setImage(with: model.user?.photoUrl,
									 placeholderImage: #imageLiteral(resourceName: "username"))
		
		setupContent(model.contentDirection)
	}
	
	fileprivate func setupContent(_ direction: ChatContentDirection) {
		if direction == .right {
			self.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
			self.textView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
			self.textView.textAlignment = .right
			self.userProfileImage.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
		}
	}
}
