//
//  ISODateFormatter.swift
//  Workshop
//
//  Created by Stefan Wirth on 03/03/16.
//  Copyright © 2016 Stefan Wirth. All rights reserved.
//

import Foundation

struct ISODateFormatter {
    private static let isoDateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        formatter.timeZone = NSTimeZone(name: "UTC")
        return formatter
    }()
    
    static func stringFromDate(date: NSDate) -> String {
        return isoDateFormatter.stringFromDate(date)
    }
    
    static func dateFromString(string: String) -> NSDate? {
        return isoDateFormatter.dateFromString(string)
    }
}