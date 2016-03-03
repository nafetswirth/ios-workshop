//
//  TaskTableViewCell.swift
//  Workshop
//
//  Created by Stefan Wirth on 01/02/16.
//  Copyright © 2016 Stefan Wirth. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dueToLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    func commonInit() {
        self.nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        self.dueToLabel = UILabel(frame: CGRect(x: 150, y: 0, width: 150, height: 150))
        self.addSubview(nameLabel)
        self.addSubview(dueToLabel)
    }
    
    var viewData: ViewData? = nil {
        didSet {
            self.nameLabel.text = viewData?.name
            self.dueToLabel.text = viewData?.dueTo.description
        }
    }
    
    struct ViewData {
        let name: String
        let dueTo: NSDate
    }
}