//
//  HomeVC+SearchBar.swift
//  ChatApp
//
//  Created by Salma Hassan on 24/07/2021.
//  Copyright © 2021 salma. All rights reserved.
//

import UIKit

extension HomeViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		searchVCDelegate?.didChangeSearchText(with: searchText)
	}
	
	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		searchVCDelegate?.didBeginSearching()
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		resetSearchBarIfAppearing()
		searchVCDelegate?.didCancelSearching()
	}
}
