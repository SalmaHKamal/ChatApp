//
//  CallKitDelegateImplementer.swift
//  ChatApp
//
//  Created by Salma Hassan on 11/09/2021.
//  Copyright © 2021 salma. All rights reserved.
//

import Foundation
import CallKit

class CallKitDelegateImplementer: NSObject, CXProviderDelegate {
	
	// MARK: - Delegate Methods
	func providerDidReset(_ provider: CXProvider) {
		print(#function)
	}
	
	func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
		action.fulfill()
	}
	
	func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
		action.fulfill()
	}
	
	// MARK: - Helper Methods
	func startVoiceCall() {
		incomingCall()
//		let update = CXCallUpdate()
//		update.remoteHandle = CXHandle(type: .generic, value: "I'm calling you!")
//		provider.reportNewIncomingCall(with: UUID(),
//									   update: update) { (error) in
//			print(error?.localizedDescription.uppercased() as Any)
//		}
	}
	
	func incomingCall() {
		let provider = CXProvider(configuration: CXProviderConfiguration(localizedName: "My App"))
		provider.setDelegate(self, queue: nil)
		let controller = CXCallController()
		let transaction = CXTransaction(action: CXStartCallAction(call: UUID(),
																  handle: CXHandle(type: .generic,
																				   value: "Hey I am calling you!")))
		controller.request(transaction, completion: { error in })
	}
	
	func outgoingCall() {
		let provider = CXProvider(configuration: CXProviderConfiguration(localizedName: "My App"))
		provider.setDelegate(self, queue: nil)
		let controller = CXCallController()
		let transaction = CXTransaction(action: CXStartCallAction(call: UUID(),
																  handle: CXHandle(type: .generic,
																				   value: "You are calling me!!!")))
		controller.request(transaction, completion: { error in })
	}

}
