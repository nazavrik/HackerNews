//
//  Article.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/10/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import Foundation

struct Article {
    let id: Int
    let title: String
    let url: String
    let score: Int
    let author: String
    let comments: Int
    let date: Date?
}

extension Article: ObjectType {
    init?(json: JSONDictionary) {
        guard
            let id = json["id"] as? Int,
            let title = json["title"] as? String,
            let url = json["url"] as? String,
            let score = json["score"] as? Int,
            let author = json["by"] as? String,
            let comments = json["descendants"] as? Int,
            let timeStamp = json["time"] as? TimeInterval
            else { return nil }
        
        self.id = id
        self.title = title
        self.url = url
        self.score = score
        self.author = author
        self.comments = comments
        self.date = Date(timeIntervalSince1970: timeStamp)
    }
}

extension Article {
    struct Requests {
        static var articleIds: Request<ArrayObject<Int>> {
            return Request(query: "topstories.json")
        }
        
        static func article(for id: Int) -> Request<Article> {
            return Request(query: "item/\(id).json")
        }
    }
}
