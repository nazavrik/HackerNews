//
//  ArticleDisplayData.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/19/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit

class ArticleDisplayData {
    private weak var viewController: ArticleViewController?
    private var article: Article
    private var comments = [String]()
    
    var didOpeningUrlSelect: ((String) -> Void)?
    
    init(viewController: ArticleViewController, article: Article) {
        self.viewController = viewController
        self.article = article
    }
}

extension ArticleDisplayData: DisplayCollection {
    static var modelsForRegistration: [BaseCellViewModel.Type] {
        return [ArticleCellViewModel.self]
    }
    
    var numberOfSections: Int {
        return 2
    }
    
    func numberOfRows(in section: Int) -> Int {
        return section == 0 ? 1 : comments.count
    }
    
    func model(for indexPath: IndexPath) -> BaseCellViewModel {
        if indexPath.section == 0 {
            return ArticleCellViewModel(title: article.title,
                                        name: article.author,
                                        score: article.score,
                                        comments: article.comments,
                                        date: article.date)
        }
        
        return ArticleCellViewModel(title: "article.title",
                                    name: "article.author",
                                    score: 0,
                                    comments: 0,
                                    date: nil)
    }
    
    func height(for indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 70.0
        }
        return 100.0
    }
}

extension ArticleDisplayData: DisplayCollectionAction {
    func didSelect(indexPath: IndexPath) {
        didOpeningUrlSelect?(article.url)
    }
}
