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

    func configure(title: String,
                   domain: String?,
                   name: String,
                   score: String,
                   comments: String?,
                   timeAgo: String) {
        
        let titleAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                               NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14.0)]
        
        let titleAttributedString = NSMutableAttributedString(string: title, attributes: titleAttributes)
        
        if let domain = domain {
            let domainAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0)]
            let domainAttributedString = NSAttributedString(string: " (\(domain))", attributes: domainAttributes)
            titleAttributedString.append(domainAttributedString)
        }
        
        titleLabel.attributedText = titleAttributedString
        
        
        scoreLabel.text = score
        
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                          NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0)]
        
        var description = name
        if let comments = comments {
            description += "  \(comments)"
        }
        description += "  \(timeAgo)"
        
        descriptionLabel.attributedText = NSAttributedString(string: description, attributes: attributes)
        
    }
}
