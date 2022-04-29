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
    public static let BORDER_SIZE = ScreenConstants.SCREEN_WIDTH * 0.4
    public static let STICK_SIZE = BORDER_SIZE * 0.2
    public static let MAX_RADIUS = (BORDER_SIZE - STICK_SIZE) / 2
}
