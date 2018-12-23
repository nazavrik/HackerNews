//
//  CommentsViewController.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/14/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit
import WebKit

class CommentsViewController: TableViewController {
    
    private var titleView: HNTitleView!
    
    var displayData: CommentsDisplayData! {
        didSet {
            tableDisplayData = displayData
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleView = HNTitleView(title: "Comments", secondTitle: displayData.article.title)
        navigationItem.titleView = titleView
        
        let button = HNBarButton(image: UIImage(named: "refresh_icon"))
        button.addTarget(self, action: #selector(self.updateAction(_:)), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        
        displayData.fetchComments()
    }
    
    @objc func updateAction(_ sender: UIButton) {
        displayData.fetchComments()
    }
}

extension CommentsViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= displayData.commentHeaderHeight {
            titleView.showSecondTitle()
        } else {
            titleView.showFirstTitle()
        }
    }
}
