//
//  ArticlesDisplayData.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/11/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit

struct ArticlesDisplayData {
    
}

extension ArticlesDisplayData: DisplayCollection {
    static var modelsForRegistration: [BaseCellViewModel.Type] {
        return [ArticleCellViewModel.self]
    }
    
    func numberOfRows(in section: Int) -> Int {
        return 10
    }
    
    func model(for indexPath: IndexPath) -> BaseCellViewModel {
        return ArticleCellViewModel(title: "\(indexPath.row)", name: "by Name")
    }
    
    func height(for indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
}
