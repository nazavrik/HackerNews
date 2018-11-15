//
//  HNTitleTableView.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 11/11/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit

class HNButtonTitleView: UIView {
    private var _label: UILabel?
    private var _button: UIButton?
    private var _imageView: UIImageView?
    private var imageSize = CGSize(width: 10, height: 6)
    
    var title = "" {
        didSet {
            _label?.text = title
            _label?.sizeToFit()
            updateFrames()
        }
    }
    var didTitleSelect: (() -> Void)?
    
    convenience init(title: String) {
        self.init()
        
        self.title = title
        
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 17.0)
        label.textAlignment = .center
        label.text = title
        addSubview(label)
        _label = label
        _label?.sizeToFit()
        
        let imageView = UIImageView(image: UIImage(named: "open_icon"))
        imageView.backgroundColor = UIColor.clear
        addSubview(imageView)
        _imageView = imageView
        
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(buttonDidPress(_:)), for: .touchUpInside)
        addSubview(button)
        _button = button
        
        frame = CGRect(x: 0.0, y: 0.0, width: 200.0, height: 44.0)
    }
    
    override var frame: CGRect {
        didSet {
            updateFrames()
        }
    }
    
    @objc func buttonDidPress(_ sender: UIButton) {
        didTitleSelect?()
    }
    
    func setIconUp() {
        rotateIcon(false)
    }
    
    func setIconDown() {
        rotateIcon(true)
    }
    
    private func rotateIcon(_ idenity: Bool) {
        let angle: CGFloat = idenity ? CGFloat.pi - 3.14159 : CGFloat.pi
        
        UIView.animate(withDuration: 0.25) {
            self._imageView!.transform = CGAffineTransform(rotationAngle: .pi)
            self._imageView!.transform = CGAffineTransform(rotationAngle: angle)
        }
    }
    
    private func updateFrames() {
        _button?.frame = frame
        
        guard let label = _label else { return }
        
        let labelX = (frame.size.width - label.frame.size.width - imageSize.width - 2)/2
        let labelY = (frame.size.height - label.frame.size.height)/2
        
        _label?.frame = CGRect(x: labelX, y: labelY, width: label.frame.size.width, height: label.frame.size.height)
        
        let imageX = labelX + label.frame.size.width + 3
        let imageY = (frame.size.height - imageSize.height)/2 + 1
        
        _imageView?.frame = CGRect(x: imageX, y: imageY, width: imageSize.width, height: imageSize.height)
    }
}
