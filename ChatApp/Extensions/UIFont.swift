//
//  UIFont.swift
//  ChatApp
//
//  Created by Salma Hassan on 1/2/21.
//  Copyright © 2021 salma. All rights reserved.
//

import UIKit

extension UIFont {
	
	class func TrebuchetMS(fontSize: CGFloat) -> UIFont {
		guard let font = UIFont.init(name: "Trebuchet MS", size: fontSize) else {
			return UIFont.systemFont(ofSize: fontSize)
		}
		return font
	}
}
