//
//  Article.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/10/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import Foundation

struct Article {
    let title: String
    let description: String?
    let date: Date?
    
    init(title: String, description: String? = nil, date: Date? = nil) {
        self.title = title
        self.description = description
        self.date = date
    }
}
