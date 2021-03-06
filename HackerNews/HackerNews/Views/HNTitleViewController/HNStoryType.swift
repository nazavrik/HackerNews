//
//  HNStory.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 11/12/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import Foundation

enum HNStoryType: Int {
    case best
    case top
    case new
    
    var title: String {
        switch self {
        case .top: return "Top Stories"
        case .best: return "Best Stories"
        case .new: return "New Stories"
        }
    }
    
    var url: String {
        switch self {
        case .top: return "topstories.json"
        case .best: return "beststories.json"
        case .new: return "newstories.json"
        }
    }
}
