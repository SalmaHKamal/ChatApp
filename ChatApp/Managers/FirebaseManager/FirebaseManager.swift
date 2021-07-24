//
//  FirebaseManager.swift
//  ChatApp
//
//  Created by Salma Hassan on 1/22/21.
//  Copyright © 2021 salma. All rights reserved.
//

import Foundation
import Firebase


struct FirebaseManager {
	
	// MARK: - Variables
	let storage = Storage.storage()
	let firestore = Firestore.firestore()
	typealias AuthResult = (user: UserModel?, error: String?)
	enum FirestoreCollections: String {
		case users
		case chat
		case messages
		case chatHistory
	}
	let userDefaultsManager = UserDefaultsManager()
}

// MARK: - Login
extension FirebaseManager {
	fileprivate func handleAuthResult(_ error: Error?, _ authResult: AuthDataResult?, _ completion: @escaping (AuthResult) -> Void ) {
		if let error = error {
			completion((nil, error.localizedDescription))
		} else {
			
			let userModel = createUserModel(from: authResult)
			completion((userModel, nil))
		}
	}

	func login(with email: String, and password: String, completion: @escaping (AuthResult) -> Void ) {
		Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
			self.handleAuthResult(error, authResult, completion)
		}
	}
	
	func logout() {
		do {
			try Auth.auth().signOut()
		} catch {
			fatalError("Failed to signout!! ")
		}
	}
}

// MARK: - Registeration
extension FirebaseManager {
	func register(with email: String, and password: String, and username: String, and image: UIImage?, completion: @escaping (AuthResult) -> Void ) {
		
		// register user
		Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
			
			if let error = error {
				completion((nil, error.localizedDescription))
			} else {
				
				if let image = image {
					// save uploaded profile image
					self.saveProfileImage(image, authResult, username, completion: completion)
					
				} else {
					let userModel: UserModel = self.createUserModel(from: authResult)
					completion((userModel, nil))
				}
			}
		}
	}
	
	private func saveProfileImage(_ image: UIImage, _ authResult: AuthDataResult?, _ username: String, completion: @escaping (AuthResult) -> Void) {
		let filename: String = UUID().uuidString
		let storageRef = storage.reference(withPath: "/images/\(filename)")
		let imageData: Data = image.jpegData(compressionQuality: 0.75) ?? Data()
		storageRef.putData(imageData, metadata: nil) { (metaData, error) in
			if let error = error {
				completion((nil, error.localizedDescription))
			} else {
				
				// get download url
				storageRef.downloadURL { (url, error) in
					if let error = error {
						completion((nil, error.localizedDescription))
					} else {
						
						// save user info to firestore
						self.saveUserInfoToFirestore(with: authResult, url, username, completion)
					}
				}
			}
		}
		
	}
	
	private func saveUserInfoToFirestore(with authResult: AuthDataResult?, _ photoURL: URL?, _ username: String, _ completion: @escaping (AuthResult) -> Void) {
		let userModel: UserModel = createUserModel(from: authResult)
		guard let uid = userModel.uid else {
			return
		}
		let data: [String: Any] = ["uid": uid,
								   "name": userModel.displayName ?? username as Any,
								   "email": userModel.email as Any,
								   "refreshToken": userModel.refreshToken as Any,
								   "phoneNumber": userModel.phoneNumber as Any,
								   "photoUrl": userModel.photoUrl?.absoluteString ?? photoURL?.absoluteString as Any]
		firestore.collection(FirestoreCollections.users.rawValue)
			.document(uid)
			.setData(data) { (error) in
				if let error = error {
					completion((nil, error.localizedDescription))
				} else {
					completion((userModel, nil))
				}
		}
	}
}

