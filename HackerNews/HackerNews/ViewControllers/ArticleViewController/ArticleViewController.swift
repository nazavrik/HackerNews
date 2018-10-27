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

    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    private var commentsTitle: String {
        let commentsCount = article?.commentsCount ?? 0
        
        guard commentsCount > 0 else { return "" }
        
        return commentsCount > 999 ? "1K" : "\(commentsCount)"
    }
    
    var article: Article?
    var didSelectComments: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Article"
        
        guard let url = article?.url else { return }
        
        view.showLoader()
        webView.isHidden = true
        
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
        let button = HNBarButton(title: commentsTitle, image: UIImage(named: "comment_icon"))
        button.addTarget(self, action: #selector(self.commentsAction(_:)), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    @objc private func commentsAction(_ sender: UIButton) {
        didSelectComments?()
    }
}

extension ArticleViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.isHidden = false
        view.hideLoader()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("didFail")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("didFailProvisionalNavigation")
    }
}

