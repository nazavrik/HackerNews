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

    fileprivate let activityIndicator = UIActivityIndicatorView(style: .gray)
    
    var url: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Article"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        
        if let url = url {
            activityIndicator.startAnimating()
            
            let myURL = URL(string: url)
            let myRequest = URLRequest(url: myURL!)
            webView.load(myRequest)
        }
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
}

