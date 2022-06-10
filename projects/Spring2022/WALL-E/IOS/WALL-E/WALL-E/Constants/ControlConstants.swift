//
//  ControlConstants.swift
//  WALL-E
//
//  Created by dokerplp on 4/26/22.
//

import SwiftUI


///`ScreenConstants` describes the parameters of the user's device
struct ScreenConstants {
    public static let SCREEN_WIDTH = UIDevice.current.orientation.isPortrait ?  UIScreen.main.bounds.width : UIScreen.main.bounds.height
    public static let SCREEN_HEIGHT = UIDevice.current.orientation.isPortrait ?  UIScreen.main.bounds.height : UIScreen.main.bounds.width
    public static let SCREEN_SIZE = UIScreen.main.bounds.size
}

///`ControlViewConstants` describes the size of the controls on `StickControlView` and `CarControlView`
struct ControlViewConstants {
    public static let BORDER_SIZE = ScreenConstants.SCREEN_WIDTH * 0.5
    public static let STICK_SIZE = BORDER_SIZE * 0.2
    public static let MAX_RADIUS = (BORDER_SIZE - STICK_SIZE) / 2
}

///`ConnectViewConstants` describes the size of the `ConnectView`
struct ConnectViewConstants {
    public static let DATA_FIELD_SIZE = max(ScreenConstants.SCREEN_WIDTH * 0.9, 500)
    public static let BUTTON_WIDTH = min(ScreenConstants.SCREEN_WIDTH * 0.4, 200)
    public static let BUTTON_HEIGHT = BUTTON_WIDTH / 2
    public static let BUTTON_RADIUS = 100
}

///`BatteryViewConstants` describes the size of the `BatteryView`
struct BatteryViewConstants {
    public static let BATTERY_WIDTH = min(ScreenConstants.SCREEN_WIDTH * 0.3, 150)
    public static let BATTERY_HEIGHT = min(ScreenConstants.SCREEN_WIDTH * 0.12, 75)
}

///`CarControlViewConstants` describes the size of the `CarElementsView`
struct CarControlViewConstants {
    public static let WHEEL_SIZE = ScreenConstants.SCREEN_WIDTH * 0.04
    public static let BREAK_PEDAL_WIDTH = ControlViewConstants.BORDER_SIZE * 0.6
    public static let BREAK_PEDAL_HEIGHT = ControlViewConstants.BORDER_SIZE * 0.6
    public static let GAZ_PEDAL_WIDTH = ControlViewConstants.BORDER_SIZE * 0.6
    public static let GAZ_PEDAL_HEIGHT = ControlViewConstants.BORDER_SIZE * 0.3
    public static let TRANSMISSION_SIZE = ControlViewConstants.BORDER_SIZE * 0.25
    public static let SPEEDOMETER_SIZE = ScreenConstants.SCREEN_WIDTH * 0.25
    public static let LINE_WIDTH = ControlViewConstants.BORDER_SIZE * 0.02
}
