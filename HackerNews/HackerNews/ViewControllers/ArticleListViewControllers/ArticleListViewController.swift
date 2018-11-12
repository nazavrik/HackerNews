//
//  ArticleListViewController.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/11/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit

class ArticleListViewController: TableViewController {
    
    private var titleViewController: HNTitleViewController! {
        didSet {
            titleViewController.delegate = self
            view.addSubview(titleViewController.view)
        }
    }
    
    private var titleView: HNButtonTitleView! {
        didSet {
            titleView.didTitleSelect = { [weak self] in
                self?.didTitleViewChange()
            }
            navigationItem.titleView = titleView
        }
    }
    
    var displayData: ArticleListDisplayData! {
        didSet {
            tableDisplayData = displayData
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleView = HNButtonTitleView(title: "Stories")
        titleViewController = HNTitleViewController(with: [.new, .top, .best])
        
        refreshing = true
        
        displayData.fetchArticles(refresh: false)
    }
    
    @objc override func refreshData() {
        displayData.fetchArticles(refresh: true)
    }
    
    private func didTitleViewChange() {
        if titleViewController.isOpen {
            titleViewController.hide()
        } else {
            titleViewController.show()
        }
    }
}

extension ArticleListViewController: HNTitleTableViewDelegate {
    func titleTableView(_ tableView: UITableView, didSelect story: HNStory) {
        titleView.title = story.title
        
        didTitleViewChange()
    }
}
