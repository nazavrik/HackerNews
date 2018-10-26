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

        _fetchComments(article.commentIds) { comments in
            var sortedComments = [Comment]()
            self.getComments(from: comments, to: &sortedComments)
            self.updateUI(with: sortedComments)
        }
    }
    
    private func getComments(from graph: [Comment], to comments: inout [Comment]) {
        for comment in graph {
            comments.append(comment)
            getComments(from: comment.subcomments, to: &comments)
        }
    }
    
    private func _fetchComments(_ commentIds: [Int], parent: Comment? = nil, complete: @escaping (([Comment]) -> Void)) {
        var comments = [Comment]()
        
        let commentsGroup = DispatchGroup()
        
        for commentId in commentIds {
            commentsGroup.enter()
            
            let request = Comment.Requests.comment(for: commentId)
            Server.standard.request(request) { comment, error in
                if var comment = comment {
                    let level = parent == nil ? 0 : parent!.level + 1
                    comment.level = level
                    comments.append(comment)
                }
                commentsGroup.leave()
            }
        }
        
        commentsGroup.notify(queue: DispatchQueue.main, execute: {
            comments = comments.sorted(by: { $0.id < $1.id })
            
            var result = [Comment]()
            
            let subcommentsGroup = DispatchGroup()
            
            for item in comments {
                subcommentsGroup.enter()
                if item.commentIds.count > 0 {
                    self._fetchComments(item.commentIds, parent: item, complete: { subcomments in
                        subcommentsGroup.leave()
                        var comment = item
                        comment.subcomments.append(contentsOf: subcomments)
                        result.append(comment)
                    })
                } else {
                    subcommentsGroup.leave()
                    result.append(item)
                }
            }
            
            subcommentsGroup.notify(queue: DispatchQueue.main, execute: {
                complete(result.sorted(by: { $0.id < $1.id }))
            })
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
    
    enum Section: Int {
        case info
        case comments
    }
    
    var numberOfSections: Int {
        return 2
    }
    
    func numberOfRows(in section: Int) -> Int {
        guard let sectinType = Section(rawValue: section) else { fatalError() }
        
        switch sectinType {
        case .info: return 1
        case .comments: return comments.count
        }
    }
    
    func model(for indexPath: IndexPath) -> BaseCellViewModel {
        guard let sectinType = Section(rawValue: indexPath.section) else { fatalError() }
        
        if sectinType == .info {
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
        guard let sectinType = Section(rawValue: section) else { fatalError() }
        
        if sectinType == .info {
            return nil
        }
        
        return HeaderCellViewModel(title: "Comments (\(article.commentsCount))")
    }
    
    func height(for indexPath: IndexPath) -> CGFloat {
        guard let sectinType = Section(rawValue: indexPath.section) else { fatalError() }
        
        if sectinType == .info {
            return 70.0
        }
        
        return UITableView.automaticDimension
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        guard let sectinType = Section(rawValue: section) else { fatalError() }
        
        if sectinType == .info {
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
        guard let sectinType = Section(rawValue: indexPath.section) else { fatalError() }
        
        if sectinType == .info {
            didOpeningUrlSelect?(article.url)
        }
    }
}
