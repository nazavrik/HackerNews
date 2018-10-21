//
//  HeaderCellViewModel.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/20/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import Foundation

struct HeaderCellViewModel {
    let title: String
}

extension HeaderCellViewModel: CellViewModel {
    func setup(on cell: ArticleHeaderTableViewCell) {
        cell.config(title: title)
    }
}
