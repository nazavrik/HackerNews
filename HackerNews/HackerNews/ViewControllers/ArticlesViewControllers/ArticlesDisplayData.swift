//
//  ArticlesDisplayData.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/11/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit

class ArticlesDisplayData {
    fileprivate weak var viewController: ArticlesViewController?
    
    var articles = [Article]()
    
    init(viewController: ArticlesViewController) {
        self.viewController = viewController
    }
    
    func add(article: Article) {
        articles.append(article)
        viewController?.tableView.reloadData()
    }
}

extension ArticlesDisplayData: DisplayCollection {
    static var modelsForRegistration: [BaseCellViewModel.Type] {
        return [ArticleCellViewModel.self]
    }
    
    func numberOfRows(in section: Int) -> Int {
        return articles.count
    }
    
    func model(for indexPath: IndexPath) -> BaseCellViewModel {
        let article = articles[indexPath.row]
        return ArticleCellViewModel(title: "\(article.title)", name: "\(article.url)")
    }
    
    func height(for indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
}
