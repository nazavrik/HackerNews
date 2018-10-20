//
//  ArticleListViewController.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/11/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit

class ArticleListViewController: TableViewController {
    
    var displayData: ArticleListDisplayData! {
        didSet {
            tableDisplayData = displayData
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Articles"

        refreshing = true
        
        displayData.fetchArticles(refresh: false)
    }
    
    @objc override func refreshData() {
        displayData.fetchArticles(refresh: true)
    }
}
