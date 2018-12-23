//
//  CommentsFetch.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 11/3/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import Foundation

struct CommentsFetch {
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
