//
//  TaskDateFormatter.swift
//  Workshop
//
//  Created by Stefan Wirth on 03/03/16.
//  Copyright © 2016 Stefan Wirth. All rights reserved.
//

import Foundation

struct TaskDateFormatter {
    let dateFormatter: NSDateFormatter
    
    init() {
        self.dateFormatter = NSDateFormatter()
        self.dateFormatter.dateFormat = "yyyy-MM-dd 'at' HH:mm"
    }
    
    func stringFromDate(date: NSDate) -> String {
        return self.dateFormatter.stringFromDate(date)
    }
    
    func dateFromString(string: String) -> NSDate? {
        return self.dateFormatter.dateFromString(string)
    }
}