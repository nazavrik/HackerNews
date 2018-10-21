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
    private var comments = [Comment]()
    
    var didOpeningUrlSelect: ((String) -> Void)?
    
    init(viewController: ArticleViewController, article: Article) {
        self.viewController = viewController
        self.article = article
    }
    
    func fetchComments() {
        comments.removeAll()
        viewController?.tableView.reloadData()
        
        viewController?.view.showLoader()
        
        var items = [Int: Comment]()
        
        let group = DispatchGroup()
        
        for commentId in article.commentIds {
            group.enter()
            
            let request = Comment.Requests.comment(for: commentId)
            Server.standard.request(request) { comment, error in
                if let comment = comment {
                    items[comment.id] = comment
                }
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main, execute: {
            
            var sortedItems = [Comment]()
            
            for commentId in self.article.commentIds {
                if let item = items[commentId] {
                    sortedItems.append(item)
                }
            }
            
            self.updateUI(with: sortedItems)
        })
    }
    
    private func updateUI(with items: [Comment]) {
        comments.removeAll()
        comments.append(contentsOf: items)
        viewController?.view.hideLoader()
        viewController?.tableView.reloadData()
    }
}

extension ArticleDisplayData: DisplayCollection {
    static var modelsForRegistration: [BaseCellViewModel.Type] {
        return [ArticleCellViewModel.self,
                HeaderCellViewModel.self,
                CommentCellViewModel.self]
    }
    
    var numberOfSections: Int {
        return 2
    }
    
    func numberOfRows(in section: Int) -> Int {
        return section == 0 ? 1 : comments.count
    }
    
    func model(for indexPath: IndexPath) -> BaseCellViewModel {
        if indexPath.section == 0 {
            return ArticleCellViewModel(article: article)
        }
        
        let comment = comments[indexPath.row]
        var model = CommentCellViewModel(comment: comment)
        model.didCommentSelect = { urls in
            self.showURLActions(for: urls)
        }
        return model
    }
    
    func header(for section: Int) -> BaseCellViewModel? {
        if section == 0 {
            return nil
        }
        
        return HeaderCellViewModel(title: "Comments (\(article.commentsCount))")
    }
    
    func height(for indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 70.0
        }
        return UITableView.automaticDimension
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        if section == 0 {
            return 0.0
        }
        return 44.0
    }
    
    private func showURLActions(for urls: [String]) {
        guard !urls.isEmpty else { return }
        
        let alertController = UIAlertController(title: "Open URL", message: nil, preferredStyle: .actionSheet)
        
        for urlString in urls {
            guard let _ = URL(string: urlString) else { continue }
            
            let action = UIAlertAction(title: urlString, style: .default) { success in
                self.didOpeningUrlSelect?(urlString)
            }
            
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        viewController?.navigationController?.present(alertController, animated: true, completion: nil)
    }
}

extension ArticleDisplayData: DisplayCollectionAction {
    func didSelect(indexPath: IndexPath) {
        if indexPath.section == 0 {
            didOpeningUrlSelect?(article.url)
        }
    }
}
