//
//  SwitcherTableViewCell.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 12/23/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit

class SwitcherTableViewCell: UITableViewCell {

    @IBOutlet weak var switcherTitle: UILabel!
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    var didSwitcherChange: ((Bool) -> Void)?
    
    func configurate(title: String, isOn: Bool) {
        switcherTitle.text = title
        switcher.isOn = isOn
    }
    
    @IBAction func switcherChanged(_ sender: UISwitch) {
        didSwitcherChange?(sender.isOn)
    }
}
