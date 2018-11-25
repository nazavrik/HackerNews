//
//  UIApplication.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 11/25/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit.UIApplication

extension UIApplication {
    static func open(_ urlString: String?) {
        guard let urlString = urlString else { return }
        
        open(URL(string: urlString))
    }
    
    static func open(_ url: URL?) {
        guard let url = url else { return }
        
        shared.open(url, options: [:], completionHandler: nil)
    }
}
