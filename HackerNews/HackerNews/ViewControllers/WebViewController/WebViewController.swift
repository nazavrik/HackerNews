//
//  WebViewController.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/19/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    private var commentsTitle: String {
        let commentsCount = countOfComments ?? 0
        
        guard commentsCount > 0 else { return "" }
        
        return commentsCount > 999 ? "1K" : "\(commentsCount)"
    }
    
    var url: String?
    var countOfComments: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Article"
        
        guard let url = url else { return }
        
        view.showLoader()
        webView.isHidden = true
        
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
        let button = HNBarButton(title: commentsTitle, image: UIImage(named: "comment_icon"))
        button.addTarget(self, action: #selector(self.commentsAction(_:)), for: UIControl.Event.touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    @objc private func commentsAction(_ sender: UIButton) {
        
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.isHidden = false
        view.hideLoader()
    }
}

