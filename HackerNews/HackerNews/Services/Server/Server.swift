//
//  Server.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/12/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import Foundation

protocol URLSessionDataTaskProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionDataTaskProtocol {}

protocol ServerRequestProtocol {
    func request<T: ObjectType>(_ request: Request<T>, completion: @escaping ((T?, ServerError?) -> Void))
}

class Server: ServerRequestProtocol {
    private var session: URLSessionDataTaskProtocol
    
    let apiBase: String
    var returnCompletionBlockInMainThread = true
    
    static var standard: Server {
        return Server(apiBase: "https://hacker-news.firebaseio.com/v0/")
    }
    
    init(session: URLSessionDataTaskProtocol = URLSession.shared, apiBase: String) {
        self.session = session
        self.apiBase = apiBase
    }
    
    func request<T: ObjectType>(_ request: Request<T>, completion: @escaping ((T?, ServerError?) -> Void)) {
        sendRequest(request) { jsonObject, error in
            var object: T?
            
            if let jsonObject = jsonObject as? JSONDictionary {
                object = T(json: jsonObject)
            }
            
            if let jsonObject = jsonObject as? JSONArray {
                object = T(json: jsonObject)
            }
            
            completion(object, error)
        }
    }
    
    fileprivate func sendRequest<T>(_ request: Request<T>, completion: @escaping ((Any?, ServerError?) -> Void)) {
        guard let url = URL(string: apiBase + request.query) else {
            completion(nil, .requestFailed)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.string
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if let headers = request.headers {
            for (key, value) in headers {
                urlRequest.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let parameters = request.parameters {
            let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonData
        }
        
        func returnBlock(_ complete: @escaping (() -> Void)) {
            if !returnCompletionBlockInMainThread {
                complete()
                return
            }
            
            OperationQueue.main.addOperation {
                complete()
            }
        }
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                let internetAvailable = Reachability.isInternetAvailable
                let serverError: ServerError = !internetAvailable ? .noConnection : .requestFailed
                
                returnBlock {
                    completion(nil, serverError)
                }
                return
            }
            
            guard let data = data else {
                returnBlock {
                    completion(nil, .emptyResponse)
                }
                return
            }
            
            print(String(data: data, encoding: .utf8) ?? "")
            
            guard let httpResponse = response as? HTTPURLResponse else {
                returnBlock {
                    completion(nil, .requestFailed)
                }
                return
            }
            
            let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
            
            if httpResponse.statusCode != 200 {
                returnBlock {
                    completion(nil, ServerError(data: jsonData))
                }
                return
            }
            
            returnBlock {
                completion(jsonData, nil)
            }
        }
        
        task.resume()
    }
}
