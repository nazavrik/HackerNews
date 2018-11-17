//
//  UIDevice+Orientation.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 11/16/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit

extension UIDevice {
    static var isPortrait: Bool {
        return UIDevice.current.orientation == .portrait
    }
}
