//
//  ArticlesDisplayData.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/11/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit

class ArticleListDisplayData {
    private weak var viewController: ArticleListViewController?
    
    var didArticleSelect: ((Article) -> Void)?
    
    var articles = [Article]()
    
    init(viewController: ArticleListViewController) {
        self.viewController = viewController
    }
    
    func fetchArticles(refresh: Bool) {
        if !refresh {
            viewController?.view.showLoader()
        }
        
        let request = Article.Requests.articleIds
        Server.standard.request(request) { [weak self] array, error in
            if let articleIds = array?.items {
                self?.fetchArticles(for: articleIds)
            }
        }
    }
    
    private func fetchArticles(for articleIds: [Int]) {
        var items = [Article]()
        let group = DispatchGroup()

        for articleId in articleIds {
            group.enter()
            
            let request = Article.Requests.article(for: articleId)
            Server.standard.request(request, completion: { article, error in
                if let article = article {
                    items.append(article)
                }
                group.leave()
            })
        }
        
        group.notify(queue: DispatchQueue.main, execute: {
            self.updateUI(with: items)
        })
    }
    
    private func updateUI(with items: [Article]) {
        articles.removeAll()
        articles.append(contentsOf: items)
        viewController?.view.hideLoader()
        viewController?.endRefreshing()
        viewController?.tableView.reloadData()
    }
}

extension ArticleListDisplayData: DisplayCollection {
    static var modelsForRegistration: [BaseCellViewModel.Type] {
        return [ArticleCellViewModel.self]
    }
    
    func numberOfRows(in section: Int) -> Int {
        return articles.count
    }
    
    func model(for indexPath: IndexPath) -> BaseCellViewModel {
        let article = articles[indexPath.row]
        return ArticleCellViewModel(title: article.title,
                                    name: article.author,
                                    score: article.score,
                                    comments: article.comments,
                                    date: article.date)
    }
    
    func height(for indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
}

extension ArticleListDisplayData: DisplayCollectionAction {
    func didSelect(indexPath: IndexPath) {
        let article = articles[indexPath.row]
        didArticleSelect?(article)
    }
}
