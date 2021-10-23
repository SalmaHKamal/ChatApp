//
//  ActionSheet.swift
//  ChatApp
//
//  Created by Salma Hassan on 18/09/2021.
//  Copyright © 2021 salma. All rights reserved.
//

import UIKit

enum ActionSheetActions {
	case uploadPhoto
	case uploadVideo
	case openCamera
	case uploadDocument
	case location
	case contacts
	
	var name: String {
		switch self {
		case .uploadPhoto:
			return "Upload Photo"

		case .uploadVideo:
			return "Upload Video"
			
		case .openCamera:
			return "Open Camera"
			
		case .uploadDocument:
			return "Upload Document"
			
		case .location:
			return "Location"
			
		case .contacts:
			return "Contacts"
		}
	}
}

struct ActionSheetActionModel {
	var type: ActionSheetActions
	var completion: ((UIAlertAction) -> Void)?
}

struct ActionSheetModel {
	var title: String?
	var message: String?
	var actions: [ActionSheetActionModel] = []
	var hasCloseAction: Bool = true
}

class ActionSheet {
	func present(with model: ActionSheetModel, in target: UIViewController) {
		let actionSheet = UIAlertController(title: model.title,
											message: model.message,
											preferredStyle: .actionSheet)
		
		if model.hasCloseAction {
			let closeAction = UIAlertAction(title: "Cancel",
											style: .cancel)
			actionSheet.addAction(closeAction)
		}
		
		if model.actions.count > 0 {
			model.actions.forEach {
				actionSheet.addAction(UIAlertAction(title: $0.type.name,
													style: .default,
													handler: $0.completion))
			}
		}
		
		target.present(actionSheet, animated: true, completion: nil)
	}
}
