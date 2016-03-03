//
//  ViewController.swift
//  Workshop
//
//  Created by Stefan Wirth on 01/02/16.
//  Copyright © 2016 Stefan Wirth. All rights reserved.
//

import UIKit

let kAddTaskViewControllerIdentifier = "addTaskViewController"

class TaskListViewController: UIViewController {
    
    @IBOutlet weak var taskTableView: UITableView!
    
    private let CELL_IDENTIFIER = "taskCell"
    
    //this will get replaced later on by date from the server
    private lazy var tasks: [Task] = [
        Task(name: "A Thing", dueTo: NSDate(), isCompleted: false),
        Task(name: "Another Thing", dueTo: NSDate().dateByAddingTimeInterval(60), isCompleted: false),
        Task(name: "Another One", dueTo: NSDate().dateByAddingTimeInterval(120), isCompleted: false),
        Task(name: "Horrible Thing", dueTo: NSDate().dateByAddingTimeInterval(180), isCompleted: false)
    ].sort({$0 < $1})

    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskTableView.delegate = self
        taskTableView.dataSource = self
    }
    
    @IBAction func didPressComposeNewTaskButton(sender: UIBarButtonItem) {
        guard let controller = storyboard!.instantiateViewControllerWithIdentifier(kAddTaskViewControllerIdentifier) as? AddTaskViewController else {
            return
        }
        controller.delegate = self
        self.presentViewController(controller, animated: true, completion: nil)
    }
}

extension TaskListViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        switch editingStyle {
        case .Delete:
            tasks.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        default:
            return
        }
    }
}

extension TaskListViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CELL_IDENTIFIER, forIndexPath: indexPath) as! TaskTableViewCell
        
        let task = tasks[indexPath.row]
        
        cell.viewData = TaskTableViewCell.ViewData(
            name: task.name,
            dueTo: task.dueTo
        )

        return cell
    }
}

extension TaskListViewController: AddTaskDelegate {
    func didFinishWithTask(task: Task?) {
        guard let task = task else {
            return
        }
        self.tasks.append(task)
        self.tasks.sortInPlace({$0 < $1})
        
        guard let taskIndex = self.tasks.indexOf({$0.name == task.name}) else {
            return
        }
        
        self.taskTableView.insertRowsAtIndexPaths([
                NSIndexPath(
                    forRow: taskIndex, inSection: 0
            )],
            withRowAnimation: .Fade)
    }
}