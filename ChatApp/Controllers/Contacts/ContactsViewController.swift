//
//  ContactsViewController.swift
//  ChatApp
//
//  Created by Salma Hassan on 1/25/21.
//  Copyright © 2021 salma. All rights reserved.
//

import UIKit

protocol ContactsViewControllerProtocol: AnyObject {
	func reloadCollectionView()
}

class ContactsViewController: BaseViewController {

	// MARK: - Outlets
	@IBOutlet weak var collectionView: UICollectionView! {
		didSet {
			collectionView.register(UINib(nibName: ContactCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: ContactCollectionViewCell.nibName)
		}
	}
	
	// MARK: - Varibales
	var viewModel: ContactsViewModelProtocol?
	
	// MARK: - LifeCycle
	override func viewWillAppear(_ animated: Bool) {
		viewModel?.fetchData()
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
    }
	
	// MARK: - Inits
	convenience init(with viewModel: ContactsViewModelProtocol) {
		self.init(nibName: nil, bundle: nil)
		self.viewModel = viewModel
		self.viewModel?.viewController = self
	}
}

extension ContactsViewController: UICollectionViewDelegate {
	
}

extension ContactsViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return viewModel?.contactsInfo?.count ?? 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContactCollectionViewCell.nibName, for: indexPath) as? ContactCollectionViewCell else {
			return UICollectionViewCell()
		}
		
		cell.userModel = viewModel?.contactsInfo?[indexPath.row] 
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		viewModel?.presentChatViewController(for: indexPath)
	}
}

extension ContactsViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 200, height: 200)
	}
}

extension ContactsViewController: ContactsViewControllerProtocol {
	func reloadCollectionView() {
		collectionView.reloadData()
	}
}
