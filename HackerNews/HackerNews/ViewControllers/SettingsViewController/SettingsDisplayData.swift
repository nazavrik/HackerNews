//
//  SettingsDisplayData.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 12/23/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit

class SettingsDisplayData {
    private weak var viewController: SettingsViewController?
    
    init(viewController: SettingsViewController) {
        self.viewController = viewController
    }
}

extension SettingsDisplayData: DisplayCollection {
    
    enum Section: Int {
        case reader
        case theme
        
        var title: String {
            switch self {
            case .reader: return "Mode"
            case .theme: return "Theme"
            }
        }
        
        var rowTitle: String {
            switch self {
            case .reader: return "Show Reader mode first"
            case .theme: return "Dark"
            }
        }
    }
    
    static var modelsForRegistration: [BaseCellViewModel.Type] {
        return [
            SwitcherCellViewModel.self,
            HeaderCellViewModel.self
        ]
    }
    
    var numberOfSections: Int {
        return 2
    }
    
    func numberOfRows(in section: Int) -> Int {
        return 1
    }
    
    func model(for indexPath: IndexPath) -> BaseCellViewModel {
        guard let section = Section(rawValue: indexPath.section) else { fatalError() }
        
        let showSeparator = section == .theme
        
        var model = SwitcherCellViewModel(title: section.rowTitle, isOn: false, showSeparator: showSeparator)
        
        model.didSwitcherChange = { [weak self] isOn in
            self?.changeSwitcher(for: section, isOn: isOn)
        }
        
        return model
    }
    
    private func changeSwitcher(for section: Section, isOn: Bool) {
        if section == .reader {
            
        } else {
            
        }
    }
    
    func header(for section: Int) -> BaseCellViewModel? {
        guard let section = Section(rawValue: section) else { fatalError() }
        
        return HeaderCellViewModel(title: section.title)
    }
    
    func headerHeight(for section: Int) -> CGFloat {
        return 50.0
    }
    
    func height(for indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}
