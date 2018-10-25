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
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var replyViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewLeadingConstraint: NSLayoutConstraint!
    
    var didCellSelect: ((_ urls: [String]) -> Void)?
    var didReplyingSelect: ((_ cell: CommentTableViewCell) -> Void)?
    
    var level: Int = 0 {
        didSet {
            let lvl = level > 4 ? 4 : level
            contentViewLeadingConstraint.constant = CGFloat(16 + 16*lvl)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(name: String, text: String, timeAgo: String, subComments number: String) {
        nameLabel.text = name
        dateLabel.text = timeAgo
        let replyTitle = number.isEmpty ? "" : "Show Replies (\(number))"
        replyButton.setTitle(replyTitle, for: .normal)
        
        if let data = text.data(using: .unicode) {
            commentLabel.attributedText = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        }
        
        replyViewHeightConstraint.constant = replyTitle.isEmpty ? 0 : 30
    }
    
    @IBAction func didReply(_ sender: UIButton) {
        didReplyingSelect?(self)
    }
    
    @IBAction func didSelect(_ sender: UIButton) {
        var urls = [String]()
        commentLabel.attributedText?.enumerateAttribute(NSAttributedString.Key.link, in: NSMakeRange(0, commentLabel.text!.count), options: [.longestEffectiveRangeNotRequired], using: { value, range, isStop in
            if let value = value as? URL {
                urls.append(value.absoluteString)
            }
        })
        
        didCellSelect?(urls)
    }
}
