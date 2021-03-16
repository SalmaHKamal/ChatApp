//
//  ReuesableProtocol.swift
//  ChatApp
//
//  Created by Salma Hassan on 3/16/21.
//  Copyright © 2021 salma. All rights reserved.
//

import Foundation
import UIKit

protocol Reuesable {
	static var reuseIdentifier: String { get }
}

extension Reuesable {
	static var reuseIdentifier: String {
		return String(describing: self)
	}
}

extension UITableViewCell: Reuesable {}

extension UITableView {
	func register<T: UITableViewCell>(_ class: T.Type) {
		register(`class`, forCellReuseIdentifier: T.reuseIdentifier)
	}
	
	func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
		return dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
	}
}
