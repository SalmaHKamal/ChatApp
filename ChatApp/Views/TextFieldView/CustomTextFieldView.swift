//
//  CustomTextFieldView.swift
//  ChatApp
//
//  Created by Salma Hassan on 1/1/21.
//  Copyright © 2021 salma. All rights reserved.
//

import UIKit

class CustomTextFieldView: UIView {

	@IBOutlet private weak var textField: UITextField!
	@IBOutlet weak var imageView: UIImageView!
	
	
	func setupView(imageName: String, placeholderText: String) {
		imageView.image = UIImage(named: imageName)
		textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [
			NSAttributedString.Key.foregroundColor: UIColor.white,
			NSAttributedString.Key.font: UIFont.TrebuchetMS(fontSize: 15)
		])
	}
	
	static func create() -> CustomTextFieldView? {
		return Bundle.main.loadNibNamed(String(describing: Self.self),
										owner: self,
										options: nil)?.first as? CustomTextFieldView
	}

}
