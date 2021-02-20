//
//  BaseViewController.swift
//  ChatApp
//
//  Created by Salma Hassan on 1/23/21.
//  Copyright © 2021 salma. All rights reserved.
//

import UIKit
import JGProgressHUD

class BaseViewController: UIViewController {
	
	let progressHud = JGProgressHUD(style: .dark)
    
	func showLoadingIndicator(with text: String?, hideAfter: TimeInterval? = nil) {
		progressHud.textLabel.text = text
		progressHud.show(in: self.view, animated: true)
		if let hideAfter = hideAfter {
			progressHud.dismiss(afterDelay: hideAfter)
		}
	}
	
	func hideLoadingIndicator() {
		progressHud.dismiss(animated: true)
	}
}

// MARK: - Keyboard handeling
extension BaseViewController {
	func removeNotificationObservers(for observer: RegisterationProtocol) {
		NotificationCenter.default.removeObserver(observer)
	}
	
	func addNotificationObservers(_ observer: RegisterationProtocol) {
		// setup keyboard event
		NotificationCenter.default.addObserver(observer, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(observer, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	@objc func keyboardWillShow(notification:NSNotification){
		guard let currentNotificationObserver = UIApplication.topViewController(controller: self) as? RegisterationProtocol else {
			return
		}
		let userInfo = notification.userInfo!
		var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
		keyboardFrame = self.view.convert(keyboardFrame, from: nil)

		var contentInset:UIEdgeInsets = currentNotificationObserver.scrollView.contentInset
		contentInset.bottom = keyboardFrame.size.height
		currentNotificationObserver.scrollView.contentInset = contentInset
	}

	@objc func keyboardWillHide(notification:NSNotification){
		guard let currentNotificationObserver = UIApplication.topViewController(controller: self) as? RegisterationProtocol else {
			return
		}
		let contentInset:UIEdgeInsets = UIEdgeInsets.zero
		currentNotificationObserver.scrollView.contentInset = contentInset
	}
}
