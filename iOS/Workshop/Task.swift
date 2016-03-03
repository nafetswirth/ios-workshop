//
//  Task.swift
//  Workshop
//
//  Created by Stefan Wirth on 01/02/16.
//  Copyright © 2016 Stefan Wirth. All rights reserved.
//

import Foundation

struct Task {
    let name: String
    let dueTo: NSDate
    let isCompleted: Bool
    
    init(name: String, dueTo: NSDate, isCompleted: Bool) {
        self.name = name
        self.dueTo = dueTo
        self.isCompleted = isCompleted
    }
}

func < (first: Task, second: Task) -> Bool {
    return first.dueTo.timeIntervalSince1970 < second.dueTo.timeIntervalSince1970
}