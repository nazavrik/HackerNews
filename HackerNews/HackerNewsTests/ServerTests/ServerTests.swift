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

    func getRequest(for query: String) -> Request<ArrayObject<Int>> {
        return Request(query: query)
    }
    
    override func setUp() {
        mockURLSession = MockURLSession()
        sut = Server(session: mockURLSession, apiBase: apiBase)
    }

    override func tearDown() {}

    func testServer_Settings() {
        XCTAssertEqual(sut.apiBase, apiBase)
    }
    
    func testServer_makeGetRequest() {
        let request = getRequest(for: "test")
        
        sut.request(request) { _, _ in }
        
        XCTAssertNotNil(mockURLSession.completionHandler)
        XCTAssertTrue(mockURLSession.dataTask.resumeGotCalled)
        
        guard let mockRequest = mockURLSession.request,
            let url = mockRequest.url else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(url.host, "example.com")
        XCTAssertEqual(url.path, "/test")
        
        XCTAssertEqual(mockRequest.httpMethod, "GET")
    }
    
    func testServer_makePostRequest() {
        let parameters = [
            "parameter_one": "One",
            "parameter_two": "Two"
        ]
        
        let headers = [
            "header_one": "One",
            "header_two": "Two"
        ]
        
        let request = Request<ArrayObject<Int>>(query: "test", method: .post, parameters: parameters, headers: headers)
        
        sut.request(request) { _, _ in }
        
        XCTAssertNotNil(mockURLSession.completionHandler)
        XCTAssertTrue(mockURLSession.dataTask.resumeGotCalled)
        
        guard let mockRequest = mockURLSession.request else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(mockRequest.httpMethod, "POST")
        
        let data = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        XCTAssertEqual(mockRequest.httpBody, data)
        
        XCTAssertNotNil(mockRequest.allHTTPHeaderFields?["header_one"])
        XCTAssertEqual(mockRequest.allHTTPHeaderFields?["header_one"], "One")
        
        XCTAssertNotNil(mockRequest.allHTTPHeaderFields?["header_two"])
        XCTAssertEqual(mockRequest.allHTTPHeaderFields?["header_two"], "Two")
    }
    
    func testServer_ThrowErrorWrongURL() {
        let sut = Server(session: mockURLSession, apiBase: "")
        let request = getRequest(for: "")
        var urlError: ServerError?
        
        sut.request(request) { _, error in
            urlError = error
        }
        
        XCTAssertNotNil(urlError)
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
