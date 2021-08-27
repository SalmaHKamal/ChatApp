//
//  SettingsViewController.swift
//  ChatApp
//
//  Created by Salma Hassan on 5/15/21.
//  Copyright © 2021 salma. All rights reserved.
//

import UIKit
import SDWebImage

class SettingsViewController: BaseViewController {

	// MARK: - Outlets
	@IBOutlet weak var profileImage: LiveImageView! {
		didSet {
			let profileImageUrl = viewModel?.imageUrl
			profileImage.sd_setImage(with: profileImageUrl, completed: nil)
		}
	}
	@IBOutlet weak var userEmail: UILabel!
	
	
	// MARK: - Variables
	private var viewModel: SettingsViewModelProtocol?
	
	// MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
	
	// MARK: - Inits
	convenience init(with viewModel: SettingsViewModelProtocol) {
		self.init(nibName: nil, bundle: nil)
		self.viewModel = viewModel
		self.viewModel?.viewController = self
	}
	
	@IBAction func logoutDidPressed(_ sender: Any) {
		viewModel?.logout()
	}
}
