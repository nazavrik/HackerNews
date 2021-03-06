//
//  TableViewController.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/13/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    fileprivate var refreshControl = UIRefreshControl()
    
    var tableDisplayData: DisplayCollection!
    var refreshing = false {
        didSet {
            if refreshing {
                tableView.addSubview(refreshControl)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNibs(from: tableDisplayData)
        
        refreshControl.tintColor = UIColor.tint.withAlphaComponent(0.5)
        refreshControl.addTarget(self, action: #selector(refreshData), for: UIControl.Event.valueChanged)
    }
    
    func endRefreshing() {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
    
    @objc func refreshData() {
        
    }
}

extension TableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableDisplayData.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDisplayData.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = tableDisplayData.model(for: indexPath)
        return tableView.dequeueReusableCell(for: indexPath, with: model)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let model = tableDisplayData.header(for: section) else {
            return nil
        }
        return tableView.dequeueReusableHeader(for: section, with: model)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableDisplayData.willDisplay(cell, forRowAt: indexPath)
    }
}

extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableDisplayData.height(for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableDisplayData.height(for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableDisplayData.headerHeight(for: section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow()
        
        guard let actionDelegate = tableDisplayData as? DisplayCollectionAction else { return }
        actionDelegate.didSelect(indexPath: indexPath)
    }
}
