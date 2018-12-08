//
//  ServerTests.swift
//  HackerNewsTests
//
//  Created by Alexander Nazarov on 12/6/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import XCTest
@testable import HackerNews


class ServerTests: XCTestCase {
    private let apiBase = "https://example.com/"
    
    var sut: Server!
    var mockURLSession: MockURLSession!
    
    override func setUp() {
        mockURLSession = MockURLSession()
        sut = Server(session: mockURLSession, apiBase: apiBase)
    }

    override func tearDown() {}

    func testServer_ApiBaseShouldBeAssigned() {
        XCTAssertEqual(sut.apiBase, apiBase)
    }
    
    func testServer_ShouldSendRequest() {
        sendGetRequest()
        XCTAssertNotNil(mockURLSession.completionHandler)
    }
    
    func testServer_SessionDataTaskShouldCallResume() {
        sendGetRequest()
        XCTAssertTrue(mockURLSession.dataTask.resumeGotCalled)
    }
    
    func testServer_URLRequestShouldHaveURLHost() {
        sendGetRequest()
        
        guard let url = mockURLSession.request?.url else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(url.host, "example.com")
    }
    
    func testServer_URLRequestShouldHaveURLPath() {
        sendGetRequest("somequery")
        
        guard let url = mockURLSession.request?.url else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(url.path, "/somequery")
    }
    
    func testRequest_GetRequestShouldHaveGetMethod() {
        sendGetRequest()
        
        guard let mockRequest = mockURLSession.request else {
                XCTFail()
                return
        }
        
        XCTAssertEqual(mockRequest.httpMethod, "GET")
    }
    
    func testServer_PostRequestShouldHavePostMethod() {
        let request = Request<ArrayObject<Int>>(query: "somequery", method: .post)
        sut.request(request) { _, _ in }
        
        guard let mockRequest = mockURLSession.request else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(mockRequest.httpMethod, "POST")
    }
    
    func testServer_PostRequestShouldHaveHttpBody() {
        let parameters = [
            "parameter_one": "One",
            "parameter_two": "Two"
        ]
        
        let request = Request<ArrayObject<Int>>(query: "somequery", method: .post, parameters: parameters)
        sut.request(request) { _, _ in }
        
        guard let mockRequest = mockURLSession.request else {
            XCTFail()
            return
        }
        
        let data = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        XCTAssertEqual(mockRequest.httpBody, data)
    }
    
    func testServer_RequestShouldHaveHeaders() {
        let headers = [
            "header_one": "One",
            "header_two": "Two"
        ]
        
        let request = Request<ArrayObject<Int>>(query: "test", method: .post, headers: headers)
        sut.request(request) { _, _ in }
        
        guard let mockRequest = mockURLSession.request else {
            XCTFail()
            return
        }
        
        XCTAssertNotNil(mockRequest.allHTTPHeaderFields?["header_one"])
        XCTAssertEqual(mockRequest.allHTTPHeaderFields?["header_one"], "One")
        
        XCTAssertNotNil(mockRequest.allHTTPHeaderFields?["header_two"])
        XCTAssertEqual(mockRequest.allHTTPHeaderFields?["header_two"], "Two")
    }
    
    func testServer_ThrowErrorWrongURL() {
        let sut = Server(session: mockURLSession, apiBase: "")
        let request = Request<ArrayObject<Int>>(query: "")
        var urlError: ServerError?
        
        sut.request(request) { _, error in
            urlError = error
        }
        
        XCTAssertNotNil(urlError)
    }
    
    private func sendGetRequest(_ query: String = "test") {
        let request = Request<ArrayObject<Int>>(query: query)
        sut.request(request) { _, _ in }
    }
}

extension ServerTests {
    class MockURLSession: URLSessionDataTaskProtocol {
        typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
        
        var completionHandler: CompletionHandler?
        var request: URLRequest?
        var dataTask = MockURLSessionDataTask()
        
        func dataTask(with request: URLRequest, completionHandler: @escaping CompletionHandler) -> URLSessionDataTask {
            self.completionHandler = completionHandler
            self.request = request
            return dataTask
        }
    }
    
    class MockURLSessionDataTask: URLSessionDataTask {
        var resumeGotCalled = false
        
        override func resume() {
            resumeGotCalled = true
        }
    }
}
