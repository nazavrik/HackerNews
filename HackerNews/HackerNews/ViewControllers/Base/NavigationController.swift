//
//  NavigationController.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/20/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        navigationBar.backgroundColor = UIColor.clear
        navigationBar.isTranslucent = true
        navigationBar.tintColor = UIColor.tint
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewControllers.last?.makeBackButtonEmpty()
        super.pushViewController(viewController, animated: animated)
    }
}
