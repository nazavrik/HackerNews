//
//  HNWebViewController.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 11/24/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit
import WebKit

protocol HNWebViewControllerDelegate: class {
    func webViewController(_ controller: HNWebViewController, didFail error: Error)
}

class HNWebViewController: NSObject {
    private var _view: UIView!
    private var webView: WKWebView!
    private var toolbar: UIToolbar!
    private var isLoading = false {
        didSet {
            if isLoading {
                view.showLoader(type: .glider)
            } else {
                view.hideLoader()
            }
            
            webView.isHidden = isLoading
        }
    }
    
    private var scrollViewDragging = false
    private var isToolbarHidden = false {
        didSet {
            if isToolbarHidden != oldValue {
                toolbar.isHidden = isToolbarHidden
            }
        }
    }
    private var isScrollDown = false
    private var startScrollingPoint: CGPoint = .zero
    
    weak var delegate: HNWebViewControllerDelegate?
    
    override init() {
        super.init()
        
        _view = UIView(frame: .zero)
        _view.backgroundColor = .clear
        
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        _view.addSubview(webView)
        
        toolbar = UIToolbar(frame: .zero)
        _view.addSubview(toolbar)
    }
    
    var view: UIView {
        return _view
    }
    
    var frame: CGRect = .zero {
        didSet {
            _view.frame = CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height)
            webView.frame = frame
            
            var toolbarFrame = _view.bounds
            toolbarFrame.origin.y = _view.bounds.size.height - 44.0
            toolbarFrame.size.height = 44.0
            toolbar.frame = toolbarFrame
        }
    }
    
    func load(_ request: URLRequest) {
        webView.load(request)
        isLoading = true
    }
}

extension HNWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        isLoading = false
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        isLoading = false
        delegate?.webViewController(self, didFail: error)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        isLoading = false
        delegate?.webViewController(self, didFail: error)
    }
}

extension HNWebViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollViewDragging = true
        startScrollingPoint = scrollView.contentOffset
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollViewDragging = false
        isScrollDown = (scrollView.contentOffset.y - startScrollingPoint.y) > 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollViewDragging { return }
        
        if isScrollDown {
            isToolbarHidden = true
        } else {
            isToolbarHidden = false
        }
    }
}
