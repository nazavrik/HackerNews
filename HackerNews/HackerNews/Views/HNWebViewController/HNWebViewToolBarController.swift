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
    
    fileprivate var imageName: String {
        switch self {
        case .back: return "back_browser_icon"
        case .forward: return "forward_browser_icon"
        case .share: return "share_icon"
        case .explore: return "explore_icon"
        case .refresh: return "refresh_icon"
        }
    }
    
    static var all: [HNToolBarItem] {
        return [.back, .forward, .refresh, .share, .explore]
    }
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
    private var items = [HNToolBarButton]()

    weak var delegate: HNWebViewToolBarDelegate?
    
    override init() {
        view = UIView(frame: .zero)
        view.backgroundColor = .white
        
        let topDivider = UIView(frame: .zero)
        topDivider.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.addSubview(topDivider)
        self.topDivider = topDivider
        
        super.init()
        
        for type in HNToolBarItem.all {
            let button = toolBarButton(type)
            view.addSubview(button)
            items.append(button)
        }
    }
    
    var frame: CGRect = .zero {
        didSet {
            view.frame = frame
            topDivider.frame = CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: 0.5)
            
            let buttonWidth: CGFloat = 50.0
            let space = Int(frame.size.width - CGFloat(items.count) * buttonWidth)/(items.count - 1)
            
            for (i, item) in items.enumerated() {
                item.frame = CGRect(x: CGFloat(i) * buttonWidth + CGFloat(i * space), y: 0.0, width: buttonWidth, height: frame.size.height)
            }
        }
    }
    
    func setEnabled(_ enabled: Bool, item type: HNToolBarItem) {
        for item in items {
            if item.itemType == type {
                item.isEnabled = enabled
                break
            }
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
