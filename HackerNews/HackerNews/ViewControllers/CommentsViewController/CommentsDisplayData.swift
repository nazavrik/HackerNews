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
    private var isRefreshing = false {
        didSet {
            viewController?.tableView.reloadData()
        }
    }
    private var comments = [Comment]()
    
    var article: Article
    var didOpeningUrlSelect: ((String) -> Void)?
    var didArticleSelect: (() -> Void)?
    var commentHeaderHeight: CGFloat = 94.0
    
    init(viewController: CommentsViewController, article: Article) {
        self.viewController = viewController
        self.article = article
    }
    
    func fetchComments() {
        isRefreshing = true
        viewController?.tableView.isUserInteractionEnabled = false
        viewController?.tableView.showLoader(type: .glider)

        CommentsFetch.fetchComments(for: article.id) { [weak self] article, comments, error in
            guard let article = article, error == nil else {
                self?.viewController?.showAlert(title: "Can't fetch comments",
                                                message: "Reason: \(error?.description ?? "")")
                self?.updateUI()
                return
            }
            
            self?.article = article
            
            var sortedComments = [Comment]()
            self?.getComments(from: comments, to: &sortedComments)
            self?.comments.removeAll()
            self?.comments.append(contentsOf: sortedComments)
            self?.updateUI()
        }
    }
    
    private func getComments(from graph: [Comment], to comments: inout [Comment]) {
        for comment in graph {
            comments.append(comment)
            getComments(from: comment.subcomments, to: &comments)
        }
    }
    
    private func updateUI() {
        isRefreshing = false
        viewController?.tableView.isUserInteractionEnabled = true
        viewController?.tableView.hideLoader()
    }
}

extension CommentsDisplayData: DisplayCollection {
    static var modelsForRegistration: [BaseCellViewModel.Type] {
        return [CommentHeaderCellViewModel.self,
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
        case .comments: return isRefreshing ? 0 : comments.count
        }
    }
    
    func model(for indexPath: IndexPath) -> BaseCellViewModel {
        guard let sectinType = Section(rawValue: indexPath.section) else { fatalError() }
        
        if sectinType == .info {
            return CommentHeaderCellViewModel(article: article)
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
        
        let title = article.commentsCount > 0 ? "Comments (\(article.commentsCount))" : "No comments yet"
        
        return HeaderCellViewModel(title: title)
    }
    
    func height(for indexPath: IndexPath) -> CGFloat {
        guard let sectinType = Section(rawValue: indexPath.section) else { fatalError() }
        
        if sectinType == .info {
            return commentHeaderHeight
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
