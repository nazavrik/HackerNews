//
//  UserProfileTableViewCell.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 11/17/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit

class UserProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var karmaLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
