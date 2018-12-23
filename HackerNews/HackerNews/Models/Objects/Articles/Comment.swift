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
    let deleted: Bool
    var level = 0
    var subcomments = [Comment]()
}

extension Comment: ObjectType {
    init?(json: JSONDictionary) {
        guard
            let id = json["id"] as? Int,
            let timeStamp = json["time"] as? TimeInterval,
            let parentId = json["parent"] as? Int
            else { return nil }
        
        self.id = id
        self.text = json["text"] as? String ?? ""
        self.author = json["by"] as? String ?? ""
        self.date = Date(timeIntervalSince1970: timeStamp)
        self.commentIds = json["kids"] as? [Int] ?? []
        self.deleted = json["deleted"] as? Bool ?? false
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
