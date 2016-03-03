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
    
    private lazy var tasks: [Task] = []
    
    private var taskService: TaskServiceProtocol = {
        let baseURL = NSURL(string: "https://ios-workshop.herokuapp.com")!
        return TaskService(
            baseURL: baseURL,
            socketService: SocketService(URL: baseURL, shouldLog: true)
        )
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskTableView.delegate = self
        taskTableView.dataSource = self
        
        taskService.getTasks { (tasks, error) -> Void in
            if let error = error {
                print(error)
                self.showNetworkAlert()
                return
            }
            self.tasks = tasks
            self.taskTableView.reloadData()
        }
        addTaskCallbacks()
    }
    
    private func addTaskCallbacks() {
        taskService.onSocketTaskCreated() { task in
            let index = self.tasks.indexOf({$0.id == task.id})
            if index != nil {
                return
            }
            self.tasks.append(task)
            self.tasks.sortInPlace({$0 < $1})
            guard let newIndex = self.tasks.indexOf({$0.id == task.id}) else {
                return
            }
            self.taskTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: newIndex, inSection: 0)], withRowAnimation: .Fade)
        }
        
        taskService.onSocketTaskDestroyed() { task in
            guard let index = self.tasks.indexOf({$0.id == task.id}) else {
                return
            }
            
            self.tasks.removeAtIndex(index)
            self.taskTableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .Fade)
        }
    }
    
    @IBAction func didPressComposeNewTaskButton(sender: UIBarButtonItem) {
        guard let controller = storyboard!.instantiateViewControllerWithIdentifier(kAddTaskViewControllerIdentifier) as? AddTaskViewController else {
            return
        }
        controller.delegate = self
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    private func showNetworkAlert() {
        let alertController = UIAlertController(title: "Error", message: "OOOOPS lel", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "K", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
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
            let removedTask = tasks.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)

            taskService.deleteTask(removedTask) { (task, error) -> Void in
                if let error = error {
                    print(error)
                    self.showNetworkAlert()
                    return
                }
            }
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
        
        self.taskService.createTask(task) { (createdTask, error) in
            guard let createdTask = createdTask where error == nil else {
                print(error)
                self.showNetworkAlert()
                return
            }
            
            self.tasks.append(createdTask)
            self.tasks.sortInPlace({$0 < $1})
            
            guard let taskIndex = self.tasks.indexOf({$0.name == task.name}) else {
                return
            }
            
            self.taskTableView.insertRowsAtIndexPaths([
                NSIndexPath(
                    forRow: taskIndex, inSection: 0
                )],
                withRowAnimation: .Fade
            )
        }
    }
}