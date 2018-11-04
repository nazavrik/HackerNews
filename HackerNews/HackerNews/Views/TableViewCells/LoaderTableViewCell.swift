//
//  LoaderTableViewCell.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 10/29/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit

class LoaderTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func startLoaderAnimation() {
        titleLabel.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func stopLoaderAnimation() {
        titleLabel.isHidden = false
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    var isAnimating: Bool {
        return activityIndicator.isAnimating
    }
}
