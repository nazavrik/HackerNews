//
//  ArticleViewController.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/19/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit
import WebKit

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
    
    var article: Article?
    var didSelectComments: (() -> Void)?
    
    deinit {
        print("deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = article?.url else { return }
        
        title = url.domain
        
        webViewController = HNWebViewController()
        
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        webViewController.load(myRequest)
        
        let button = HNBarButton(title: commentsTitle, image: UIImage(named: "comment_icon"))
        button.addTarget(self, action: #selector(self.commentsAction(_:)), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    @objc private func commentsAction(_ sender: UIButton) {
        didSelectComments?()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let y = view.layoutMarginsGuide.layoutFrame.origin.y
        var webViewControllerFrame = self.view.bounds
        webViewControllerFrame.origin.y = y
        webViewController.frame = webViewControllerFrame
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
}
