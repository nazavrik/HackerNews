//
//  CommentsDisplayData.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/19/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit

class CommentsDisplayData {
    private weak var viewController: CommentsViewController?
    private var article: Article
    private var comments = [Comment]()
    
    var didOpeningUrlSelect: ((String) -> Void)?
    var didArticleSelect: (() -> Void)?
    
    init(viewController: CommentsViewController, article: Article) {
        self.viewController = viewController
        self.article = article
    }
    
    func fetchComments() {
        comments.removeAll()
        viewController?.tableView.reloadData()
        
        viewController?.view.showLoader()

        let articleRequest = Article.Requests.article(for: article.id)
        Server.standard.request(articleRequest) { [weak self] updatedArticle, error in
            guard let updatedArticle = updatedArticle else { return }
            
            self?.loadComments(for: updatedArticle)
        }
    }
    
    private func loadComments(for article: Article) {
        _loadComments(article.commentIds) { comments in
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
    
    private func _loadComments(_ commentIds: [Int], parent: Comment? = nil, complete: @escaping (([Comment]) -> Void)) {
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
                    self._loadComments(item.commentIds, parent: item, complete: { subcomments in
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

extension CommentsDisplayData: DisplayCollection {
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
//        model.didReplyingSelect = { cell in
//            let text = cell.replyButton.titleLabel?.text ?? ""
//            if text.hasPrefix("Show") {
//                cell.replyButton.setTitle("Hide replies", for: .normal)
//                self.showSubcomments(for: cell, comment: comment)
//            } else {
//                cell.replyButton.setTitle("Show replies (\(comment.commentIds.count))", for: .normal)
//                self.hideSubcomments(for: cell, comment: comment)
//            }
//        }
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
    
//    private func showSubcomments(for cell: CommentTableViewCell, comment: Comment) {
//        guard !comment.commentIds.isEmpty,
//            let tableView = viewController?.tableView else { return }
//
//        _fetchComments(comment.commentIds) { comments in
//            let actualComments = comments.filter({ !$0.deleted })
//
//            self.subcomments[comment.id] = actualComments
//
//            let items = actualComments.compactMap({ element -> Comment in
//                var item = element
//                item.level = comment.level + 1
//                return item
//            })
//
//            tableView.performBatchUpdates({
//                if let indexPath = tableView.indexPath(for: cell) {
//                    self.comments.insert(contentsOf: items, at: indexPath.row + 1)
//                    var indexPaths = [IndexPath]()
//                    var index = indexPath.row + 1
//
//                    comments.forEach({ comment in
//                        indexPaths.append(IndexPath(row: index, section: 1))
//                        index += 1
//                    })
//
//                    tableView.insertRows(at: indexPaths, with: .automatic)
//                }
//            }, completion: { success in
//
//            })
//        }
//    }
//
//    private func hideSubcomments(for cell: CommentTableViewCell, comment: Comment) {
//        guard !comment.commentIds.isEmpty,
//            let tableView = viewController?.tableView else { return }
//
//        tableView.performBatchUpdates({
//            if let indexPath = tableView.indexPath(for: cell) {
//                let comments = self.subcomments[comment.id] ?? []
//                let commentIds = comments.map({ comment -> Int in
//                    return comment.id
//                })
//
//                self.comments.removeAll(where: {
//                    commentIds.contains($0.id)
//                })
//
//                var indexPaths = [IndexPath]()
//                var index = indexPath.row + 1
//
//                commentIds.forEach({ _ in
//                    indexPaths.append(IndexPath(row: index, section: 1))
//                    index += 1
//                })
//
//                tableView.deleteRows(at: indexPaths, with: .automatic)
//            }
//        }, completion: { success in
//
//        })
//    }
}

extension CommentsDisplayData: DisplayCollectionAction {
    func didSelect(indexPath: IndexPath) {
        guard let sectinType = Section(rawValue: indexPath.section) else { fatalError() }
        
        if sectinType == .info {
            didArticleSelect?()
        }
    }
}
