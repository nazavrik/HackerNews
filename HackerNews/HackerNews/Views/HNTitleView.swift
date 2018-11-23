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
    private var attributedString: NSAttributedString!
    private var secondAttributedString: NSAttributedString?
    
    convenience init(frame: CGRect = .zero, title: String, secondTitle: String? = nil) {
        self.init(frame: frame)
        
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 2
        label.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        
        let attributes = stringAttrubutes(withFontSize: 17.0)
        attributedString = NSAttributedString(string: title, attributes: attributes)
        
        label.attributedText = attributedString
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        addSubview(label)
        titleLabel = label
        
        if let secondTitle = secondTitle {
            let attributes = stringAttrubutes(withFontSize: 14.0)
            secondAttributedString = NSAttributedString(string: secondTitle, attributes: attributes)
        }
        
        if frame == .zero {
            let width = UIScreen.main.bounds.size.width - 100.0
            self.frame = CGRect(x: 0.0, y: 0.0, width: width, height: 44.0)
        }
    }
    
    private func stringAttrubutes(withFontSize fontSize: CGFloat) -> [NSAttributedString.Key: NSObject] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        return [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize),
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
    }
    
    override var frame: CGRect {
        didSet {
            titleLabel?.frame = CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height)
        }
    }

    func showFirstTitle() {
        if titleLabel?.attributedText?.string != attributedString.string {
            titleLabel?.attributedText = attributedString
        }
    }
    
    func showSecondTitle() {
        guard let secondAttributedString = secondAttributedString else { return }
        
        if titleLabel?.attributedText?.string != secondAttributedString.string {
            titleLabel?.attributedText = secondAttributedString
        }
    }
}
