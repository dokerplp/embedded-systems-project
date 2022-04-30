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
    var client: TCPClient? = nil
    
    
    public func isConnected() -> Bool {
        return client != nil
    }
    
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
    
    mutating public func write(dir: Double, speed: Double) -> String? {
        let _dir = round(dir * 1000) / 1000
        let _speed = round(speed * 1000) / 1000
        
        let data: Data = "\(_dir) \(_speed)\r\n".data(using: .utf8)!
        
        guard client != nil else {
            print("No connection")
            return nil
        }

        let result = client!.send(data: data)
        if (result.isFailure) {
            self.client = nil
            print(result)
            return nil
        }
        
        guard let array = client!.read(1024*8, timeout: 10) else { return nil }
        
        let ans = Data(_: array)
        
        return String(data: ans, encoding: .utf8)
    }
    

}
