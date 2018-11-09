//
//  CommentHeaderTableViewCell.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 11/8/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit

class CommentHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
