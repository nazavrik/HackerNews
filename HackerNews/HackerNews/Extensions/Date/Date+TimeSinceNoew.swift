//
//  Date.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/19/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import Foundation

extension Date {
    var timeSinceNow: String {
        let delta = Date().timeIntervalSince1970 - self.timeIntervalSince1970
        let days = Int(delta/60/60/24)
        
        if days > 0 {
            let description = days == 1 ? "day" : "days"
            return "\(days) \(description) ago"
        }
        
        let hours = Int(delta/60/60)
        
        if hours > 0 {
            let description = hours == 1 ? "hour" : "hours"
            return "\(hours) \(description) ago"
        }
        
        let minutes = Int(delta/60)
        
        let description = minutes == 1 ? "minute" : "minutes"
        return "\(minutes) \(description) ago"
    }
}
