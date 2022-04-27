//
//  Client.swift
//  WALL-E
//
//  Created by dokerplp on 4/26/22.
//

import Foundation
import SwiftSocket

struct Client {
    var client: TCPClient?
    
    mutating func connect() {
        let client = TCPClient(address: NetworkConstants.HOST, port: NetworkConstants.PORT)
        
        switch client.connect(timeout: 10) {
          case .success:
            self.client = client
          case .failure(let error):
            print(error)
            connect()
        }
    }
    
    mutating func write(dir: Double, speed: Double) {
        let _dir = round(dir * 1000) / 1000
        let _speed = round(speed * 1000) / 1000
        
        connect()
        
        let data: Data = "\(_dir) \(_speed)\r\n".data(using: .utf8)!
        if (client != nil) {
            let result = client!.send(data: data)
            print(result)
            client?.close()
        } else {
            print("No connection")
            connect()
        }
        
    }
}
