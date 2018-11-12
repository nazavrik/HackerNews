//
//  ArticleListViewController.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/11/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit

class ArticleListViewController: TableViewController {
    
    private var isTitleViewOpen = false
    
    var displayData: ArticleListDisplayData! {
        didSet {
            tableDisplayData = displayData
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let titleView = HNTitleTableView(title: "Stories")
        titleView.didTitleSelect = { [weak self] in
            self?.didTitleViewChange()
        }
        
        navigationItem.titleView = titleView
        
        refreshing = true
        
        displayData.fetchArticles(refresh: false)
    }
    
    @objc override func refreshData() {
        displayData.fetchArticles(refresh: true)
    }
    
    private func didTitleViewChange() {
        if isTitleViewOpen {
            isTitleViewOpen = false
        } else {
            isTitleViewOpen = true
        }
    }
}
