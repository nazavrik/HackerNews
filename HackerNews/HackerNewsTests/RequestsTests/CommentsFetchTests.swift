//
//  CommentsFetchTests.swift
//  HackerNewsTests
//
//  Created by Alexander Nazarov on 12/8/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import XCTest
@testable import HackerNews

class CommentsFetchTests: XCTestCase {
    
    var sutArticle: CommentsFetch!
    var mockServerForArticle: MockServer<Article>!
    
    var sutComment: CommentsFetch!
    var mockServerForComment: MockServer<Comment>!
    
    var sutComments: CommentsFetch!
    
    override func setUp() {
        mockServerForArticle = MockServer<Article>()
        sutArticle = CommentsFetch(server: mockServerForArticle)
        
        mockServerForComment = MockServer<Comment>()
        sutComment = CommentsFetch(server: mockServerForComment)
        
        sutComments = CommentsFetch()
    }

    override func tearDown() {}

    // MARK: Fetch comment ids by article id
    
    func testCommentIds_ShouldFetchCommentIdsByArticleId() {
        mockServerForArticle.data = article
        
        var commentIds: [Int]?
        
        let articleId = 1
        sutArticle.fetchCommentIds(with: articleId) { ids, error in
            commentIds = ids
        }
        
        XCTAssertNotNil(commentIds)
    }

    func testCommentIds_ShouldReturnNilIfArticleIsNil() {
        mockServerForArticle.data = nil
        
        var commentIds: [Int]?
        
        let articleId = 1
        sutArticle.fetchCommentIds(with: articleId) { ids, error in
            commentIds = ids
        }
        
        XCTAssertNil(commentIds)
    }
    
    func testCommentIds_ShouldReturnErrorIfError() {
        mockServerForArticle.data = article
        mockServerForArticle.error = error
        
        var errorResult: ServerError?
        
        let articleId = 1
        sutArticle.fetchCommentIds(with: articleId) { ids, error in
            errorResult = error
        }
        
        XCTAssertNotNil(errorResult)
    }
    
    // MARK: fetch comment by comment id
    
    func testComment_ShouldReturnCommentByCommentId() {
        mockServerForComment.data = comment
        
        var commentResult: Comment?
        
        let commentId = 1
        sutComment.fetchComment(with: commentId) { comment, error in
            commentResult = comment
        }
        
        XCTAssertNotNil(commentResult)
    }
    
    func testComment_ShouldReturnNilIfCommentIsNil() {
        mockServerForComment.data = nil
        
        var commentResult: Comment?
        
        let commentId = 1
        sutComment.fetchComment(with: commentId) { comment, error in
            commentResult = comment
        }
        
        XCTAssertNil(commentResult)
    }
    
    func testComment_ShouldReturnErrorIfError() {
        mockServerForComment.data = comment
        mockServerForComment.error = error
        
        var errorResult: ServerError?
        
        let commentId = 1
        sutComment.fetchComment(with: commentId) { comment, error in
            errorResult = error
        }
        
        XCTAssertNotNil(errorResult)
    }
    
    private var article: Article? {
        let articleJSON: [String: Any?] = [
            "by": "xylon",
            "descendants": 402,
            "id": 18640136,
            "kids": [2, 3, 4],
            "score": 408,
            "time": TimeInterval(1544349883),
            "title": "Title",
            "type": "story",
            "url": "url"
        ]
        
        return Article(json: articleJSON)
    }
    
    private var comment: Comment? {
        let commentJSON: JSONDictionary = [
            "by": "slededit",
            "id": 1,
            "kids": [2, 3, 4],
            "parent": 18633448,
            "text": "text",
            "time": TimeInterval(1544241893),
            "type": "comment"
        ]
        
        return Comment(json: commentJSON)
    }
    
    private var error: ServerError? {
        return ServerError(data: "{\"errors\": [\"Something is wrong\"]}")
    }
}

extension CommentsFetchTests {
    class MockServer<U>: ServerRequestProtocol {
        
        var completion: ((U?, ServerError?) -> Void)?

        var data: U?
        var error: ServerError?
        
        func request<T: ObjectType>(_ request: Request<T>, completion: @escaping ((T?, ServerError?) -> Void)) {
            let data = self.data as? T
            let completionClosure = completion as? ((U?, ServerError?) -> Void)
            
            self.completion = completionClosure
            completion(data, error)
        }
    }
}
