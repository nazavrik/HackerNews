//
//  CommentTableViewCell.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/20/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var contentViewLeadingConstraint: NSLayoutConstraint!
    
    var didCellSelect: ((_ urls: [String]) -> Void)?
    
    var level: Int = 0 {
        didSet {
            let lvl = level > 6 ? 6 : level
            contentViewLeadingConstraint.constant = CGFloat(16 + 16*lvl)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func didSelect(_ sender: UIButton) {
        var urls = [String]()
        let range = NSMakeRange(0, commentLabel.text!.count)
        let options: NSAttributedString.EnumerationOptions = [.longestEffectiveRangeNotRequired]
        commentLabel.attributedText?.enumerateAttribute(.link, in: range, options: options, using: { value, range, isStop in
            if let value = value as? URL {
                urls.append(value.absoluteString)
            }
        })
        
        didCellSelect?(urls)
    }
}
