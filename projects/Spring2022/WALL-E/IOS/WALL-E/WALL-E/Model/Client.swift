//
//  Client.swift
//  WALL-E
//
//  Created by dokerplp on 4/26/22.
//

import Foundation
import SwiftSocket

/// `Client` is struct that is responsible for connecting to the server and exchanging data between it and the application
struct Client {
    
    ///Server host
    private var host: String = ""
    
    ///Server port
    private var port: Int32 = 0
    
    ///Current tcp connection
    private var client: TCPClient? = nil
    public func isConnected() -> Bool {
        return client != nil
    }
    
    ///Makes new TCP connection
    ///
    /// - Parameters:
    ///     - host: server's host
    ///     - port: server's port
    mutating public func connect(host: String, port: Int32) {
        self.host = host
        self.port = port
        
        let client = TCPClient(address: host, port: port)
        
        switch client.connect(timeout: 2) {
        case .success:
            self.client = client
        case .failure(let error):
            self.client = nil
            print(error)
        }
    }
    
    ///Sends coordinates of the wheel and current speed, waiting for a battery charge as a response
    ///
    /// - Parameters:
    ///     - dir: coordinates of the wheel
    ///     - speed: car's speed
    /// - Returns: battery charge or null if connection is lost
    mutating public func write(dir: Double, speed: Double) -> String? {
        let _dir = round(dir * 100) / 100
        let _speed = round(speed) / 100
        
        let data: Data = "\(_speed):\(_dir)\r".data(using: .utf8)!
        
        guard client != nil else {
            print("No connection")
            return nil
        }
        
        let result = client!.send(data: data)
        if (result.isFailure) {
            self.client = nil
            return nil
        }
        
        guard let array = client!.read(1024*8, timeout: 10) else { return nil }
        let ans = Data(_: array)
        return String(data: ans, encoding: .utf8)
    }
}
