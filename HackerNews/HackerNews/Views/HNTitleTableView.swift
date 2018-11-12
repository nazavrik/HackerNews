//
//  HNTitleTableView.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 11/11/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit

class HNTitleTableView: UIView {
    private var _button: UIButton?
    
    var didTitleSelect: (() -> Void)?
    
    convenience init(title: String) {
        self.init()
        
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
        button.setTitleColor(UIColor.black.withAlphaComponent(0.4), for: .highlighted)
        button.addTarget(self, action: #selector(buttonDidPress(_:)), for: .touchUpInside)
        addSubview(button)
        _button = button
        
        frame = CGRect(x: 0.0, y: 0.0, width: 200.0, height: 44.0)
    }
    
    override var frame: CGRect {
        didSet {
            _button?.frame = frame
        }
    }
    
    @objc func buttonDidPress(_ sender: UIButton) {
        didTitleSelect?()
    }
}
