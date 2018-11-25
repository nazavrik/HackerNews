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
    func webViewController(_ controller: HNWebViewController, share link: String)
}

class HNWebViewController: NSObject {
    private var _view: UIView!
    private var webView: WKWebView!
    private var toolBarController: HNWebViewToolBarController!
    private var isLoading = false {
        didSet {
            if isLoading {
                view.showLoader(type: .glider)
            } else {
                view.hideLoader()
            }
            
            webView.isHidden = isLoading
            isToolbarHidden = isLoading
        }
    }
    
    private var scrollViewDragging = false
    private var isToolbarHidden = false {
        didSet {
            guard isToolbarHidden != oldValue else { return }
            
            UIView.animate(withDuration: 0.25) {
                self.toolBarController.frame = self.toolBarFrame
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
        
        toolBarController = HNWebViewToolBarController()
        toolBarController.delegate = self
        _view.addSubview(toolBarController.view)
    }
    
    var view: UIView {
        return _view
    }
    
    var frame: CGRect = .zero {
        didSet {
            _view.frame = CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height)
            webView.frame = frame
            toolBarController.frame = toolBarFrame
        }
    }
    
    func load(_ request: URLRequest) {
        webView.load(request)
        isLoading = true
    }
    
    private var toolBarFrame: CGRect {
        let height: CGFloat = 44.0
        let y = isToolbarHidden ? _view.bounds.size.height : _view.bounds.size.height - height
        return CGRect(x: 0.0, y: y, width: _view.bounds.size.width, height: height)
    }
    
    private func updateToolBar() {
        isToolbarHidden = false
        
        toolBarController.setEnabled(webView.canGoBack, item: .back)
        toolBarController.setEnabled(webView.canGoForward, item: .forward)
    }
}

extension HNWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        isLoading = false
        updateToolBar()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        isLoading = false
        updateToolBar()
        delegate?.webViewController(self, didFail: error)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        isLoading = false
        updateToolBar()
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
        if scrollViewDragging || isLoading { return }
        
        if isScrollDown {
            isToolbarHidden = true
        } else {
            isToolbarHidden = false
        }
        
        if scrollView.contentOffset.y == 0.0 {
            isToolbarHidden = false
        }
    }
}

extension HNWebViewController: HNWebViewToolBarDelegate {
    func toolBarController(_ controller: HNWebViewToolBarController, didPress item: HNToolBarItem) {
        switch item {
        case .back:
            if webView.canGoBack { webView.goBack() }
        case .forward:
            if webView.canGoForward { webView.goForward() }
        case .share:
            delegate?.webViewController(self, share: webView.url?.absoluteString ?? "")
        case .explore:
            UIApplication.open(webView.url)
        case .refresh:
            webView.reload()
        }
    }
}
