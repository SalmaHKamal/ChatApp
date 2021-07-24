//
//  DateExtensions.swift
//  ChatApp
//
//  Created by Salma Hassan on 24/07/2021.
//  Copyright © 2021 salma. All rights reserved.
//

import Foundation
import Firebase

extension Date {
	var timestamp: Timestamp? {
		return Timestamp(date: self)
	}
}

