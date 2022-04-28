//
//  Client.swift
//  WALL-E
//
//  Created by dokerplp on 4/26/22.
//

import Foundation
import SwiftSocket

struct Client {
        
    private var host: String = ""
    private var port: Int32 = 0
    var client: TCPClient?
    
    func isConnected() -> Bool {
        return client != nil
    }
    
    mutating func connect(host: String, port: Int32) {
        
        self.host = host
        self.port = port
        
        let client = TCPClient(address: host, port: port)
        
        switch client.connect(timeout: 10) {
          case .success:
            self.client = client
          case .failure(let error):
            print(error)
            self.client = nil
        }
    }
    
    mutating func write(dir: Double, speed: Double) {
        let _dir = round(dir * 1000) / 1000
        let _speed = round(speed * 1000) / 1000
                
        connect(host: self.host, port: self.port)
        
        let data: Data = "\(_dir) \(_speed)\r\n".data(using: .utf8)!
        if (client != nil) {
            let result = client!.send(data: data)
            print(result)

            guard let array = client!.read(1024*8, timeout: 1) else { return; }
            
            let data = Data(_: array)
            let value = String(data: data, encoding: .utf8) ?? "null"
            print(value)
            
        } else {
            print("No connection")
        }
        
    }
}
