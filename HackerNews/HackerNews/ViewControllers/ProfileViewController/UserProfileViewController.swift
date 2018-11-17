//
//  UserProfileViewController.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 11/17/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit

class UserProfileViewController: TableViewController {

    var displayData: UserProfileDisplayData! {
        didSet {
            tableDisplayData = displayData
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "User Profile"
    }
}
