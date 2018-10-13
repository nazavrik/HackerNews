//
//  ArrayObject.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/12/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import Foundation

struct ArrayObject<T> {
    let items: [T]
}

extension ArrayObject: ObjectType {
    init?(json: JSONArray) {
        var items = [T]()
        for element in json {
            if let item = element as? T {
                items.append(item)
            }
        }
        self.items = items
    }
}
