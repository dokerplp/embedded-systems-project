//
//  BatteryView.swift
//  WALL-E
//
//  Created by dokerplp on 4/29/22.
//

import Foundation
import SwiftUI

struct OneBatteryView: View {
    
    @Binding public var battery: Int32
    
    var body: some View {
        Image(systemName: "battery.100")
            .resizable()
            .foregroundColor(
                battery > 50 ? Color.green :
                    battery > 20 ? Color.yellow :
                    Color.red
            )
            .frame(width: BatteryViewConstants.BATTERY_WIDTH, height: BatteryViewConstants.BATTERY_HEIGHT)
            .overlay(
                Text("\(battery) %")
                    .font(.subheadline)
                    .fontWeight(.black)
                    .foregroundColor(Color.white)
                    .padding()
            )
    }
}

struct BatteryView: View {
    @Binding public var settings: Settings
    
    var body: some View {
        VStack {
            OneBatteryView(battery: $settings.battery1)
            OneBatteryView(battery: $settings.battery2)
        }
    
    }
}
