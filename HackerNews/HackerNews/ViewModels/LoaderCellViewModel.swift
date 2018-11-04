//
//  LoaderCellViewModel.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/29/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import Foundation

struct LoaderCellViewModel {
    
}

extension LoaderCellViewModel: CellViewModel {
    func setup(on cell: LoaderTableViewCell) {
        cell.stopLoaderAnimation()
    }
}
