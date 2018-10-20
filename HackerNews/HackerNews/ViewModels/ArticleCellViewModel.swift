//
//  ArticleCellViewModel.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/11/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import Foundation

struct ArticleCellViewModel {
    let article: Article
}

extension ArticleCellViewModel: CellViewModel {
    func setup(on cell: ArticleTableViewCell) {
        let commentDescripion = article.comments == 1 ? "comment" : "comments"
        cell.configure(title: article.title,
                       domain: article.url.domain,
                       name: "by \(article.author)",
                       score: "\(article.score)",
                       comments: "\(article.comments) \(commentDescripion)",
                       timeAgo: article.date?.timeSinceNow ?? "")
    }
}
