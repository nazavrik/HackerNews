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
    private var tableView: UITableView? {
        return viewController?.tableView
    }
    private var isRefreshing = false {
        didSet {
            if isRefreshing {
                tableView?.showLoader(type: .glider)
                resetContainers()
                tableView?.reloadData()
            } else {
                tableView?.hideLoader()
            }
            
            loadingCommentId = nil
            tableView?.tableFooterView = nil
        }
    }
    private var comments = [Comment]()
    private var commentTexts = [NSAttributedString?]()
    private var unloadArticleIds = Queue<Int>()
    private var loadingCommentId: Int?
    private var cellHeights = [CGFloat]()
    private var server: Server = {
        let server = Server.standard
        server.returnCompletionBlockInMainThread = false
        return server
    }()
    var commentHeaderHeight: CGFloat = 94.0
    
    var article: Article
    var didOpeningUrlSelect: ((String) -> Void)?
    var didArticleSelect: (() -> Void)?
    
    init(viewController: CommentsViewController, article: Article) {
        self.viewController = viewController
        self.article = article
    }
    
    func fetchComments() {
        isRefreshing = true
        
        CommentsFetch().fetchCommentIds(with: article.id) { [weak self] commentIds, error in
            guard let commentIds = commentIds, error == nil else {
                self?.isRefreshing = false
                self?.viewController?.showAlert(title: "Can't fetch comments",
                                                message: "Reason: \(error?.description ?? "")")
                return
            }
            
            if commentIds.isEmpty {
                self?.isRefreshing = false
                return
            }

            self?.unloadArticleIds.enqueue(commentIds)
            self?.fetchNextCommentAndSubcomments()
        }
    }
    
    private func fetchNextCommentAndSubcomments() {
        guard
            let commentId = unloadArticleIds.dequeue(),
            loadingCommentId == nil
            else { return }
        
        loadingCommentId = commentId
        
        let width = self.width
        
        CommentsFetch(server: server).fetchCommentAndSubcomments(with: commentId, complete: { [weak self] comment, error in
            guard var comment = comment else { return }
            
            if comment.deleted {
                self?.loadingCommentId = nil
                self?.fetchNextCommentAndSubcomments()
                return
            }
            
            comment.level = 0
            var sortedComments = [comment]
            self?.getComments(from: (comment.subcomments, 1), to: &sortedComments)
            
            var indexPaths = [IndexPath]()
            var row = self?.comments.count ?? 0
            
            sortedComments.forEach({ comment in
                if comment.deleted { return }
                
                let (height, attributedText) = CommentCellViewModel.height(for: comment, width: width)
                self?.cellHeights.append(height)
                self?.commentTexts.append(attributedText)
                self?.comments.append(comment)
                
                let indexPath = IndexPath(row: row, section: Section.comments.rawValue)
                indexPaths.append(indexPath)
                row += 1
            })
            
            DispatchQueue.main.async {
                self?.isRefreshing = false
                
                self?.tableView?.insertRows(at: indexPaths, with: .automatic)
            }
        })
    }
    
    private var width: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    private func getComments(from tuple: (graph: [Comment], level: Int), to comments: inout [Comment]) {
        for var comment in tuple.graph {
            comment.level = tuple.level
            comments.append(comment)
            getComments(from: (comment.subcomments, tuple.level + 1), to: &comments)
        }
    }
    
    private func resetContainers() {
        comments.removeAll()
        cellHeights.removeAll()
        commentTexts.removeAll()
        unloadArticleIds.removeAll()
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
        let attributedText = commentTexts[indexPath.row]
        var model = CommentCellViewModel(comment: comment, attributedText: attributedText)
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
        
        let title = article.commentsCount > 0 ? "Comments (\(article.commentsCount))" : "No comments yet"
        
        return HeaderCellViewModel(title: title)
    }
    
    func height(for indexPath: IndexPath) -> CGFloat {
        guard let sectinType = Section(rawValue: indexPath.section) else { fatalError() }
        
        if sectinType == .info {
            return commentHeaderHeight
        }
        
        return cellHeights[indexPath.row]
    }
    
    func estimatedHeight(for indexPath: IndexPath) -> CGFloat {
        return height(for: indexPath)
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
    
    func willDisplay(_ cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let sectinType = Section(rawValue: indexPath.section) else { fatalError() }
        
        let isLastRow = sectinType == .comments && indexPath.row == comments.count - 1
        
        if isLastRow && !unloadArticleIds.isEmpty {
            addLoadingFooterView()
            fetchNextCommentAndSubcomments()
        }
    }
    
    private func addLoadingFooterView() {
        let view = UIView()
        view.frame = CGRect(x: 0.0, y: 0.0, width: width, height: 44.0)
        view.showLoader(type: .activity)
        tableView?.tableFooterView = view
    }
}

extension CommentsDisplayData: DisplayCollectionAction {
    func didSelect(indexPath: IndexPath) {
        guard let sectinType = Section(rawValue: indexPath.section) else { fatalError() }
        
        if sectinType == .info {
            didArticleSelect?()
        }
    }
}
