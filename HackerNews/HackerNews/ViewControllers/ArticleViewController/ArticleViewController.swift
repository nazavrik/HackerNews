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

    var webView: WKWebView?
    
    private var commentsTitle: String {
        let commentsCount = article?.commentsCount ?? 0
        return commentsCount > 999 ? "1K+" : "\(commentsCount)"
    }
    
    private var isLoading = false {
        didSet {
            if isLoading {
                view.showLoader(type: .glider)
            } else {
                view.hideLoader()
            }
            
            webView?.isHidden = isLoading
        }
    }
    
    var article: Article?
    var didSelectComments: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = article?.url else { return }
        
        title = url.domain
        
        createWebView()
        
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        webView?.load(myRequest)
        
        isLoading = true
        
        let button = HNBarButton(title: commentsTitle, image: UIImage(named: "comment_icon"))
        button.addTarget(self, action: #selector(self.commentsAction(_:)), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    @objc private func commentsAction(_ sender: UIButton) {
        didSelectComments?()
    }
    
    private func createWebView() {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        self.webView = webView
    }
}

extension ArticleViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        isLoading = false
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("didFail")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        isLoading = false
        
        self.showAlert(title: "Can't load the article", message: "Plase, try again later.", completion: nil)
    }
}

