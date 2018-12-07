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
    func webViewController(_ controller: HNWebViewController, open url: String)
    func didSelectExplore(in controller: HNWebViewController)
}

class HNWebViewController: NSObject {
    private var _view: UIView!
    private var loadingProgressView: UIView!
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
    private var url = ""
    private var isHTMLContent = false
    
    private enum LoadingProgressState {
        case none
        case start
        case `continue`
        case finish
        
        var widthPercent: CGFloat {
            switch self {
            case .none: return 0.0
            case .start: return 0.3
            case .continue: return 0.6
            case .finish: return 1.0
            }
        }
    }
    
    private var loadingProgressState: LoadingProgressState = .none {
        didSet {
            if loadingProgressState == .none { // reset frame
                loadingProgressView.frame = progressViewFrame
            }
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
        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.allowsInlineMediaPlayback = true
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        _view.addSubview(webView)
        
        loadingProgressView = UIView(frame: .zero)
        loadingProgressView.backgroundColor = UIColor.tint
        loadingProgressView.isHidden = true
        _view.addSubview(loadingProgressView)
        
        toolBarController = HNWebViewToolBarController()
        toolBarController.delegate = self
        _view.addSubview(toolBarController.view)
    }
    
    var view: UIView {
        return _view
    }
    
    var frame: CGRect = .zero {
        didSet {
            let size = CGSize(width: frame.size.width, height: frame.size.height + frame.origin.y)
            _view.frame = CGRect(origin: .zero, size: size)
            webView.frame = frame
            loadingProgressView.frame = progressViewFrame
            toolBarController.frame = toolBarFrame
        }
    }
    
    func loadHTML(_ html: String?, url: String) {
        // if html content too small open original url
        guard var html = html, html.count > 1000 else {
            load(url)
            return
        }
        
  
        // <pre> element is displayed in a fixed-width and brakes webview's width
        html = html.replacingOccurrences(of: "<pre", with: "<p", options: .literal, range: html.startIndex..<html.endIndex)
        html = html.replacingOccurrences(of: "</pre>", with: "</p>", options: .literal, range: html.startIndex..<html.endIndex)
        
        self.url = url
        isHTMLContent = true
        toolBarController.alignment = .right
        toolBarController.items = [.share, .explore]
        
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        }
        
        // change font size
        html = "<span style=\"font-family: 'HelveticaNeue'; font-size: 40; line-height: 60px; color:#555555;\">\(html)</span>"
        
        webView.isHidden = true
        webView.loadHTMLString(html, baseURL: nil)
        isLoading = true
    }
    
    func load(_ urlString: String) {
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        
        self.url = urlString
        
        toolBarController.alignment = .center
        toolBarController.items = [.back, .forward, .refresh, .share]
        webView.load(request)
        isLoading = true
    }
    
    private func updateLoadingProgress(with state: LoadingProgressState) {
        if loadingProgressState == state { return }
        
        loadingProgressState = state
        
        loadingProgressView.isHidden = false
        loadingProgressView.alpha = 1.0
        
        let alpha: CGFloat = loadingProgressState == .finish ? 0.0 : 1.0
        
        UIView.animate(withDuration: 0.25, animations: {
            self.loadingProgressView.frame = self.progressViewFrame
            self.loadingProgressView.alpha = alpha
        }) { _ in
            if self.loadingProgressState == .finish {
                self.loadingProgressState = .none
                self.loadingProgressView.isHidden = true
            }
        }
    }
    
    private func updateToolBar() {
        isToolbarHidden = false
        toolBarController.setEnabled(webView.canGoBack, item: .back)
        toolBarController.setEnabled(webView.canGoForward, item: .forward)
    }
    
    private var toolBarFrame: CGRect {
        let height: CGFloat = 44.0
        let y = isToolbarHidden ? _view.bounds.size.height : _view.bounds.size.height - height
        return CGRect(x: 0.0, y: y, width: _view.bounds.size.width, height: height)
    }
    
    private var progressViewFrame: CGRect {
        let height: CGFloat = 2.0
        let width = loadingProgressState.widthPercent*frame.size.width
        return CGRect(x: 0.0, y: frame.origin.y - height, width: width, height: height)
    }
}

extension HNWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        updateLoadingProgress(with: .finish)
        
        // adjust html content
        if isHTMLContent {
            let css = "body { margin: 20; padding: 20; }"
            let javascript = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style)"
            
            webView.evaluateJavaScript(javascript) { _, _ in
                webView.isHidden = false
                self.isLoading = false
            }
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        updateLoadingProgress(with: .start)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        webViewLoadingDidFail(error)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        webViewLoadingDidFail(error)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        // if content is loaded by URL, show it as soon as possible
        if !isHTMLContent {
            isLoading = false
        }
        updateToolBar()
        updateLoadingProgress(with: .continue)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated && isHTMLContent {
            delegate?.webViewController(self, open: url)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func webViewLoadingDidFail(_ error: Error) {
        isLoading = false
        updateToolBar()
        updateLoadingProgress(with: .finish)
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
        scrollView.contentOffset.x = 0.0
        
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
            delegate?.webViewController(self, share: url)
        case .explore:
            delegate?.didSelectExplore(in: self)
        case .refresh:
            loadingProgressState = .none
            webView.reload()
        case .reader:
            break
        }
    }
}
