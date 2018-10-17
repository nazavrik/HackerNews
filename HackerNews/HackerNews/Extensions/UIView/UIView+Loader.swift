//
//  UIView+Loader.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/16/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit

private var associationKey = "private_storedActivityIndicatorView"

extension UIView {
    weak var activityIndicatorView: UIActivityIndicatorView? {
        set {
            objc_setAssociatedObject(self, &associationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            let activityIndicator = objc_getAssociatedObject(self, &associationKey) as? UIActivityIndicatorView
            return activityIndicator
        }
    }
    
    func showLoader() {
        if activityIndicatorView == nil {
            let indicatorView = UIActivityIndicatorView(style: .gray)
            var indicatorFrame = indicatorView.frame
            indicatorFrame.origin.x = (frame.size.width - indicatorFrame.size.width)/2
            indicatorFrame.origin.y = (frame.size.height - indicatorFrame.size.height)/2
            indicatorView.frame = indicatorFrame
            
            addSubview(indicatorView)
            
            activityIndicatorView = indicatorView
        }
        
        activityIndicatorView?.startAnimating()
    }
    
    var isLoaderAnimating: Bool {
        return activityIndicatorView?.isAnimating ?? false
    }
    
    func hideLoader() {
        activityIndicatorView?.stopAnimating()
        activityIndicatorView = nil
    }
}
