//
//  Comment.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/20/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import Foundation

struct Comment {
    let id: Int
    let text: String
    let author: String
    let date: Date?
    let commentIds: [Int]
    let parentId: Int
}

extension Comment: ObjectType {
    init?(json: JSONDictionary) {
        guard
            let id = json["id"] as? Int,
            let text = json["text"] as? String,
            let author = json["by"] as? String,
            let timeStamp = json["time"] as? TimeInterval,
            let parentId = json["parent"] as? Int
            else { return nil }
        
        self.id = id
        self.text = text
        self.author = author
        self.date = Date(timeIntervalSince1970: timeStamp)
        self.commentIds = json["kids"] as? [Int] ?? [Int]()
        self.parentId = parentId
    }
}

extension Comment {
    struct Requests {
        static func comment(for id: Int) -> Request<Comment> {
            return Request(query: "item/\(id).json")
        }
    }
}
