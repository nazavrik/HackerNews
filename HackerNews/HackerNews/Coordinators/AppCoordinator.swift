//
//  AppCoordinator.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/14/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let articleListViewController = Storyboards.Main.articleListViewController()
        let displayData = ArticlesDisplayData(viewController: articleListViewController)
        displayData.didArticleSelect = { [weak self] article in
            self?.showArticleViewController(with: article)
        }
        
        articleListViewController.displayData = displayData
        
        navigationController.setViewControllers([articleListViewController], animated: false)
    }
    
    private func showArticleViewController(with article: Article) {
        let articleViewController = Storyboards.Main.articleViewController()
        
        articleViewController.url = article.url
        
        navigationController.pushViewController(articleViewController, animated: true)
    }
}
