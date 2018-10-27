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
        showMainViewController()
    }
    
    private func showMainViewController() {
        let articleListViewController = Storyboards.Main.articleListViewController()
        let displayData = ArticleListDisplayData(viewController: articleListViewController)
        displayData.didArticleSelect = { [weak self] article in
            self?.showCommentsViewController(for: article)
        }
        
        articleListViewController.displayData = displayData
        
        navigationController.setViewControllers([articleListViewController], animated: false)
    }
    
    private func showCommentsViewController(for article: Article) {
        let commentsViewController = Storyboards.Main.commentsViewController()
        
        let displayData = CommentsDisplayData(viewController: commentsViewController, article: article)
        displayData.didOpeningUrlSelect = { [weak self] url in
            self?.showArticleViewController(with: article)
        }
        
        commentsViewController.displayData = displayData
        
        navigationController.pushViewController(commentsViewController, animated: true)
    }
    
    private func showArticleViewController(with article: Article) {
        let articleViewController = Storyboards.Main.articleViewController()
        articleViewController.url = article.url
        articleViewController.countOfComments = article.commentsCount
        navigationController.pushViewController(articleViewController, animated: true)
    }
}
