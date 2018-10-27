//
//  HNButton.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/26/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit

class HNBarButton: UIButton {

    fileprivate var _imageView: UIImageView?
    fileprivate var _titleLabel: UILabel?
    
    convenience init(title: String? = nil, image: UIImage? = nil) {
        self.init(type: .custom)
        
        if let image = image {
            let imageView = UIImageView(image: image)
            addSubview(imageView)
            _imageView = imageView
        }
        
        if let title = title {
            let titleLabel = UILabel()
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let attributes = [
                NSAttributedString.Key.foregroundColor: UIColor.tint,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 9.0),
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ]
            
            titleLabel.attributedText = NSAttributedString(string: title, attributes: attributes)
            titleLabel.minimumScaleFactor = 0.5
            titleLabel.adjustsFontSizeToFitWidth = true
            addSubview(titleLabel)
            _titleLabel = titleLabel
        }
        
        frame = CGRect(x: 0.0, y: 0.0, width: 50.0, height: 44.0)
    }
    
    override var frame: CGRect {
        didSet {
            guard let image = _imageView?.image else { return }
            let leftEdgeInsets = rightBarButton ? frame.size.width - image.size.width : 0.0
            let x = leftEdgeInsets + (frame.size.width - leftEdgeInsets - image.size.width)/2
            let y = (frame.size.height - image.size.height)/2
            let width = image.size.width
            let height = image.size.height
            let imageFrame = CGRect(x: x, y: y, width: width, height: height)
            _imageView?.frame = imageFrame
            _titleLabel?.frame = CGRect(x: x + 2.0, y: y, width: width - 4.0, height: height)
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.4 : 1.0
        }
    }
    
    var rightBarButton = true
}
