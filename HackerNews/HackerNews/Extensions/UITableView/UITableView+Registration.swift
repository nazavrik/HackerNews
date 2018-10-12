//
//  UITableView+Registration.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/11/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit.UITableView

extension UITableView {
    func registerNibs(from displayCollection: DisplayCollection) {
        registerNibs(fromType: type(of: displayCollection))
    }
    
    private func registerNibs(fromType displayCollectionType: DisplayCollection.Type) {
        for cellModel in displayCollectionType.modelsForRegistration {
            if let tableCellClass = cellModel.cellClass as? UITableViewCell.Type {
                registerNib(for: tableCellClass)
            }
        }
    }
    
    func registerNib(for cellClass: UITableViewCell.Type) {
        register(cellClass.nib, forCellReuseIdentifier: cellClass.identifier)
    }
}
