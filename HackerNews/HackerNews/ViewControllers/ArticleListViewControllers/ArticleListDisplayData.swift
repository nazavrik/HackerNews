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
    private let itemsOnPerPage = 20
    private var allArticleIds: [Int]?
    private var articles = [Article]()
    private var loadedItemsCount = 0
    
    var didArticleSelect: ((Article) -> Void)?
    
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
                self?.loadedItemsCount = 0
                self?.allArticleIds = articleIds
                self?.fetchArticles(for: self?.nextArticleIds ?? [])
            }
        }
    }
    
    private func fetchArticles(for articleIds: [Int]) {
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
            self.updateUI(with: items)
        })
    }
    
    private func updateUI(with items: [Article]) {
        if loadedItemsCount == 0 {
            articles.removeAll()
        }
        
        articles.append(contentsOf: items)
        loadedItemsCount += itemsOnPerPage
        
        viewController?.view.hideLoader()
        viewController?.endRefreshing()
        viewController?.tableView.reloadData()
    }
    
    private var nextArticleIds: [Int] {
        guard hasMoreArticles else { return [] }
        guard let articleIds = allArticleIds else { return [] }
        
        let startIndex = loadedItemsCount
        let offset = articleIds.count - loadedItemsCount < itemsOnPerPage ? articleIds.count - loadedItemsCount : itemsOnPerPage
        let endIndex = startIndex + offset
        var items = [Int]()
        items.append(contentsOf: articleIds[startIndex..<endIndex])
        
        return items
    }
    
    private var hasMoreArticles: Bool {
        guard let articleIds = allArticleIds,
            !articleIds.isEmpty else {
                return false
        }
        
        return loadedItemsCount < articleIds.count - 1
    }
}

extension ArticleListDisplayData: DisplayCollection {
    static var modelsForRegistration: [BaseCellViewModel.Type] {
        return [ArticleCellViewModel.self,
                LoaderCellViewModel.self]
    }
    
    func numberOfRows(in section: Int) -> Int {
        var rows = articles.count
        
        if !articles.isEmpty && hasMoreArticles {
            rows += 1
        }
        
        return rows
    }
    
    func model(for indexPath: IndexPath) -> BaseCellViewModel {
        if isLoaderCell(indexPath) {
            return LoaderCellViewModel()
        }
        
        let article = articles[indexPath.row]
        return ArticleCellViewModel(article: article)
    }
    
    func height(for indexPath: IndexPath) -> CGFloat {
        if isLoaderCell(indexPath) {
            return 44.0
        }
        return 65.0
    }
    
    private func isLoaderCell(_ indexPath: IndexPath) -> Bool {
        return indexPath.row == articles.count
    }
}

extension ArticleListDisplayData: DisplayCollectionAction {
    func didSelect(indexPath: IndexPath) {
        if isLoaderCell(indexPath) {
            fetchArticles(for: nextArticleIds)
            return
        }
        let article = articles[indexPath.row]
        didArticleSelect?(article)
    }
}
