//
//  UIView+Nib.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/11/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit.UIView

extension UIView {
    static var identifier: String {
        return String(describing: self)
    }
}
