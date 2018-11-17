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
            indicatorView.color = UIColor.tint
            addSubview(indicatorView)
            addConstraints(to: indicatorView, size: indicatorView.bounds.size)
            
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
            imageView.image = UIImage.animatedImage(with: images, duration: 1.0)
            addSubview(imageView)
            addConstraints(to: imageView, size: images.first!.size)
            
            gliderImageView = imageView
        }
        
        gliderImageView?.startAnimating()
    }
    
    private func addConstraints(to view: UIView?, size: CGSize) {
        view?.translatesAutoresizingMaskIntoConstraints = false
        view?.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        view?.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        view?.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        view?.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
