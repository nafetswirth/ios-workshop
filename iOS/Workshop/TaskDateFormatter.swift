//
//  TaskDateFormatter.swift
//  Workshop
//
//  Created by Stefan Wirth on 03/03/16.
//  Copyright © 2016 Stefan Wirth. All rights reserved.
//

import Foundation

struct TaskDateFormatter {
    private let dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd 'at' HH:mm"
        return dateFormatter
    }()
    
    func stringFromDate(date: NSDate) -> String {
        return self.dateFormatter.stringFromDate(date)
    }
    
    func dateFromString(string: String) -> NSDate? {
        return self.dateFormatter.dateFromString(string)
    }
}