//
//  HNTitleView.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 11/8/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit

class HNTitleView: UIView {
    private var titleLabel: UILabel?
    
    convenience init(frame: CGRect = .zero, title: String) {
        self.init(frame: frame)
        
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 2
        label.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14.0),
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        
        label.attributedText = NSAttributedString(string: title, attributes: attributes)
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        addSubview(label)
        titleLabel = label
        
        if frame == .zero {
            self.frame = CGRect(x: 0.0, y: 0.0, width: 200.0, height: 44.0)
        }
    }
    
    override var frame: CGRect {
        didSet {
            titleLabel?.frame = CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height)
        }
    }

}
