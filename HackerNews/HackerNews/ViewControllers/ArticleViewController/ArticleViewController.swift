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

        title = "Details"
    }
}
