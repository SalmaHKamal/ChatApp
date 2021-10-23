//
//  ChatPhotoMessageTableViewCell.swift
//  ChatApp
//
//  Created by Salma Hassan on 23/10/2021.
//  Copyright © 2021 salma. All rights reserved.
//

import UIKit
import SDWebImage

class ChatPhotoMessageTableViewCell: UITableViewCell {

	// MARK: - Outlets
	@IBOutlet weak var profileImageView: LiveImageView!
	@IBOutlet private weak var messageImageView: UIImageView!
	
	// MARK: - Variables
	static let reuseId = String(describing: ChatPhotoMessageTableViewCell.self)
	
	func setupView(with model: ChatMessageCellModel) {
		if let profileImageUrl = model.profileImageUrl {
			profileImageView.sd_setImage(with: profileImageUrl)
		}
		guard let urlString = model.photoMessageUrl, let url = URL(string: urlString) else {
			return
		}
		messageImageView.sd_setImage(with: url, completed: nil)
		
		if model.isFromRightToLeft {
			flipCell()
		}
		
	}
	
	private func flipCell() {
		contentView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
		messageImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
		profileImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
	}
}
