//
//  ServerError.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/12/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import Foundation

enum ServerError: Error {
    case noConnection
    case requestFailed
    case emptyResponse
    case other(String)
    
    init(data: Any?) {
        var errorMessage = Constants.defaultError
        
        if let jsonData = data as? JSONDictionary,
            let errors = jsonData.first?.value as? [String],
            let firstError = errors.first {
            
            errorMessage = firstError
        }
        
        self = .other(errorMessage)
    }
    
    var description: String {
        switch self {
        case .other(let message): return message
        case .noConnection: return "No Internet Connection."
        case .requestFailed: return "Request is wrong. Plase, try again later."
        case .emptyResponse: return Constants.defaultError
        }
    }
    
    struct Constants {
        static let defaultError = "Something is wrong. Plase, try again later."
    }
}
