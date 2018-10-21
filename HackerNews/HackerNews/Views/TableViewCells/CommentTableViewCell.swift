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
    
    var didCellSelect: ((_ urls: [String]) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(name: String, text: String, timeAgo: String) {
        nameLabel.text = name
        dateLabel.text = timeAgo
        
        if let data = text.data(using: .unicode) {
            commentLabel.attributedText = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        }
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
