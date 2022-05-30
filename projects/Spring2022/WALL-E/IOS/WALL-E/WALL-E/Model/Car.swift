//
//  Car.swift
//  WALL-E
//
//  Created by dokerplp on 4/26/22.
//

import Foundation

///`Car` is the struct that keeps car data - direction and speed
struct Car {
    
    /// Car direction
    ///
    /// if direction is less than 0 then car goes left
    /// otherwise car goes right
    public var direction: Double = 0
    /// Car speed
    ///
    /// if speed is less than 0 then car goes back
    /// otherwise car goes forward
    public var speed: Double = 0
    public var transmission: TransmissionView.TransmissionType = .drive1
    
    public func getMaxSpeed() -> Double {
        switch transmission {
        case .drive1:
            return 50
        case .drive2:
            return 70
        case .drive3:
            return 100
        case .reverse:
            return 100
        case .parking:
            return 10
        default:
            return 0
        }
    }
    
    
    @available(*, deprecated, message: "Use setCarParam instead")
    /// Car params setter
    /// - Parameters:
    ///   - x: direction
    ///   - y: speed
    mutating public func setParam(x: Double, y: Double) {
        let _x = x / ControlViewConstants.MAX_RADIUS
        let _y = y / ControlViewConstants.MAX_RADIUS
        
        self.speed = sqrt(_x * _x + _y * _y)
        self.direction = _x
    }
    
}
