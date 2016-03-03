//
//  TaskDetailView.swift
//  Workshop
//
//  Created by Stefan Wirth on 01/02/16.
//  Copyright © 2016 Stefan Wirth. All rights reserved.
//

import UIKit

protocol AddTaskDelegate: class {
    func didFinishWithTask(task: Task?)
}

class TaskDetailView: UIView {
    
    @IBOutlet weak var saveTaskButton: UIButton!
    
    weak var delegate: AddTaskDelegate?
    
    private var taskNameIndicatorLabel: UILabel?
    private var taskNameTextField: UITextField?
    private var taskDueToLabel: UILabel?
    //TODO: Take a look how to handle the datepicker stuff
    private var datePicker: UIDatePicker!
    
    private var dismissTaskButton: UIButton!
    
    var viewData: ViewData? = nil {
        didSet {
            taskNameIndicatorLabel?.text = viewData?.taskHint
            taskNameTextField?.text = viewData?.name
            taskDueToLabel?.text = viewData?.date
        }
    }
    
    struct ViewData {
        let taskHint: String?
        let name: String?
        let date: String?

        init(taskHint: String?, name: String? = nil, date: String? = nil) {
            self.taskHint = taskHint
            self.name = name
            self.date = date
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @IBAction func didPressSaveTaskButton(sender: UIButton) {
        let task = Task(name: taskNameTextField?.text ?? "", dueTo: NSDate(), isCompleted: false)
        self.delegate?.didFinishWithTask(task)
    }
    
    func didPressDismissButton(sender: UIButton) {
        self.delegate?.didFinishWithTask(nil)
    }
}