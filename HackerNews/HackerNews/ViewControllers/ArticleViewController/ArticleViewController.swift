//
//  ArticleViewController.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/14/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit
import WebKit

class ArticleViewController: TableViewController {
    
    var displayData: ArticleDisplayData! {
        didSet {
            tableDisplayData = displayData
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Comments"
        
        let updateButton = UIButton(type: .custom)
        updateButton.frame = CGRect(x: 0.0, y: 0.0, width: 50.0, height: 44.0)
        updateButton.backgroundColor = .clear
        let image = UIImage(named: "update_icon")
        updateButton.setImage(image, for: .normal)
        updateButton.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 50.0 - image!.size.width, bottom: 0.0, right: 0.0)
        updateButton.addTarget(self, action: #selector(self.updateAction(_:)), for: UIControl.Event.touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: updateButton)
        
        displayData.fetchComments()
    }
    
    @objc func updateAction(_ sender: UIButton) {
        displayData.fetchComments()
    }
}
