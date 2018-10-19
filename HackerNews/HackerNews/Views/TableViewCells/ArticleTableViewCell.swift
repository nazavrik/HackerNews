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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(title: String, name: String, score: Int, comments: Int) {
        titleLabel.text = title
        scoreLabel.text = "\(score)"
        
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                          NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0)]
        
        nameLabel.attributedText = NSAttributedString(string: "\(name)  \(comments) comments", attributes: attributes)
        
    }
}
