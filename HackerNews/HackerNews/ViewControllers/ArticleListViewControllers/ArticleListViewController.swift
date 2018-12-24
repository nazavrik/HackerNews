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
    var didSettingsSelect: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleView = HNButtonTitleView(title: displayData.storyType.title)
        titleViewController = HNTitleViewController(with: [.new, .top, .best], selected: displayData.storyType)
        
        let leftButton = HNBarButton(image: UIImage(named: "info_icon"))
        leftButton.rightBarButton = false
        leftButton.addTarget(self, action: #selector(self.infoAction(_:)), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        
        let rightButton = HNBarButton(image: UIImage(named: "settings_icon"))
        rightButton.addTarget(self, action: #selector(self.settingsAction(_:)), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        
        refreshing = true
        
        displayData.fetchArticles(refresh: false)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let topMargin = view.layoutMarginsGuide.layoutFrame.origin.y
        titleViewController.updateFrame(with: topMargin)
    }
    
    @objc override func refreshData() {
        displayData.fetchArticles(refresh: true)
    }
    
    @objc func infoAction(_ sender: UIButton) {
        didInfoSelect?()
    }
    
    @objc func settingsAction(_ sender: UIButton) {
        didSettingsSelect?()
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
