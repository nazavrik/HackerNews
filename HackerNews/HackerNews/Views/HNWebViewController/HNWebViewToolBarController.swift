//
//  HNWebViewToolBarController.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 11/24/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit

enum HNToolBarItem: Int {
    case back
    case forward
    case share
    case explore
    case refresh
    case reader
    
    fileprivate var imageName: String {
        switch self {
        case .back: return "back_browser_icon"
        case .forward: return "forward_browser_icon"
        case .share: return "share_icon"
        case .explore: return "explore_icon"
        case .refresh: return "refresh_icon"
        case .reader: return "reader_icon"
        }
    }
}

enum HNAlignment {
    case left
    case right
    case center
}

class HNToolBarButton: UIButton {
    var itemType: HNToolBarItem?
}

protocol HNWebViewToolBarDelegate: class {
    func toolBarController(_ controller: HNWebViewToolBarController, didPress item: HNToolBarItem)
}

class HNWebViewToolBarController: NSObject {
    private(set) var view: UIView
    private var topDivider: UIView
    private var toolBarItems = [HNToolBarButton]()
    private let optimalNumberOfItems = 5
    private let optimalWidth: CGFloat = 60.0
    
    var items: [HNToolBarItem] = [] {
        didSet {
            let count = min(items.count, optimalNumberOfItems)
            
            for i in 0..<count {
                let button = toolBarButton(items[i])
                view.addSubview(button)
                toolBarItems.append(button)
            }
        }
    }
    weak var delegate: HNWebViewToolBarDelegate?
    var alignment: HNAlignment = .right
    
    override init() {
        view = UIView(frame: .zero)
        view.backgroundColor = .white
        
        let topDivider = UIView(frame: .zero)
        topDivider.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.addSubview(topDivider)
        self.topDivider = topDivider
        
        super.init()
    }
    
    var frame: CGRect = .zero {
        didSet {
            view.frame = frame
            topDivider.frame = CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: 0.5)
            updateItemFrames(frame)
        }
    }
    
    func setEnabled(_ enabled: Bool, item type: HNToolBarItem) {
        for item in toolBarItems {
            if item.itemType == type {
                item.isEnabled = enabled
                break
            }
        }
    }
    
    private func updateItemFrames(_ frame: CGRect) {
        let spaceBetweenItems = (frame.size.width - CGFloat(optimalNumberOfItems) * optimalWidth)/CGFloat(optimalNumberOfItems - 1)
        let freeSpace = CGFloat(optimalNumberOfItems - toolBarItems.count) * (optimalWidth + spaceBetweenItems)
        
        let rightOffset: CGFloat = {
            switch self.alignment {
            case .left: return freeSpace
            case .right: return 0.0
            case .center: return freeSpace/2.0
            }
        }()
        // Items from right to left
        for (i, item) in toolBarItems.reversed().enumerated() {
            let x = frame.size.width - (optimalWidth + CGFloat(i) * (optimalWidth + spaceBetweenItems) + rightOffset)
            item.frame = CGRect(x: x, y: 0.0, width: optimalWidth, height: frame.size.height)
        }
    }
    
    private func toolBarButton(_ item: HNToolBarItem) -> HNToolBarButton {
        let button = HNToolBarButton(type: .custom)
        button.itemType = item
        button.backgroundColor = .clear
        let image = UIImage(named: item.imageName)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        return button
    }
    
    @objc private func buttonAction(_ sender: HNToolBarButton) {
        delegate?.toolBarController(self, didPress: sender.itemType!)
    }
}
