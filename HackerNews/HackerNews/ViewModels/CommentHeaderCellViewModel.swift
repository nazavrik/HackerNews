//
//  CommentHeaderCellViewModel.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 11/8/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit

struct CommentHeaderCellViewModel {
    let article: Article
}

extension CommentHeaderCellViewModel: CellViewModel {
    func setup(on cell: CommentHeaderTableViewCell) {
        cell.titleLabel.text = article.title
        cell.linkLabel.attributedText = linkAttributedText
        
        cell.authorLabel.text = article.author
        cell.timeLabel.text = article.date?.timeSinceNow ?? ""
        let scorePoints = article.score == 1 ? "point" : "points"
        cell.pointLabel.text = "\(article.score) \(scorePoints)"
    }
    
    var linkAttributedText: NSAttributedString {
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0),
            NSAttributedString.Key.link: NSMakeRange(0, article.url.count)
            ] as [NSAttributedString.Key : Any]
        
        return NSAttributedString(string: article.url, attributes: attributes)
    }
}
