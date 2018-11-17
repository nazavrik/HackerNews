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
            self?.showArticleViewController(with: article)
        }
        
        articleListViewController.didInfoSelect = { [weak self] in
            self?.showInfoViewController()
        }
        
        articleListViewController.displayData = displayData
        
        navigationController.setViewControllers([articleListViewController], animated: false)
    }
    
    private func showCommentsViewController(for article: Article) {
        let commentsViewController = Storyboards.Main.commentsViewController()
        
        let displayData = CommentsDisplayData(viewController: commentsViewController, article: article)
        displayData.didOpeningUrlSelect = { urlString in
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        displayData.didArticleSelect = { [weak self] user in
            if let user = user {
                self?.showUserProfileViewController(for: user)
            } else {
                self?.navigationController.popViewController(animated: true)
            }
        }
        
        commentsViewController.displayData = displayData
        
        navigationController.pushViewController(commentsViewController, animated: true)
    }
    
    private func showArticleViewController(with article: Article) {
        let articleViewController = Storyboards.Main.articleViewController()
        articleViewController.article = article
        articleViewController.didSelectComments = {
            self.showCommentsViewController(for: article)
        }
        navigationController.pushViewController(articleViewController, animated: true)
    }
    
    private func showInfoViewController() {
        let infoViewController = Storyboards.Main.infoViewController()
        
        navigationController.pushViewController(infoViewController, animated: true)
    }
    
    private func showUserProfileViewController(for user: String) {
        let userProfileViewController = Storyboards.Main.userProfileViewController()
        let displayData = UserProfileDisplayData(viewController: userProfileViewController, user: user)
        
        userProfileViewController.displayData = displayData
        
        navigationController.pushViewController(userProfileViewController, animated: true)
    }
}
