//
//  Request.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/12/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import Foundation

typealias RequestParameters = [String: String]

enum RequestMethod: String {
    case get, post, put, delete
    
    var string: String {
        return self.rawValue.uppercased()
    }
}

struct Request<T> {
    let query: String
    let method: RequestMethod
    let parameters: RequestParameters?
    let headers: RequestParameters?
        
    init(query: String,
         method: RequestMethod = .get,
         parameters: RequestParameters? = nil,
         headers: RequestParameters? = nil) {
        
        self.query = query
        self.method = method
        self.parameters = parameters
        self.headers = headers
    }
}
