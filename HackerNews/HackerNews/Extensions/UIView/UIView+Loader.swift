//
//  UIView+Loader.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/16/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit

private var acivityAssociationKey = "private_storedActivityIndicatorView"
private var gliderAssociationKey = "private_storedGliderImageView"

extension UIView {
    
    enum LoaderType {
        case activity
        case glider
    }
    
    weak var activityIndicatorView: UIActivityIndicatorView? {
        set {
            objc_setAssociatedObject(self, &acivityAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, &acivityAssociationKey) as? UIActivityIndicatorView
        }
    }
    
    weak var gliderImageView: UIImageView? {
        set {
            objc_setAssociatedObject(self, &gliderAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, &gliderAssociationKey) as? UIImageView
        }
    }
    
    func showLoader(type: LoaderType = .activity) {
        switch type {
        case .activity:
            showActivityLoader()
        case .glider:
            showGliderLoader()
        }
    }
    
    var isLoaderAnimating: Bool {
        return activityIndicatorView?.isAnimating ?? false
    }
    
    func hideLoader() {
        activityIndicatorView?.stopAnimating()
        activityIndicatorView?.removeFromSuperview()
        activityIndicatorView = nil
        
        gliderImageView?.stopAnimating()
        gliderImageView?.removeFromSuperview()
        gliderImageView = nil
    }
    
    private func showActivityLoader() {
        if activityIndicatorView == nil {
            let indicatorView = UIActivityIndicatorView(style: .white)
            indicatorView.frame = frame(for: indicatorView.bounds.size)
            indicatorView.color = UIColor.tint
            addSubview(indicatorView)
            
            activityIndicatorView = indicatorView
        }
        
        activityIndicatorView?.startAnimating()
    }
    
    private func showGliderLoader() {
        if gliderImageView == nil {
            let images = [
                UIImage(named: "frame_01")!,
                UIImage(named: "frame_02")!,
                UIImage(named: "frame_03")!,
                UIImage(named: "frame_04")!
            ]
            
            let imageView = UIImageView()
            imageView.frame = frame(for: images.first!.size)
            imageView.image = UIImage.animatedImage(with: images, duration: 1.0)
            addSubview(imageView)
            
            gliderImageView = imageView
        }
        
        gliderImageView?.startAnimating()
    }
    
    private func frame(for size: CGSize) -> CGRect {
        let x = (frame.size.width - size.width)/2
        let y = (frame.size.height - size.height)/2
        
        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
}
