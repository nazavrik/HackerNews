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
    
    weak var delegate: HNTitleTableViewDelegate?
    
    var didTitleViewChange: ((Bool) -> Void)?
    
    init(with items: [HNStoryType]) {
        _items = items
        
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
        
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height - 64.0
        let frame = CGRect(x: 0.0,
                           y: 64.0,
                           width: width,
                           height: height)
        
        _view.frame = frame
        _titleTableView.frame = CGRect(x: 0.0, y: 0.0, width: width, height: 0.0)
    }
    
    var view: UIView {
        return _view
    }
    
    var isOpen = false
    
    func show() {
        isOpen = true
        
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
        
        cell.titleLabel.text = _items[indexPath.row].title
        cell.separatorView.isHidden = indexPath.row == _items.count - 1
        
        return cell
    }
}
