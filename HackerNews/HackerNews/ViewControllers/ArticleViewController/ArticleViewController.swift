//
//  ArticleViewController.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/19/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit
import WebKit

protocol ArticleViewControllerDelegate: class {
    func articleViewController(_ articleViewController: ArticleViewController, didOpenOriginal article: Article)
    func articleViewController(_ articleViewController: ArticleViewController, didSelectCommentsOf article: Article)
    func articleViewController(_ articleViewController: ArticleViewController, didSelectUrl url: String)
}

class ArticleViewController: UIViewController {
    
    private var webViewController: HNWebViewController! {
        didSet {
            webViewController.delegate = self
            view.addSubview(webViewController.view)
        }
    }
    
    private var commentsTitle: String {
        let commentsCount = article?.commentsCount ?? 0
        return commentsCount > 999 ? "1K+" : "\(commentsCount)"
    }
    
    private var article: Article?
    
    enum Mode {
        case link(String)
        case original(Article)
        case content(Article)
        case none
    }
    
    var mode: Mode = .none
    weak var delegate: ArticleViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webViewController = HNWebViewController()
        
        var url = ""
        
        switch mode {
        case .link(let urlString):
            url = urlString
            webViewController.load(urlString)
        case .original(let article):
            url = article.url
            self.article = article
            webViewController.load(article.url)
            addCommentBarButton()
        case .content(let article):
            url = article.url
            self.article = article
            webViewController.loadHTML(article.content, url: article.url)
            addCommentBarButton()
        case .none: return
        }
        
        title = url.domain
        automaticallyAdjustsScrollViewInsets = false
    }
    
    @objc private func commentsAction(_ sender: UIButton) {
        guard let article = article else { return }
        delegate?.articleViewController(self, didSelectCommentsOf: article)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let y = view.layoutMarginsGuide.layoutFrame.origin.y
        var webViewControllerFrame = self.view.bounds
        webViewControllerFrame.origin.y = y
        webViewControllerFrame.size.height -= y
        webViewController.frame = webViewControllerFrame
    }
    
    private func addCommentBarButton() {
        let button = HNBarButton(title: commentsTitle, image: UIImage(named: "comment_icon"))
        button.addTarget(self, action: #selector(self.commentsAction(_:)), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
}

extension ArticleViewController: HNWebViewControllerDelegate {
    func webViewController(_ controller: HNWebViewController, didFail error: Error) {
        let err = error as NSError
        guard err.code == -1009 else { return } // The Internet connection appears to be offline.
        showAlert(title: "Can't load the article", message: "Plase, try again later.", completion: nil)
    }
    
    func webViewController(_ controller: HNWebViewController, share link: String) {
        let activityController = UIActivityViewController(activityItems: [link], applicationActivities: [])
        present(activityController, animated: true, completion: nil)
    }
    
    func webViewController(_ controller: HNWebViewController, open url: String) {
        delegate?.articleViewController(self, didSelectUrl: url)
    }
    
    func didSelectExplore(in controller: HNWebViewController) {
        guard let article = article else { return }
        delegate?.articleViewController(self, didOpenOriginal: article)
    }
}
