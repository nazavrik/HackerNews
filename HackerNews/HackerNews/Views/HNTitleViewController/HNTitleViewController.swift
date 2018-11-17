//
//  HNTitleViewController.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 11/12/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit

protocol HNTitleTableViewDelegate: class {
    func titleTableView(_ tableView: UITableView, didSelect story: HNStoryType)
}

class HNTitleViewController: NSObject {
    private var titleCellHeight: CGFloat = 50.0
    private var _view = UIView()
    private var _titleTableView = UITableView()
    private var _items: [HNStoryType]
    private var _selectedStoryType: HNStoryType
    
    weak var delegate: HNTitleTableViewDelegate?
    
    var didTitleViewChange: ((Bool) -> Void)?
    
    init(with items: [HNStoryType], selected: HNStoryType) {
        _items = items
        _selectedStoryType = selected
        
        super.init()
        
        _titleTableView.bounces = false
        _titleTableView.separatorStyle = .none
        _titleTableView.delegate = self
        _titleTableView.dataSource = self
        _titleTableView.registerNib(for: StoryTitleTableViewCell.self)
        
        _view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        _view.alpha = 0.0
        _view.addSubview(_titleTableView)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(viewDidTap(_:)))
        recognizer.delegate = self
        _view.addGestureRecognizer(recognizer)
    }
    
    var view: UIView {
        return _view
    }
    
    var isOpen = false
    
    func updateFrame(with topMargin: CGFloat) {
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height - topMargin
        let frame = CGRect(x: 0.0,
                           y: topMargin,
                           width: width,
                           height: height)
        
        _view.frame = frame
        _titleTableView.frame = CGRect(x: 0.0, y: 0.0, width: width, height: isOpen ? titleTableViewHeight : 0.0)
    }
    
    func show() {
        isOpen = true
        
        _titleTableView.reloadData()
        
        _view.alpha = 0.0
        UIView.animate(withDuration: 0.25) {
            self._titleTableView.frame.size.height = self.titleTableViewHeight
            self._view.alpha = 1.0
        }
        
        didTitleViewChange?(true)
    }
    
    func hide() {
        isOpen = false
        
        UIView.animate(withDuration: 0.25) {
            self._titleTableView.frame.size.height = 0.0
            self._view.alpha = 0.0
        }
        
        didTitleViewChange?(false)
    }
    
    private var titleTableViewHeight: CGFloat {
        return CGFloat(_items.count)*titleCellHeight
    }
    
    @objc func viewDidTap(_ recognizer: UIGestureRecognizer) {
        hide()
    }
}

extension HNTitleViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchPoint = touch.location(in: _view)
        return !_titleTableView.frame.contains(touchPoint)
    }
}

extension HNTitleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return titleCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _selectedStoryType = _items[indexPath.row]
        tableView.deselectRow()
        delegate?.titleTableView(_titleTableView, didSelect: _items[indexPath.row])
    }
}

extension HNTitleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoryTitleTableViewCell", for: indexPath) as! StoryTitleTableViewCell
        
        let storyType = _items[indexPath.row]
        
        cell.titleLabel.text = storyType.title
        cell.separatorView.isHidden = indexPath.row == _items.count - 1
        cell.checkmarkImageView.isHidden = _selectedStoryType != storyType
        
        return cell
    }
}
