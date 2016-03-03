//
//  AddTaskViewController.swift
//  Workshop
//
//  Created by Stefan Wirth on 01/02/16.
//  Copyright © 2016 Stefan Wirth. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var taskDueTextField: UITextField!
    
    weak var delegate: AddTaskDelegate?
    
    private lazy var dateFormatter: TaskDateFormatter = TaskDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGestureRecognizer()
    }
    
    private func addTapGestureRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: "didEndEditingTextField:")
        self.view.addGestureRecognizer(recognizer)
    }
    
    @IBAction func didPressSaveTaskButton(sender: AnyObject) {
        let task = Task(
            name: nameTextField.text ?? "Task Name",
            dueTo: dateFormatter.dateFromString(
                taskDueTextField.text ?? ""
            ) ?? NSDate(),
            isCompleted: false
        )
        self.delegate?.didFinishWithTask(task)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didPressCancelTaskButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didBeginEditingTaskDueTexfield(sender: UITextField) {
        let datePicker = BlockBasedDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.DateAndTime
        sender.inputView = datePicker
        datePicker.onDateChanged = { date in
            self.taskDueTextField.text = self.dateFormatter.stringFromDate(date)
        }
    }
    
    func didEndEditingTextField(sender: AnyObject) {
        self.view.endEditing(true)
    }
}