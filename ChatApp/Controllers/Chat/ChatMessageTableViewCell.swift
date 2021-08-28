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
	@IBOutlet private var textViewBackgroundView: LiveView!
	
	static let nibName: String = String(describing: ChatMessageTableViewCell.self)
	func setupView(with model: ChatMessageCellModel) {
		textView.text = model.messageContent
		userProfileImage.sd_setImage(with: model.profileImageUrl,
									 placeholderImage: #imageLiteral(resourceName: "username"))
		if model.isFromRightToLeft {
			flipCell()
			changeTextViewColor()
		}
	}
	
	private func flipCell() {
		contentView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
		userProfileImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
		textView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
	}
	
	private func changeTextViewColor() {
		textViewBackgroundView.backgroundColor = .lightGray
	}

}
