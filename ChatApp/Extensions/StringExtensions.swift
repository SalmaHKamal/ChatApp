//
//  StringExtensions.swift
//  ChatApp
//
//  Created by Salma Hassan on 24/07/2021.
//  Copyright © 2021 salma. All rights reserved.
//

import Foundation

extension String {
	func pickFirstLetters() -> String {
		let space: Character = " "
		let words = self.split(separator: space)
		var result = ""
		words.forEach({ result.append(contentsOf: $0.prefix(1).uppercased()) })
		return result
	}
}
