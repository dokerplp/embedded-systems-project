//
//  ControlConstants.swift
//  WALL-E
//
//  Created by dokerplp on 4/26/22.
//

import SwiftUI

struct ScreenConstants {
    public static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    public static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    public static let SCREEN_SIZE = UIScreen.main.bounds.size
}

struct ControlViewConstants {
    public static let BORDER_SIZE = ScreenConstants.SCREEN_WIDTH * 0.35
    public static let STICK_SIZE = BORDER_SIZE * 0.2
    public static let MAX_RADIUS = (BORDER_SIZE - STICK_SIZE) / 2
}

struct ConnectViewConstants {
    public static let DATA_FIELD_SIZE = ScreenConstants.SCREEN_WIDTH * 0.9
    public static let BUTTON_SIZE = ScreenConstants.SCREEN_WIDTH * 0.2
}

struct BatteryViewConstants {
    public static let BATTERY_WIDTH = ScreenConstants.SCREEN_WIDTH * 0.1
    public static let BATTERY_HEIGHT = ScreenConstants.SCREEN_WIDTH * 0.05
}

struct CarControlViewConstants {
    public static let WHEEL_SIZE = ScreenConstants.SCREEN_WIDTH * 0.04
    public static let BREAK_PEDAL_SIZE = 0
    public static let GAZ_PEDAL_SIZE = 0
    public static let TRANSMISSION_SIZE = ScreenConstants.SCREEN_WIDTH * 0.1
    public static let SPEEDOMETER_SIZE = ScreenConstants.SCREEN_WIDTH * 0.13
}
