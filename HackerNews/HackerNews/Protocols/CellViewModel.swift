//
//  CellViewModel.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/11/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit.UIView

protocol BaseCellViewModel {
    static var cellClass: UIView.Type { get }
    func setupCell(_ cell: UIView)
}

protocol CellViewModel: BaseCellViewModel {
    associatedtype CellClass: UIView
    func setup(on cell: CellClass)
}

extension CellViewModel {
    static var cellClass: UIView.Type {
        return Self.CellClass.self
    }
    
    func setupCell(_ cell: UIView) {
        guard let cell = cell as? Self.CellClass else { return }
        setup(on: cell)
    }
}
