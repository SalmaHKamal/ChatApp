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
	@IBOutlet weak var searchBarHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var headerStackView: UIStackView!
	
	// MARK: - Varibales
	enum HomeViews {
		case chat
		case contacts
		case groupChat
	}
	var viewModel: HomeViewModelProtocol?
	var isSearchSelected: Bool = false
	weak var searchVCDelegate: SearchableDelegate?
	
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
		resetSearchBarIfAppearing()
	}
	
	@IBAction func contactsBtnPressed(_ sender: Any) {
		setupViewController(for: .contacts)
		resetSearchBarIfAppearing()
	}
	
	@IBAction func groupChatBtnPressed(_ sender: Any) {
		setupViewController(for: .groupChat)
		resetSearchBarIfAppearing()
	}
	
	@IBAction func userProfileDidPressed(_ sender: Any) {
		viewModel?.showSettingsViewController()
	}
	
	@IBAction func searchButtonPressed(_ sender: Any) {
		isSearchSelected.toggle()
		UIView.animate(withDuration: 0.3) {
			self.searchBarHeightConstraint.constant = self.isSearchSelected ? 50 : 0
			self.headerHeightConstraint.constant = self.isSearchSelected ? 140 : 90
			if self.isSearchSelected {
				self.headerStackView.layoutIfNeeded()
				self.searchBar.becomeFirstResponder()
			}
		}
	}
	
	// MARK: - helper methods
	func resetSearchBarIfAppearing() {
		searchBar.text = nil
		searchBar.resignFirstResponder()
		if isSearchSelected {
			searchButtonPressed(self)
		}
	}
	
	private func setupView() {
		setupViewController(for: .chat)
		headerStackView.setCustomSpacing(0, after: navigationStackView)
	}
	
	private func setupViewController(for viewType: HomeViews) {
		contentView.subviews.forEach { (view) in
			view.removeFromSuperview()
		}
		
		let vc: BaseViewController!
		
		switch viewType {
		case .chat:
			let chatHistoryViewModel = ChatHistoryViewModel()
			self.searchVCDelegate = chatHistoryViewModel
			vc = ChatHistoryViewController(with: chatHistoryViewModel)
			
		case .contacts:
			let contactsViewModel = ContactsViewModel()
			self.searchVCDelegate = contactsViewModel
			vc = ContactsViewController(with: contactsViewModel)
			
		case .groupChat:
			vc = ChatHistoryViewController()
		}
		
		addChild(vc)
		vc.coordinator = coordinator
		moveUnderlineView(for: viewType)
		contentView.addSubview(vc.view)
		vc.view.frame = contentView.bounds
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

