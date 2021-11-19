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
	var coordinator: MainCoordinator?
	var scrollView: UIScrollView!
    
	func showLoadingIndicator(with text: String? = nil, hideAfter: TimeInterval? = nil) {
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
	func removeNotificationObservers() {
		NotificationCenter.default.removeObserver(self)
	}
	
	func addNotificationObservers() {
		// setup keyboard event
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	@objc func keyboardWillShow(notification:NSNotification){
		let userInfo = notification.userInfo!
		var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
		keyboardFrame = self.view.convert(keyboardFrame, from: nil)

		var contentInset:UIEdgeInsets = scrollView.contentInset
		contentInset.bottom = keyboardFrame.size.height
		scrollView.contentInset = contentInset
	}

	@objc func keyboardWillHide(notification:NSNotification){
		let contentInset:UIEdgeInsets = UIEdgeInsets.zero
		scrollView.contentInset = contentInset
	}
}
