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
        let displayData = ArticleListDisplayData(viewController: articleListViewController)
        displayData.didArticleSelect = { [weak self] article in
            self?.showArticleDetailsViewController(with: article)
        }
        
        articleListViewController.displayData = displayData
        
        navigationController.setViewControllers([articleListViewController], animated: false)
    }
    
    private func showArticleDetailsViewController(with article: Article) {
        let articleViewController = Storyboards.Main.articleViewController()
        
        let displayData = ArticleDisplayData(viewController: articleViewController, article: article)
        displayData.didOpeningUrlSelect = { [weak self] url in
            self?.showArticleViewController(with: url)
        }
        
        articleViewController.displayData = displayData
        
        navigationController.pushViewController(articleViewController, animated: true)
    }
    
    private func showArticleViewController(with url: String) {
        let webViewController = Storyboards.Main.webViewController()
        webViewController.url = url
        navigationController.pushViewController(webViewController, animated: true)
    }
}
