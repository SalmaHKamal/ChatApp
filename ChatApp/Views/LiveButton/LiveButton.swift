//
//  LiveButton.swift
//  ChatApp
//
//  Created by Salma Hassan on 1/2/21.
//  Copyright © 2021 salma. All rights reserved.
//

import UIKit

@IBDesignable
class LiveButton: UIButton {
	
	@IBInspectable
	var cornerRadius: CGFloat = 0 {
		didSet {
			layer.cornerRadius = cornerRadius
		}
	}
	
	@IBInspectable
	var borderColor: UIColor = .clear {
		didSet {
			layer.borderColor = borderColor.cgColor
		}
	}
	
	@IBInspectable
	var borderWidth: CGFloat = 0 {
		didSet {
			layer.borderWidth = borderWidth
		}
	}
	
}
