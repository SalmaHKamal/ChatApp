//
//  TimeIntervalExtension.swift
//  ChatApp
//
//  Created by Salma Hassan on 3/25/21.
//  Copyright © 2021 salma. All rights reserved.
//

import Foundation

extension TimeInterval {
	
	func getDate() -> String {
	  let dayTimePeriodFormatter = DateFormatter()
	  dayTimePeriodFormatter.timeZone = TimeZone.current
	  dayTimePeriodFormatter.dateFormat = "MMMM dd, yyyy - h:mm:ss a z"
	  return dayTimePeriodFormatter.string(from: Date(timeIntervalSince1970: self))
	}
}
