//
//  String+Url.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/20/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import Foundation

extension String {
    var domain: String? {
        var url = self
        
        if url.hasPrefix("https://") {
            url = url.substring(from: 8)
        } else if url.hasPrefix("http://") {
            url = url.substring(from: 7)
        }
        
        if url.hasPrefix("www.") {
            url = url.substring(from: 4)
        }
        
        let parts = url.components(separatedBy: "/")
        return parts.first
    }
    
    func substring(from offset: Int) -> String {
        guard offset < count else { return "" }
        
        let stringIndex = index(startIndex, offsetBy: offset)
        return String(self[stringIndex...])
    }
}
