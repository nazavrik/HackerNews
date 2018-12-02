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
            self?.showArticleViewController(.content(article))
        }
        
        articleListViewController.didInfoSelect = { [weak self] in
            self?.showInfoViewController()
        }
        
        articleListViewController.displayData = displayData
        
        navigationController.setViewControllers([articleListViewController], animated: false)
    }
    
    private func showCommentsViewController(for article: Article, currentMode: ArticleViewController.Mode) {
        let commentsViewController = Storyboards.Main.commentsViewController()
        
        let displayData = CommentsDisplayData(viewController: commentsViewController, article: article)
        displayData.didOpeningUrlSelect = { urlString in
            UIApplication.open(urlString)
        }
        
        displayData.didArticleSelect = { [weak self] in
            switch currentMode {
            case .content(_):
                self?.showArticleViewController(.original(article))
            case .original(_):
                self?.navigationController.popViewController(animated: true)
            default:
                break
            }
        }
        
        commentsViewController.displayData = displayData
        
        navigationController.pushViewController(commentsViewController, animated: true)
    }
    
    private func showArticleViewController(_ mode: ArticleViewController.Mode) {
        let articleViewController = Storyboards.Main.articleViewController()
        articleViewController.mode = mode
        articleViewController.delegate = self
        navigationController.pushViewController(articleViewController, animated: true)
    }
    
    private func showInfoViewController() {
        let infoViewController = Storyboards.Main.infoViewController()
        navigationController.pushViewController(infoViewController, animated: true)
    }
}

extension AppCoordinator: ArticleViewControllerDelegate {
    func articleViewController(_ articleViewController: ArticleViewController, didOpenOriginal article: Article) {
        showArticleViewController(.original(article))
    }
    
    func articleViewController(_ articleViewController: ArticleViewController, didSelectCommentsOf article: Article) {
        showCommentsViewController(for: article, currentMode: articleViewController.mode)
    }
    
    func articleViewController(_ articleViewController: ArticleViewController, didSelectUrl url: String) {
        showArticleViewController(.link(url))
    }
}
