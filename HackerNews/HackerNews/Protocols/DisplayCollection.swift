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
}

extension DisplayCollection {
    var numberOfSections: Int {
        return 1
    }
}

protocol DisplayCollectionAction {
    func didSelect(indexPath: IndexPath)
}

extension DisplayCollectionAction {
    func didSelect(indexPath: IndexPath) {}
}
