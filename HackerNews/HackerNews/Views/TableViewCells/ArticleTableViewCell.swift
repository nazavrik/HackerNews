//
//  ArticleTableViewCell.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/11/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setTitleAttributedText(_ attributedText: NSAttributedString) {
        titleLabel.attributedText = attributedText
    }
    
    func setDescriptionAttributedText(_ attributedText: NSAttributedString) {
        descriptionLabel.attributedText = attributedText
    }
    
    func setScoreAttributedText(_ attributedText: NSAttributedString) {
        scoreLabel.attributedText = attributedText
    }
}
