//
//  CoordinatorProtocol.swift
//  ChatApp
//
//  Created by Salma Hassan on 11/06/2021.
//  Copyright © 2021 salma. All rights reserved.
//

import UIKit

protocol Coordinator {
	var childCoordinators: [Coordinator] { get set }
	var navigationController: UINavigationController { get set }

	func start()
}
