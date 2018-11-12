//
//  HNStory.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 11/12/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import Foundation

enum HNStory: Int {
    case top
    case best
    case new
    
    var title: String {
        switch self {
        case .top: return "Top Stories"
        case .best: return "Best Stories"
        case .new: return "New Stories"
        }
    }
}
