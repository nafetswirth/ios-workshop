//
//  TaskService.swift
//  Workshop
//
//  Created by Stefan Wirth on 03/03/16.
//  Copyright © 2016 Stefan Wirth. All rights reserved.
//

import Foundation
import SocketIOClientSwift
import Alamofire

protocol TaskServiceProtocol {
    func onSocketTaskCreated(callback: ((task: Task) -> Void)?)
    func onSocketTaskDestroyed(callback: ((task: Task) -> Void)?)
    
    func createTask(task: Task, completionBlock: (task: Task?, error: NSError?) -> Void)
    func getTasks(completionBlock: (tasks: [Task], error: NSError?) -> Void)
    func deleteTask(task: Task, completionBlock: (task: Task?, error: NSError?) -> Void)
}

enum SocketActionVerb: String {
    case Created = "created", Destroyed = "destroyed"
}

class TaskService: TaskServiceProtocol {
    private let socketService: SocketServiceProtocol
    private let baseURL: NSURL
    
    private let formatter = ISODateFormatter()
    
    private var onTaskCreated: ((task: Task) -> Void)?
    private var onTaskDeleted: ((task: Task) -> Void)?
    
    init(baseURL: NSURL, socketService: SocketServiceProtocol) {
        self.baseURL = baseURL
        self.socketService = socketService
        addSocketListeners()
        self.socketService.connect()
    }
    
    private func addSocketListeners() {
        self.socketService.addListenerForName("task") { (tasks) -> [String : AnyObject]? in
            //call right callbacks
            print(tasks)
            let task = tasks.first as? [String:AnyObject]
            guard let verb = task?["verb"] as? String else {
                return nil
            }
            
            guard let socketActionVerb = SocketActionVerb(rawValue: verb) else {
                return nil
            }
            
            switch socketActionVerb {
            case .Created:
                let _task = task?["data"] as? [String:AnyObject] ?? [:]
                self.onTaskCreated!(task: Task(json: _task))
            case .Destroyed:
                let _task = task?["previous"] as? [String:AnyObject] ?? [:]
                self.onTaskDeleted!(task: Task(json: _task))
            }
            
            return nil
        }
    }
    
    func onSocketTaskCreated(callback: ((task: Task) -> Void)?) {
        self.onTaskCreated = callback
    }
    
    func onSocketTaskDestroyed(callback: ((task: Task) -> Void)?) {
        self.onTaskDeleted = callback
    }
    
    func getTasks(completionBlock: (tasks: [Task], error: NSError?) -> Void) {
        request(.GET, "\(baseURL.absoluteString)/task")
            .validate()
            .responseJSON() { response in
                guard let tasks = response.result.value as? [[String:AnyObject]]
                    where response.result.error == nil else {
                    return completionBlock(tasks: [], error: response.result.error)
                }
                return completionBlock(tasks: tasks.map({Task(json: $0)}), error: nil)
        }
    }
    
    func createTask(task: Task, completionBlock: (task: Task?, error: NSError?) -> Void) {
        let params: [String:AnyObject] = [
            "name"        : task.name,
            "dueTo"       : ISODateFormatter.stringFromDate(task.dueTo)
        ]
    
        request(.POST, "\(baseURL.absoluteString)/task", parameters: params)
        .validate()
        .responseJSON() { response in
            guard let task = response.result.value as? [String:AnyObject]
                where response.result.error == nil else {
                    return completionBlock(task: nil, error: response.result.error)
            }
            return completionBlock(task: Task(json: task), error: nil)
        }
    }
    
    func deleteTask(task: Task, completionBlock: (task: Task?, error: NSError?) -> Void) {
        request(.DELETE, "\(baseURL.absoluteString)/task/\(task.id)")
            .validate()
            .responseJSON() { response in
                guard let task = response.result.value as? [String:AnyObject]
                    where response.result.error == nil else {
                        return completionBlock(task: nil, error: response.result.error)
                }
                return completionBlock(task: Task(json: task), error: nil)
        }
    }
}