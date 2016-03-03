//
//  Task.swift
//  Workshop
//
//  Created by Stefan Wirth on 01/02/16.
//  Copyright © 2016 Stefan Wirth. All rights reserved.
//

import Foundation

struct Task {
    let id: Int
    let name: String
    let dueTo: NSDate
    let isCompleted: Bool
    
    init(id: Int, name: String, dueTo: NSDate, isCompleted: Bool) {
        self.id = id
        self.name = name
        self.dueTo = dueTo
        self.isCompleted = isCompleted
    }
    
    init(json: [String:AnyObject]) {
        let id = json["id"] as? Int
        let name = json["name"] as? String
        let dueTo = ISODateFormatter.dateFromString(json["dueTo"] as? String ?? "") ?? NSDate()
        //asert required params
        assert(id != nil && name != nil)
        
        let isCompleted = json["isCompleted"] as? Bool ?? false
        
        self.init(
            id: id ?? 0,
            name: name ?? "Task",
            dueTo: dueTo ?? NSDate(),
            isCompleted: isCompleted
        )
    }
}

func < (first: Task, second: Task) -> Bool {
    return first.dueTo.timeIntervalSince1970 < second.dueTo.timeIntervalSince1970
}