//
//  Car.swift
//  WALL-E
//
//  Created by dokerplp on 4/26/22.
//

import Foundation

struct Car {
    
    private var x: Double
    private var y: Double
    
    public init() {
        self.x = 0
        self.y = 0
    }
    
    public func getX() -> Double {
        return x
    }
    
    public func getY() -> Double {
        return y
    }
    
    mutating public func go(x: Double, y: Double) {
        self.x = x / ControlViewConstants.MAX_RADIUS
        self.y = y / ControlViewConstants.MAX_RADIUS
    }
    
    public func brake(force: Double) {
        
    }
    
    
}
