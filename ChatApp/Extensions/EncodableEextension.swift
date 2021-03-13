//
//  EncodableEextension.swift
//  ChatApp
//
//  Created by Salma Hassan on 2/20/21.
//  Copyright © 2021 salma. All rights reserved.
//

import Foundation

extension Encodable {

    var dict : [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else { return nil }
        return json
    }
}
