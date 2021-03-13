//
//  UIApplication+Extensions.swift
//  ChatApp
//
//  Created by Salma Hassan on 1/23/21.
//  Copyright © 2021 salma. All rights reserved.
//

import UIKit

extension UIApplication {
	static func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
		if let navigationController = controller as? UINavigationController {
			return topViewController(controller: navigationController.visibleViewController)
		}
		else if let tabController = controller as? UITabBarController {
			if let selected = tabController.selectedViewController {
				return topViewController(controller: selected)
			}
		}
		else if let presented = controller?.presentedViewController {
			return topViewController(controller: presented)
		}
		return controller
	}
}

