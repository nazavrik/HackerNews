//
//  UserProfileDisplayData.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 11/17/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit

class UserProfileDisplayData {
    private weak var viewController: UserProfileViewController?
    private var user: String
    
    init(viewController: UserProfileViewController, user: String) {
        self.viewController = viewController
        self.user = user
    }
}

extension UserProfileDisplayData: DisplayCollection {
    static var modelsForRegistration: [BaseCellViewModel.Type] {
        return [UserProfileCellViewModel.self]
    }
    
    func numberOfRows(in section: Int) -> Int {
        return 1
    }
    
    func model(for indexPath: IndexPath) -> BaseCellViewModel {
        return UserProfileCellViewModel(name: user)
    }
    
    func height(for indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}
