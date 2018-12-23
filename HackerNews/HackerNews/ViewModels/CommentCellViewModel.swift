//
//  CommentCellViewModel.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/20/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit

struct CommentCellViewModel {
    let comment: Comment
    let attributedText: NSAttributedString?
    var didCommentSelect: ((_ urls: [String]) -> Void)?
    
    init(comment: Comment, attributedText: NSAttributedString?) {
        self.comment = comment
        self.attributedText = attributedText
    }
}

extension CommentCellViewModel: CellViewModel {
    func setup(on cell: CommentTableViewCell) {
        cell.nameLabel.text = comment.author
        cell.dateLabel.text = comment.date?.timeSinceNow
        cell.commentLabel.attributedText = attributedText
        cell.level = comment.level
        cell.didCellSelect = didCommentSelect
    }
}

extension CommentCellViewModel {
    static func height(for comment: Comment, width: CGFloat) -> (CGFloat, NSAttributedString?) {
        guard
            let data = comment.text.data(using: .unicode),
            let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil)
            else { return (UITableView.automaticDimension, nil) }
        
        let top = CGFloat(49.0 + 5.0 + 0.5)
        let levelOffset = CGFloat(16 + 16*comment.level + 16)
        
        let size = CGSize(width: width - levelOffset, height: CGFloat.greatestFiniteMagnitude)
        let height = top + attributedString.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).height
        return (ceil(height), attributedString)
    }
    
    static private var options: [NSAttributedString.DocumentReadingOptionKey : Any] {
        return [.documentType: NSAttributedString.DocumentType.html]
    }
}
