//
//  Car.swift
//  WALL-E
//
//  Created by dokerplp on 4/26/22.
//

import Foundation

struct Car {
        
    private var direction: Double = 0
    private var speed: Double = 0
    
    private var counter = 0
    
    mutating public func isGo() -> Bool {
        counter = (counter + 1) % 5
        return counter == 0
    }
    
    public func getDirection() -> Double {
        return direction
    }
    
    public func getSpeed() -> Double {
        return speed
    }
    
    mutating public func setParam(x: Double, y: Double) {
        let _x = x / ControlViewConstants.MAX_RADIUS
        let _y = y / ControlViewConstants.MAX_RADIUS
        
        self.speed = sqrt(_x * _x + _y * _y)
        self.direction = _x
    }
    
    mutating public func go(x: Double, y: Double) {
        setParam(x: x, y: y)
    }
    
    public func brake(force: Double) {
        
    }
    
    
}
