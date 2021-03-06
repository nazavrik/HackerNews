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
    private var allArticleIds: [Int]?
    private var articles = [Article]()
    private var contents = [Int: String?]()
    private var loadedItemsCount = 0
    
    var storyType: HNStoryType {
        set {
            if storyType != newValue {
                UserDefaults.standard.set(newValue.rawValue, forKey: "SelectedStoryType")
                changeArticles()
            }
        }
        get {
            let rawValue = UserDefaults.standard.integer(forKey: "SelectedStoryType")
            return HNStoryType(rawValue: rawValue) ?? .best
        }
    }
    
    var didArticleSelect: ((Article) -> Void)?
    
    init(viewController: ArticleListViewController) {
        self.viewController = viewController
    }
    
    func fetchArticles(refresh: Bool) {
        if !refresh {
            viewController?.tableView.isUserInteractionEnabled = false
            viewController?.tableView.showLoader(type: .glider)
        }
        
        let storyType = self.storyType
        
        ArticleListFetch.fetchFirstArticles(for: storyType) { [weak self] ids, articles, error in
            guard error == nil else {
                self?.viewController?.showAlert(title: "Can't fetch stories",
                                                message: "Reason: \(error?.description ?? "")")
                self?.updateUI(with: [])
                return
            }
            
            if storyType == self?.storyType {
                self?.loadedItemsCount = 0
                self?.allArticleIds = ids
                self?.updateUI(with: articles)
                self?.fetchContent(for: articles)
            }
        }
    }
    
    private func fetchMoreArticles() {
        ArticleListFetch.fetchArticles(for: nextArticleIds) { [weak self] articles in
            self?.updateUI(with: articles)
            self?.fetchContent(for: articles)
        }
    }
    
    private func fetchContent(for articles: [Article]) {
        guard MercuryWebService.isAvailable else { return }
        
        for article in articles {
            MercuryWebService.fetchContent(for: article.url, complete: { content in
                self.contents[article.id] = content
            })
        }
    }
    
    private func updateUI(with items: [Article]) {
        if loadedItemsCount == 0 {
            articles.removeAll()
        }
        
        articles.append(contentsOf: items)
        loadedItemsCount += ArticleListFetch.itemsOnPerPage
        
        viewController?.tableView.isUserInteractionEnabled = true
        viewController?.tableView.hideLoader()
        viewController?.endRefreshing()
        viewController?.tableView.reloadData()
    }
    
    private var nextArticleIds: [Int] {
        guard hasMoreArticles else { return [] }
        guard let articleIds = allArticleIds else { return [] }
        
        let startIndex = loadedItemsCount
        let offset = articleIds.count - loadedItemsCount < ArticleListFetch.itemsOnPerPage ? articleIds.count - loadedItemsCount : ArticleListFetch.itemsOnPerPage
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
    
    private func changeArticles() {
        allArticleIds?.removeAll()
        articles.removeAll()
        viewController?.tableView.reloadData()
        
        fetchArticles(refresh: false)
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
    
    func estimatedHeight(for indexPath: IndexPath) -> CGFloat {
        return height(for: indexPath)
    }
    
    private func isLoaderCell(_ indexPath: IndexPath) -> Bool {
        return indexPath.row == articles.count
    }
}

extension ArticleListDisplayData: DisplayCollectionAction {
    func didSelect(indexPath: IndexPath) {
        if isLoaderCell(indexPath) {
            guard let cell = viewController?.tableView.cellForRow(at: indexPath) as? LoaderTableViewCell else {
                return
            }
            
            if cell.isAnimating {
                return
            }
            
            cell.startLoaderAnimation()
            fetchMoreArticles()
        } else {
            var article = articles[indexPath.row]
            article.content = contents[article.id] as? String
            didArticleSelect?(article)
        }
    }
}
