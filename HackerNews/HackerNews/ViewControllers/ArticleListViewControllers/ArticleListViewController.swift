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
            titleViewController.didTitleViewChange = { [weak self] isOpen in
                if isOpen {
                    self?.titleView.setIconUp()
                } else {
                    self?.titleView.setIconDown()
                }
            }
            view.addSubview(titleViewController.view)
        }
    }
    
    private var titleView: HNButtonTitleView! {
        didSet {
            titleView.didTitleSelect = { [weak self] in
                self?.updateTitleViewController()
            }
            navigationItem.titleView = titleView
        }
    }
    
    var displayData: ArticleListDisplayData! {
        didSet {
            tableDisplayData = displayData
        }
    }
    
    var didInfoSelect: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleView = HNButtonTitleView(title: displayData.storyType.title)
        titleViewController = HNTitleViewController(with: [.new, .top, .best], selected: displayData.storyType)
        
        let button = HNBarButton(image: UIImage(named: "info_icon"))
        button.addTarget(self, action: #selector(self.infoAction(_:)), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        
        refreshing = true
        
        displayData.fetchArticles(refresh: false)
    }
    
    @objc override func refreshData() {
        displayData.fetchArticles(refresh: true)
    }
    
    @objc func infoAction(_ sender: UIButton) {
        didInfoSelect?()
    }
    
    private func updateTitleViewController() {
        if titleViewController.isOpen {
            titleViewController.hide()
        } else {
            titleViewController.show()
        }
    }
}

extension ArticleListViewController: HNTitleTableViewDelegate {
    func titleTableView(_ tableView: UITableView, didSelect story: HNStoryType) {
        titleView.title = story.title
        displayData.storyType = story
        updateTitleViewController()
    }
}
