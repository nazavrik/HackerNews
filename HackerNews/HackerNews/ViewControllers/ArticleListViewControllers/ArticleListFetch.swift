//
//  ArticleListFetch.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 11/4/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import Foundation

struct ArticleListFetch {
    static let itemsOnPerPage = 20
    
    static func fetchFirstArticles(_ complete: @escaping (([Int], [Article], ServerError?) -> Void)) {
        
        let request = Article.Requests.articleIds
        Server.standard.request(request) { array, error in
            guard let articleIds = array?.items, error == nil else {
                complete([], [], error)
                return
            }
            
            let endIndex = articleIds.count < itemsOnPerPage ? articleIds.count : itemsOnPerPage
            var firstArticleIds = [Int]()
            firstArticleIds.append(contentsOf: articleIds[0..<endIndex])
            
            fetchArticles(for: firstArticleIds, complete: { articles in
                complete(articleIds, articles, nil)
            })
        }
    }
    
    static func fetchArticles(for articleIds: [Int], complete: @escaping (([Article]) -> Void)) {
        var items = [Article]()
        let group = DispatchGroup()
        
        for id in articleIds {
            group.enter()
            
            let request = Article.Requests.article(for: id)
            Server.standard.request(request, completion: { article, error in
                if let article = article {
                    items.append(article)
                }
                group.leave()
            })
        }
        
        group.notify(queue: DispatchQueue.main, execute: {
            complete(items)
        })
    }
}
