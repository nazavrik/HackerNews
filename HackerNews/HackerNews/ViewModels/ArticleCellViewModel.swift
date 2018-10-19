//
//  ArticleCellViewModel.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/11/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import Foundation

struct ArticleCellViewModel {
    let title: String
    let name: String
    let score: Int
    let comments: Int
    let date: Date?
}

extension ArticleCellViewModel: CellViewModel {
    func setup(on cell: ArticleTableViewCell) {
        
        cell.configure(title: title,
                       name: "by \(name)",
                       score: "\(score)",
                       comments: "\(comments) comments",
                       timeAgo: date?.timeSinceNow ?? "")
    }
}
