//
//  SettingsViewController.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 12/23/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit

class SettingsViewController: TableViewController {

    var displayData: SettingsDisplayData! {
        didSet {
            tableDisplayData = displayData
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Settings"
    }

}
