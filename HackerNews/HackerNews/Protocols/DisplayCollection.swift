//
//  DisplayCollection.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/11/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit

protocol DisplayCollection {
    static var modelsForRegistration: [BaseCellViewModel.Type] { get }
    
    var numberOfSections: Int { get }
    func numberOfRows(in section: Int) -> Int
    
    func model(for indexPath: IndexPath) -> BaseCellViewModel
    func height(for indexPath: IndexPath) -> CGFloat
    func estimatedHeight(for indexPath: IndexPath) -> CGFloat
    
    func header(for section: Int) -> BaseCellViewModel?
    func headerHeight(for section: Int) -> CGFloat
    
    func willDisplay(_ cell: UITableViewCell, forRowAt indexPath: IndexPath)
}

extension DisplayCollection {
    var numberOfSections: Int {
        return 1
    }
    
    func estimatedHeight(for indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func header(for section: Int) -> BaseCellViewModel? {
        return nil
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        return 0.0
    }
    
    func willDisplay(_ cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}

protocol DisplayCollectionAction {
    func didSelect(indexPath: IndexPath)
}

extension DisplayCollectionAction {
    func didSelect(indexPath: IndexPath) {}
}
