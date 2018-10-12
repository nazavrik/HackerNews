//
//  ArticleCellViewModel.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/11/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import Foundation

struct ArticleCellViewModel {
    let title: String
    let name: String
}

extension ArticleCellViewModel: CellViewModel {
    func setup(on cell: ArticleTableViewCell) {
        cell.configure(title: title, name: name)
    }
}
