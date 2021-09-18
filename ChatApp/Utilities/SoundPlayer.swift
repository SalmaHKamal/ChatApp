//
//  SoundPlayer.swift
//  ChatApp
//
//  Created by Salma Hassan on 18/09/2021.
//  Copyright © 2021 salma. All rights reserved.
//

import Foundation
import AVFoundation

enum ChatSounds {
	case sendMessage
	
	var fileName: String {
		switch self {
		case .sendMessage:
			return "COMCell_Message sent (ID 1313)_BSB"
		}
	}
	
	var fileExtension: String {
		switch self {
		case .sendMessage:
			return "aac"
		}
	}
}

class SoundPlayer {
	func play(sound: ChatSounds) {
		guard let path = Bundle.main.path(forResource: sound.fileName,
										  ofType: sound.fileExtension) else {
			return
		}
		
		let url = URL(fileURLWithPath: path)
		
		do {
			let audio = try AVAudioPlayer(contentsOf: url)
			audio.play()
			
		} catch {
			assertionFailure("Couldn't load sound file with \(error.localizedDescription)".uppercased())
		}
	}
}
