//
//  UIViewController+NavigationBarItems.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/20/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit.UIViewController

extension UIViewController {
    func makeBackButtonEmpty() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
