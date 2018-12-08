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
    
    func testServer_ShouldReceiveData() {
        mockURLSession.responseData = "[1,2,3]".data(using: .utf8)
        mockURLSession.responseType = .success
        var receiveData: ArrayObject<Int>?
        let exp = expectation(description: "Wait for data")
        
        let request = Request<ArrayObject<Int>>(query: "")
        sut.request(request) { data, error in
            receiveData = data
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertNotNil(receiveData)
    }
    
    func testServer_ShouldThrowErrorEmptyResponse() {
        let error = sendRequestWithError()
        
        XCTAssertNotNil(error)
        XCTAssertEqual(error?.description, ServerError.emptyResponse.description)
    }
    
    func testServer_ShouldThrowErrorRequestFailed() {
        mockURLSession.responseData = "[1,2,3]".data(using: .utf8)
        mockURLSession.responseType = .nil
        
        let error = sendRequestWithError()
        
        XCTAssertNotNil(error)
        XCTAssertEqual(error?.description, ServerError.requestFailed.description)
    }
    
    func testServer_ShouldThrowClientError() {
        mockURLSession.responseData = "{\"errors\": [\"not found\"]}".data(using: .utf8)
        mockURLSession.responseType = .failed
        
        let error = sendRequestWithError()
        
        XCTAssertNotNil(error)
        XCTAssertEqual(error?.description, "not found")
    }
    
    func testServer_ShouldThrowServerError() {
        mockURLSession.responseError = NSError(domain: "Internal Server Error", code: 500, userInfo: nil)
        mockURLSession.responseType = .success
        
        let error = sendRequestWithError()
        
        XCTAssertNotNil(error)
        XCTAssertEqual(error?.description, ServerError.requestFailed.description)
    }
    
    func testServer_ShouldThrowErrorWrongURL() {
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
    
    private func sendRequestWithError() -> ServerError? {
        var receiveError: ServerError?
        let exp = expectation(description: "Wait for error")
        
        let request = Request<ArrayObject<Int>>(query: "")
        sut.request(request) { data, error in
            receiveError = error
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        
        return receiveError
    }
}

extension ServerTests {
    class MockURLSession: URLSessionDataTaskProtocol {
        typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
        
        var completionHandler: CompletionHandler?
        var request: URLRequest?
        var dataTask = MockURLSessionDataTask()
        
        enum ResponseType {
            case success
            case failed
            case `nil`
        }
        
        var responseData: Data?
        var responseType: ResponseType = .nil
        var responseError: Error?
        
        func dataTask(with request: URLRequest, completionHandler: @escaping CompletionHandler) -> URLSessionDataTask {
            self.completionHandler = completionHandler
            self.request = request
            completionHandler(responseData, response(with: responseType, request: request), responseError)
            return dataTask
        }
        
        func response(with type: ResponseType, request: URLRequest) -> URLResponse? {
            switch type {
            case .success:
                return HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
            case .failed:
                return HTTPURLResponse(url: request.url!, statusCode: 404, httpVersion: "HTTP/1.1", headerFields: nil)!
            case .nil:
                return nil
            }
        }
    }
    
    class MockURLSessionDataTask: URLSessionDataTask {
        var resumeGotCalled = false
        
        override func resume() {
            resumeGotCalled = true
        }
    }
}
