//
//  UITableView+CellViewModel.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/11/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit.UITableView

extension UITableView {
    func dequeueReusableCell(for indexPath: IndexPath, with model: BaseCellViewModel) -> UITableViewCell {
        let cellIdentifier = String(describing: type(of: model).cellClass)
        let cell = dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        model.setupCell(cell)
        
        return cell
    }
    
    func dequeueReusableHeader(for section: Int, with model: BaseCellViewModel) -> UIView {
        let cellIdentifier = String(describing: type(of: model).cellClass)
        guard let cell = dequeueReusableCell(withIdentifier: cellIdentifier) else { fatalError() }
        
        model.setupCell(cell)
        
        return cell.contentView
    }
}
