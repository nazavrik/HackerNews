//
//  Storyboards.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/14/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit

protocol Storyboard {
    static var storyboard: UIStoryboard { get }
    static var identifier: String { get }
}

extension Storyboard {
    static var storyboard: UIStoryboard {
        return UIStoryboard(name: identifier, bundle: nil)
    }
}

struct Storyboards {
    struct Main: Storyboard {
        static let identifier = "Main"
        
        static func articleListViewController() -> ArticleListViewController {
            return storyboard.instantiateViewController(withIdentifier: "ArticleListViewController") as! ArticleListViewController
        }
        
        static func articleViewController() -> ArticleViewController {
            return storyboard.instantiateViewController(withIdentifier: "ArticleViewController") as! ArticleViewController
        }
        
        static func webViewController() -> WebViewController {
            return storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        }
    }
}
