//
//  ContactCollectionViewCell.swift
//  ChatApp
//
//  Created by Salma Hassan on 1/25/21.
//  Copyright © 2021 salma. All rights reserved.
//

import UIKit
import SDWebImage

class ContactCollectionViewCell: UICollectionViewCell {

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var contactImageView: LiveImageView!
	
	// MARK: - Constants
	static let nibName = String(describing: ContactCollectionViewCell.self)
	
	// MARK: - Variables
	var userModel: UserModel? {
		didSet {
			if let userModel: UserModel = userModel {
				setupView(with: userModel)
			}
		}
	}
	
	func setupView(with model: UserModel) {
		nameLabel.text = model.displayName
		contactImageView.sd_setImage(with: model.photoUrl, placeholderImage: UIImage(named: "person.fill"))
	}

}
