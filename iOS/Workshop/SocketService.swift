//
//  SocketService.swift
//  Workshop
//
//  Created by Stefan Wirth on 03/03/16.
//  Copyright © 2016 Stefan Wirth. All rights reserved.
//

import Foundation
import SocketIOClientSwift

protocol SocketServiceProtocol {
    static var defaultInstance: SocketServiceProtocol {get}
    
    func connect()
    func disconnect()
    
    mutating func onConnect(callback: (() -> Void))
    mutating func onDisconnect(callback: (() -> Void))
    
    func addListenerForName(name: String, callback: ([AnyObject] -> [String:AnyObject]?)) -> NSUUID
    func removeListenerForId(id: NSUUID)
    
    func emitWithName(name: String, data: [String:AnyObject], withAckDataCallback callback: ([AnyObject] -> Void)?)
}

struct SocketService: SocketServiceProtocol {
    
    private let socket: SocketIOClient
    private var onConnect: [(() -> Void)] = []
    private var onDisconnect: [(() -> Void)] = []
    
    init(URL: NSURL, shouldLog: Bool? = false) {
        self.socket = SocketIOClient(
            socketURL: URL,
            options:[
                .Log(shouldLog!)
            ]
        )
        addStandardCallbacks()
    }
    
    static let defaultInstance: SocketServiceProtocol = {
        return SocketService(
            URL: NSURL(string: "http://localhost:1337")!
        )
    }()
    
    func connect() {
        self.socket.connect()
    }
    
    func disconnect() {
        self.socket.disconnect()
    }
    
    private func addStandardCallbacks() {
        self.socket.on("connect") { data, ack in
            self.onConnect.forEach({$0()})
        }
        self.socket.on("disconnect") { data, ack in
            self.onConnect.forEach({$0()})
        }
    }
    
    mutating func onConnect(callback: (() -> Void)) {
        self.onConnect.append(callback)
    }
    
    mutating func onDisconnect(callback: (() -> Void)) {
        self.onDisconnect.append(callback)
    }
    
    /// Adds the specified callback for the event name
    /// Triggers callback when an event is received
    ///
    /// - parameter name: The event name
    /// - parameter callback: The callback when data for that event is received -> return ack data to be send for client side acknowledge
    func addListenerForName(name: String, callback: ([AnyObject] -> [String:AnyObject]?)) -> NSUUID {
        return self.socket.on(name) { (data: [AnyObject], ack: SocketAckEmitter) in
            guard let ackData = callback(data) else {
                return
            }
            ack.with(ackData)
        }
    }
    
    func removeListenerForId(id: NSUUID) {
        self.socket.off(id: id)
    }
    
    /// Emits a message with a certain name and sends specified data
    /// Optional callback when the server acks
    ///
    /// - parameter name: The event name
    /// - parameter data: The data / payload to send
    /// - parameter callback: The callback when the ack from the server for that event is received
    func emitWithName(name: String, data: [String:AnyObject], withAckDataCallback callback: ([AnyObject] -> Void)? = nil) {
        if let callback = callback {
            self.socket.emitWithAck(name, data)(timeoutAfter: 0) { data in
                callback(data)
            }
        } else {
            self.socket.emit(name, data)
        }
    }
}