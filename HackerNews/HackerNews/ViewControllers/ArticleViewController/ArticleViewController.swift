//
//  ArticleViewController.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/14/18.
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
    
    var url: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Article"
        
        if let url = url {
            view.showLoader()
            
            let myURL = URL(string: url)
            let myRequest = URLRequest(url: myURL!)
            webView.load(myRequest)
        }
    }
}

extension ArticleViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        view.hideLoader()
    }
}
