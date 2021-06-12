//
//  Screens.swift
//  ChatApp
//
//  Created by Salma Hassan on 1/22/21.
//  Copyright © 2021 salma. All rights reserved.
//

import Foundation

enum Screens {
	case login
	case register
	case home
	case chatHistory
	case chat
	case chatGroup
	case settings
}

extension Screens {
	
	var nibName: String {
		switch self {
		case .login:
			return String(describing: LoginViewController.self)
		case .register:
			return String(describing: SignUpViewController.self)
		default:
			return ""
		}
	}
	
}
