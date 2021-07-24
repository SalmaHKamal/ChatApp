//
//  SearchableDelegate.swift
//  ChatApp
//
//  Created by Salma Hassan on 24/07/2021.
//  Copyright © 2021 salma. All rights reserved.
//

import Foundation

protocol SearchableDelegate: AnyObject {
	var isSearching: Bool { get set }
	
	func didChangeSearchText(with text: String)
	func didCancelSearching()
	func didBeginSearching()
}

extension SearchableDelegate {
	func didCancelSearching() {
		isSearching = false
	}
	
	func didBeginSearching() {
		isSearching = true
	}
}
