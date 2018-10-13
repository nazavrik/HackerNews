//
//  Server.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/12/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import Foundation

class Server {
    fileprivate let apiBase: String
    
    static var standard: Server {
        return Server(apiBase: Constants.apiBase)
    }
    
    init(apiBase: String) {
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
        
        let session = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                OperationQueue.main.addOperation {
                    completion(nil, .requestFailed)
                }
                return
            }
            
            guard let data = data else {
                OperationQueue.main.addOperation {
                    completion(nil, .emptyResponse)
                }
                return
            }
            
            print(String(data: data, encoding: .utf8) ?? "")
            
            let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
            
            guard let httpResponse = response as? HTTPURLResponse else {
                OperationQueue.main.addOperation {
                    completion(nil, .requestFailed)
                }
                return
            }
            
            if httpResponse.statusCode != 200 {
                OperationQueue.main.addOperation {
                    completion(nil, ServerError(data: jsonData))
                }
                return
            }
            
            OperationQueue.main.addOperation {
                completion(jsonData, nil)
            }
        }
        
        session.resume()
    }
    
    private struct Constants {
        static var apiBase = "https://hacker-news.firebaseio.com/v0/"
    }
}
