//
//  UserProfileCellViewModel.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 11/17/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import Foundation

struct UserProfileCellViewModel {
    let name: String
}

extension UserProfileCellViewModel: CellViewModel {
    func setup(on cell: UserProfileTableViewCell) {
        cell.nameLabel.text = name
        cell.karmaLabel.text = "100"
        cell.createdLabel.text = "10/10/2010"
    }
}
