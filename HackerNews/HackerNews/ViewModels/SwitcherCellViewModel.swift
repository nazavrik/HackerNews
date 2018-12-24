//
//  SwitcherCellViewModel.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 12/23/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import Foundation

struct SwitcherCellViewModel {
    let title: String
    let isOn: Bool
    let showSeparator: Bool
    
    var didSwitcherChange: ((Bool) -> Void)?
    
    init(title: String, isOn: Bool, showSeparator: Bool) {
        self.title = title
        self.isOn = isOn
        self.showSeparator = showSeparator
    }
}

extension SwitcherCellViewModel: CellViewModel {
    func setup(on cell: SwitcherTableViewCell) {
        cell.configurate(title: title, isOn: isOn)
        cell.didSwitcherChange = didSwitcherChange
        cell.separatorView.isHidden = !showSeparator
    }
}
