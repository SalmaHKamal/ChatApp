//
//  HomeViewController.swift
//  ChatApp
//
//  Created by Salma Hassan on 1/22/21.
//  Copyright © 2021 salma. All rights reserved.
//

import UIKit

protocol HomeViewControllerProtocol: AnyObject {
	func updateUserProfileImage()
}

class HomeViewController: BaseViewController {

	// MARK: - Outlets
	@IBOutlet private weak var userProfileImage: LiveImageView!
	@IBOutlet private weak var navigationStackView: UIStackView!
	@IBOutlet private weak var contentView: UIView!
	
	// MARK: - Varibales
	enum HomeViews {
		case chat
		case contacts
		case groupChat
	}
	var viewModel: HomeViewModelProtocol?
	
	// MARK: - LifeCycle
	override func viewWillAppear(_ animated: Bool) {
		coordinator?.showNavigationBar(false)
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
		viewModel?.fetchData()
    }
	
	// MARK: - Inits
	convenience init(with viewModel: HomeViewModelProtocol) {
		self.init(nibName: nil, bundle: nil)
		self.viewModel = viewModel
		self.viewModel?.viewController = self
	}

	// MARK: - Actions
	@IBAction func chatBtnPressed(_ sender: Any) {
		setupViewController(for: .chat)
	}
	
	@IBAction func contactsBtnPressed(_ sender: Any) {
		setupViewController(for: .contacts)
	}
	
	@IBAction func groupChatBtnPressed(_ sender: Any) {
		setupViewController(for: .groupChat)
	}
	
	@IBAction func userProfileDidPressed(_ sender: Any) {
		viewModel?.showSettingsViewController()
	}
	
	// MARK: - helper methods
	private func setupView() {
		setupViewController(for: .chat)
	}
	
	private func setupViewController(for viewType: HomeViews) {
		contentView.subviews.forEach { (view) in
			view.removeFromSuperview()
		}
		
		let vc: BaseViewController!
		
		switch viewType {
		case .chat:
			vc = ChatHistoryViewController(with: ChatHistoryViewModel())
		case .contacts:
			vc = ContactsViewController(with: ContactsViewModel())
		case .groupChat:
			vc = ChatHistoryViewController()
		}
		
		vc.coordinator = coordinator
		moveUnderlineView(for: viewType)
		contentView.addSubview(vc.view)
		vc.view.frame = contentView.bounds
		addChild(vc)
	}
	
	private func moveUnderlineView(for viewType: HomeViews) {
		
		navigationStackView.arrangedSubviews.forEach { (view) in
			view.subviews.forEach { (subView) in
				subView.isHidden = subView.tag == 1
			}
		}
		
		switch viewType {
		case .chat:
			navigationStackView.arrangedSubviews.first?.subviews.forEach({ (view) in
				view.isHidden = false
			})
		case .contacts:
			navigationStackView.arrangedSubviews[1].subviews.forEach({ (view) in
				view.isHidden = false
			})
		case .groupChat:
			navigationStackView.arrangedSubviews.last?.subviews.forEach({ (view) in
				view.isHidden = false
			})
		}
	}
}

extension HomeViewController: HomeViewControllerProtocol {
	func updateUserProfileImage() {
		guard let viewModel = viewModel, let imageUrl =  viewModel.profileImageUrl else {
			return
		}
		userProfileImage.sd_setImage(with: URL(string: imageUrl),
									 placeholderImage: UIImage(named: "person.fill"))
	}
}

