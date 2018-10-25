//
//  CommentCellViewModel.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/20/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import Foundation

struct CommentCellViewModel {
    let comment: Comment
    var didCommentSelect: ((_ urls: [String]) -> Void)?
    var didReplyingSelect: ((_ cell: CommentTableViewCell) -> Void)?
    
    init(comment: Comment) {
        self.comment = comment
    }
}

extension CommentCellViewModel: CellViewModel {
    func setup(on cell: CommentTableViewCell) {
        let numberOfSubcomments = ""//comment.commentIds.count == 0 ? "" : "\(comment.commentIds.count)"
        
        cell.config(name: comment.author,
                    text: comment.text,
                    timeAgo: comment.date?.timeSinceNow ?? "",
                    subComments: numberOfSubcomments)
        
        cell.level = comment.level
        
        cell.didCellSelect = didCommentSelect
        cell.didReplyingSelect = didReplyingSelect
    }
}
