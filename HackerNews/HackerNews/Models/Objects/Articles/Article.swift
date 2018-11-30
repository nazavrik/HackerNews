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
    let commentsCount: Int
    let date: Date?
    let commentIds: [Int]
    var content: String?
}

extension Article: ObjectType {
    init?(json: JSONDictionary) {
        guard
            let id = json["id"] as? Int,
            let title = json["title"] as? String,
            let url = json["url"] as? String,
            let score = json["score"] as? Int,
            let author = json["by"] as? String,
            let commentsCount = json["descendants"] as? Int,
            let timeStamp = json["time"] as? TimeInterval
            else {
                return nil
        }
        
        self.id = id
        self.title = title
        self.url = url
        self.score = score
        self.author = author
        self.commentsCount = commentsCount
        self.date = Date(timeIntervalSince1970: timeStamp)
        self.commentIds = json["kids"] as? [Int] ?? [Int]()
    }
}

extension Article {
    struct Requests {
        static func articleIds(for story: HNStoryType) -> Request<ArrayObject<Int>> {
            return Request(query: story.url)
        }
        
        static func article(for id: Int) -> Request<Article> {
            return Request(query: "item/\(id).json")
        }
    }
}
