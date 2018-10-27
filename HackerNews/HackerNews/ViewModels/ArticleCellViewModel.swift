//
//  ArticleCellViewModel.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/11/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit

struct ArticleCellViewModel {
    let article: Article
}

extension ArticleCellViewModel: CellViewModel {
    func setup(on cell: ArticleTableViewCell) {
        cell.setTitleAttributedText(titleAttributedText)
        cell.setDescriptionAttributedText(descriptionAttributedText)
        cell.setScoreAttributedText(scoreAttributedText)
    }
    
    var titleAttributedText: NSAttributedString {
        let titleAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14.0)
        ]
        
        let titleAttributedString = NSMutableAttributedString(string: article.title, attributes: titleAttributes)
        
        if let domain = article.url.domain {
            let domainAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0)
            ]
            
            let domainAttributedString = NSAttributedString(string: " (\(domain))", attributes: domainAttributes)
            titleAttributedString.append(domainAttributedString)
        }
        
        return titleAttributedString
    }
    
    var descriptionAttributedText: NSAttributedString {
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0)
        ]
        
        let comments = article.commentsCount == 1 ? "comment" : "comments"
        
        var description = "by \(article.author)"
        description += " \(article.commentsCount) \(comments)"
        description += "  \(article.date?.timeSinceNow ?? "")"
        
        return NSAttributedString(string: description, attributes: attributes)
    }
    
    var scoreAttributedText: NSAttributedString {
        let scoreParagraphStyle = NSMutableParagraphStyle()
        scoreParagraphStyle.alignment = .center
        
        let scoreAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.tint,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14.0),
            NSAttributedString.Key.paragraphStyle: scoreParagraphStyle
        ]
        
        let scoreAttributedString = NSMutableAttributedString(string: "\(article.score)", attributes: scoreAttributes)
        
        let scorePoints = article.score == 1 ? "point" : "points"
        
        let scoreDescriptionAttibutes = [
            NSAttributedString.Key.foregroundColor: UIColor.tint,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10.0),
            NSAttributedString.Key.paragraphStyle: scoreParagraphStyle
        ]
        
        let scoreDescriptionAttributedString = NSAttributedString(string: "\n\(scorePoints)", attributes: scoreDescriptionAttibutes)
        scoreAttributedString.append(scoreDescriptionAttributedString)
        
        return scoreAttributedString
    }
}
