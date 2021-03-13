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
	}
	
	// MARK: - Login
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
	
	private func createUserModel(from authResult: AuthDataResult?) -> UserModel {
		let userModel = UserModel(uid: authResult?.user.uid,
								  displayName: authResult?.user.displayName,
								  email: authResult?.user.email,
								  phoneNumber: authResult?.user.phoneNumber,
								  photoUrl: authResult?.user.photoURL,
								  refreshToken: authResult?.user.refreshToken)
		
		return userModel
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

// MARK: - Helper Methods
extension FirebaseManager {
	
	func getContacts(completion: @escaping (_ contactsInfo: [UserModel]?) -> Void) {
		guard let uid = getCurrentUserID() else {
			completion(nil)
			return
		}
		
		var contactsInfo: [UserModel]? = []
		firestore.collection(FirestoreCollections.users.rawValue)
			.whereField("uid", isNotEqualTo: uid)
			.getDocuments { (docs, error) in
				if let _ = error {
					completion(nil)
					return
				}
				
				
				docs?.documents.forEach({ (doc) in
					let dataDic: [String: Any] = doc.data()
					guard let contactInfo: UserModel = UserModel(dictionary: dataDic) else {
						completion(nil)
						return
					}
					contactsInfo?.append(contactInfo)
				})
				
				completion(contactsInfo)
		}
		
	}
	
	private func getCurrentUserID() -> String? {
		return Auth.auth().currentUser?.uid
	}
	
	// TODO: - to be removed in useless
	func getCurrentUserProfileImage(completion: @escaping (_ profileImage: String?) -> Void) {
		guard let uid = getCurrentUserID() else {
			completion(nil)
			return
		}
		
		firestore.collection(FirestoreCollections.users.rawValue)
			.document(uid)
			.getDocument { (doc, error) in
				if let _ = error {
					completion(nil)
					return
				}
				
				let userInfo = doc?.data()
				if let photoUrl: String = userInfo?["photoUrl"] as? String {
					completion(photoUrl)
				}
				
		}
	}
	
	func getUserInfo(for uid: String, completion: @escaping (_ userModel: UserModel?) -> Void) {
		firestore.collection(FirestoreCollections.users.rawValue)
			.document(uid)
			.getDocument { (doc, error) in
				if let _ = error {
					completion(nil)
					return
				}
				
				let userInfo = doc?.data()
				let userModel: UserModel? =  UserModel(dictionary: userInfo)
				completion(userModel)
		}
	}
}

// MARK: - Chat Collection
typealias ChatCompletion = (_ messages: [MessageModel]?, _ docRef: DocumentReference?) -> Void
typealias ChatHistoryCompletion = (_ messagesDic: [String: (receiver: UserModel, messages: [MessageModel])]) -> Void

extension FirebaseManager {
	
	func loadChat(for receiverModel: UserModel, completion: @escaping ChatCompletion) {
		guard let currentUserID = getCurrentUserID(),
			let receiverID = receiverModel.uid else {
				return
		}
		let users = [currentUserID, receiverID]
		
		firestore.collection(FirestoreCollections.chat.rawValue)
			.whereField("users", arrayContains: currentUserID)
			.getDocuments { (chatQuerySnap, error) in
				if error != nil {
					completion(nil, nil)
					return
				}
				
				guard let chatQuerySnap = chatQuerySnap ,
					chatQuerySnap.documents.count > 0 else {
						
						self.createChat(users, completion: completion)
						return
				}
				
				var docRef: QueryDocumentSnapshot?
				chatQuerySnap.documents.forEach { (document) in
					if let users = document["users"] as? [String] {
						if users.contains(receiverID) {
							docRef = document
						}
					}
				}
				
				if let documentRef = docRef?.reference {
					self.loadMessages(docRef: documentRef, completion: completion)
				} else {
					self.createChat(users, completion: completion)
				}
				
		}
	}
	
	private func loadMessages(docRef: DocumentReference, completion: @escaping ChatCompletion) {
		docRef.collection(FirestoreCollections.messages.rawValue)
			.order(by: "id", descending: false)
			.addSnapshotListener(includeMetadataChanges: true) { (querySnapshot, error) in
				if error != nil {
					completion(nil, docRef)
					return
				}
				
				let messages = querySnapshot?.documents.compactMap { MessageModel(dictionary: $0.data()) }
				completion(messages, docRef)
				
		}
	}
	
	private func createChat(_ users: [String], completion: @escaping ChatCompletion) {
		firestore.collection(FirestoreCollections.chat.rawValue)
			.addDocument(data: ["users": users]) { (error) in
				completion(nil, nil)
		}
	}
	
	func loadChatHistoryForCurrentUser(completion: @escaping ChatHistoryCompletion) {
		guard let currentUserID = getCurrentUserID() else {
			return
		}
		
//		var receivers: [UserModel] = []
////		var receiversIDs: [String] = []
//		var messagesDic: [String: [MessageModel]] = [:]
		var result: [String: (receiver: UserModel, messages: [MessageModel])] = [:]
		
		firestore.collection(FirestoreCollections.chat.rawValue)
			.whereField("users", arrayContains: currentUserID)
			.getDocuments { (chatQuerySnap, error) in
				
				chatQuerySnap?.documents.forEach({ (doc) in
					if let users: [String] = doc["users"] as? [String] {
						
						
						let IDs = users.filter({ $0 != currentUserID })
						
						if IDs.count == 1,
							let userID = IDs.first {
							
							self.loadMessages(docRef: doc.reference) { (messages, _) in
								let messagesArray = messages
								
								self.getUserInfo(for: userID) { (userModel) in
									let userModelGlobal = userModel
									
									if userModelGlobal != nil, messagesArray != nil {
										result.updateValue((userModelGlobal! , messagesArray!), forKey: userID)
									}
									
									completion(result)
								}
								
								
							}
						}
					}
					
					
					
				})
				
		}
	}
	
	func saveMessage(_ message: MessageModel, with docRef: DocumentReference?) {
		guard let messageDictionry: [String: Any] = message.dict else {
			return
		}
		
		docRef?.collection(FirestoreCollections.messages.rawValue).addDocument(data: messageDictionry, completion: nil)
	}
	
	func getSenderInfo(_ receiverModel: UserModel, completion: @escaping ((name: String, id: String)?) -> Void){
		guard let currentUserID: String = getCurrentUserID() else {
			completion(nil)
			return
		}
		
		guard currentUserID == receiverModel.uid else {
			constructInfoTuple(for: currentUserID, completion: completion)
			return
		}
		
		guard let receiverID: String = receiverModel.uid else {
			completion(nil)
			return
		}
		
		constructInfoTuple(for: receiverID, completion: completion)
	}
	
	private func constructInfoTuple(for userID: String, completion: @escaping ((name: String, id: String)?) -> Void) {
		getUserInfo(for: userID) { (userModel) in
			guard let name = userModel?.displayName,
				let id = userModel?.uid else {
					completion(nil)
					return
			}
			
			completion((name, id))
			
		}
	}
}



