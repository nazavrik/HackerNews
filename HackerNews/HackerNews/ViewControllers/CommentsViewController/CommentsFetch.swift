//
//  CommentsFetch.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 11/3/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import Foundation

struct CommentsFetch {
    static func fetchComments(for articleId: Int, complete: @escaping (([Comment]) -> Void)) {
        let request = Article.Requests.article(for: articleId)
        Server.standard.request(request) { article, error in
            guard let article = article else { return }
            
            _loadComments(article.commentIds) { comments in
                complete(comments)
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
