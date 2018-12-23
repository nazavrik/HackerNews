//
//  Queue.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 12/14/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import Foundation

public struct Queue<T> {
    private var queue = [T?]()
    private var head = 0
    
    public init() {
        
    }
    
    public var isEmpty: Bool {
        return count == 0
    }
    
    public var count: Int {
        return queue.count - head
    }
    
    public var front: T? {
        if isEmpty { return nil }
        
        return queue[head]
    }
    
    public mutating func enqueue(_ item: T) {
        queue.append(item)
    }
    
    public mutating func enqueue(_ items: [T]) {
        queue.append(contentsOf: items)
    }
    
    public mutating func dequeue() -> T? {
        if isEmpty { return nil }
        
        guard head < queue.count,
            let item = queue[head] else { return nil }
        
        queue[head] = nil
        head += 1
        
        // shift queue elements
        let percentage = Double(head)/Double(queue.count)
        if queue.count > 50 && percentage > 0.5 {
            queue.removeFirst(head)
            head = 0
        }
        
        return item
    }
    
    public mutating func removeAll() {
        queue.removeAll()
        head = 0
    }
}
