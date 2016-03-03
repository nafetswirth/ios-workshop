//
//  BlockBasedDatePicker.swift
//  Workshop
//
//  Created by Stefan Wirth on 03/03/16.
//  Copyright © 2016 Stefan Wirth. All rights reserved.
//

import UIKit

class BlockBasedDatePicker: UIDatePicker {
    var onDateChanged: ((newDate: NSDate) -> Void)?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        self.addTarget(self, action: "didChangeDate", forControlEvents: .ValueChanged)
    }
    
    func didChangeDate() {
        onDateChanged?(newDate: self.date)
    }
}