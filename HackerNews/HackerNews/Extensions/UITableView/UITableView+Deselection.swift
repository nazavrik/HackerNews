//
//  UITableView+Deselection.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/14/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit.UITableView

extension UITableView {
    func deselectRow() {
        if let rowIndex = indexPathForSelectedRow {
            deselectRow(at: rowIndex, animated: true)
        }
    }
}
