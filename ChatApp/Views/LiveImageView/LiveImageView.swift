//
//  LiveImageView.swift
//  ChatApp
//
//  Created by Salma Hassan on 1/23/21.
//  Copyright © 2021 salma. All rights reserved.
//

import UIKit

@IBDesignable
class LiveImageView: UIImageView {

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
