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
    private var direction: Double = 0
    /// Car speed
    ///
    /// if speed is less than 0 then car goes back
    /// otherwise car goes forward
    private var speed: Double = 0
    private var transmission: TransmissionView.TransmissionType = .drive1
    
    public mutating func setDirection(dir: Double) {
        self.direction = dir
    }
    public mutating func setSpeed(speed: Double) {
        self.speed = speed
    }
    public mutating func setTransmission(transmission: TransmissionView.TransmissionType) {
        self.transmission = transmission
    }
    
    public func getDirection() -> Double {
        return direction
    }
    public func getSpeed() -> Double {
        return speed
    }
    
    public func getTransmission() -> TransmissionView.TransmissionType {
        return transmission
    }
    
    public func getMaxSpeed() -> Double {
        switch transmission {
        case .drive1:
            return 50
        case .drive2:
            return 70
        case .drive3:
            return 100
        case .reverse:
            return 50
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
