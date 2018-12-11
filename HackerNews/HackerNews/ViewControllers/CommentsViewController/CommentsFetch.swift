//
//  CommentsFetch.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 11/3/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import Foundation

struct CommentsFetch {
    static func fetchComments(for articleId: Int, complete: @escaping ((Article?, [Comment], ServerError?) -> Void)) {
        let request = Article.Requests.article(for: articleId)
        Server.standard.request(request) { article, error in
            guard let article = article, error == nil else {
                complete(nil, [], error)
                return
            }
            
            _loadComments(article.commentIds) { comments in
                complete(article, comments, nil)
            }
        }
    }
    
    private static func _loadComments(_ commentIds: [Int], parent: Comment? = nil, complete: @escaping (([Comment]) -> Void)) {
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
}

struct CommentsFetchNew {
    private let server: ServerRequestProtocol
    
    init(server: ServerRequestProtocol = Server.standard) {
        self.server = server
    }
    
    func fetchCommentIds(with articleId: Int, complete: @escaping (([Int]?, ServerError?) -> Void)) {
        
        let request = Article.Requests.article(for: articleId)
        
        server.request(request) { article, error in
            guard let article = article, error == nil else {
                complete(nil, error)
                return
            }
            
            complete(article.commentIds, nil)
        }
    }
    
    func fetchComment(with commentId: Int, complete: @escaping ((Comment?, ServerError?) -> Void)) {
        
        let request = Comment.Requests.comment(for: commentId)
        server.request(request) { comment, error in
            guard let comment = comment, error == nil else {
                complete(nil, error)
                return
            }
            
            complete(comment, nil)
        }
    }
    
    func fetchComments(with articleId: Int, complete: @escaping ((Comment?, ServerError?) -> Void)) {
        fetchCommentIds(with: articleId) { commentIds, error in
            guard let commentIds = commentIds, error == nil else {
                complete(nil, error)
                return
            }

            if commentIds.isEmpty {
                complete(nil, nil)
                return
            }
                        
            let globalQueue = DispatchQueue.global(qos: .userInitiated)
            globalQueue.async {
                for commentId in commentIds {
                    let group = DispatchGroup()
                    group.enter()
                    self.fetchCommentAndSubcomments(with: commentId, complete: { comment, error in
                        complete(comment, error)
                        group.leave()
                    })
                    group.wait()
                }
            }
        }
    }
    
    func fetchCommentAndSubcomments(with commentId: Int, complete: @escaping ((Comment?, ServerError?) -> Void)) {
        fetchComment(with: commentId) { comment, error in
            guard var comment = comment, error == nil else {
                complete(nil, error)
                return
            }
            
            if comment.commentIds.isEmpty {
                complete(comment, nil)
                return
            }
            
            var subcomments = [Comment]()
            
            let group = DispatchGroup()
            
            for subcommentId in comment.commentIds {
                group.enter()
                self.fetchCommentAndSubcomments(with: subcommentId) { subcomment, error in
                    if let subcomment = subcomment {
                        subcomments.append(subcomment)
                    }
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                comment.subcomments = subcomments
                complete(comment, nil)
            }
        }
    }
}
