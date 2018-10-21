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
    
    init(comment: Comment) {
        self.comment = comment
    }
}

extension CommentCellViewModel: CellViewModel {
    func setup(on cell: CommentTableViewCell) {
        cell.config(name: comment.author,
                    text: comment.text,
                    timeAgo: comment.date?.timeSinceNow ?? "")
        
        cell.didCellSelect = didCommentSelect
    }
}
