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
        
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.rowHeight = UITableView.automaticDimension
        
        let button = HNBarButton(image: UIImage(named: "update_icon"))
        button.addTarget(self, action: #selector(self.updateAction(_:)), for: UIControl.Event.touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        
        displayData.fetchComments()
    }
    
    @objc func updateAction(_ sender: UIButton) {
        displayData.fetchComments()
    }
}
