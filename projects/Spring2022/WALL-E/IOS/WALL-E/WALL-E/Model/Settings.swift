//
//  Settings.swift
//  WALL-E
//
//  Created by dokerplp on 4/28/22.
//

import Foundation

///`Settings` is the struct that keeps important data for app
struct Settings {
    ///Battery 1 charge
    public var battery1: Int32 = 0
    ///Battery 2 charge
    public var battery2: Int32 = 0
    
    private func getPower(charge: String) -> Int32 {
        guard let battery = Int32(charge) else { return -1 }
        return battery > 100 ? 100 : battery < 0 ? 0 : battery
    }
    
    public mutating func setCharge(charge: String) {
        let batteries = charge.components(separatedBy: "-")
        let charge1 = getPower(charge: String(batteries[0].filter { !" \n\t\r".contains($0) }))
        let charge2 = getPower(charge: String(batteries[1].filter { !" \n\t\r".contains($0) }))
        
        self.battery1 = charge1 != -1 ? charge1 : battery1
        self.battery2 = charge2 != -1 ? charge2 : battery2
    }
}
