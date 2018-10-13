//
//  ObjectType.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/12/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String: Any?]
typealias JSONArray = [Any?]

protocol ObjectType {
    init?(json: JSONDictionary)
    init?(json: JSONArray)
}

extension ObjectType {
    init?(json: JSONDictionary) { return nil }
    init?(json: JSONArray) { return nil }
}

extension Array where Element: ObjectType {
    init(json: [JSONDictionary]) {
        let value = json.compactMap(Iterator.Element.init)
        self = value
    }
}
