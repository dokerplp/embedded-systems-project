//
//  AppConstants.swift
//  WALL_E
//
//  Created by dokerplp on 4/24/22.
//

import SwiftUI

struct ScreenConstants {
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_SIZE = UIScreen.main.bounds.size
}

struct ControlViewConstants {
    static let BORDER_SIZE = ScreenConstants.SCREEN_WIDTH * 0.4
    static let STICK_SIZE = BORDER_SIZE * 0.2
    static let MAX_RADIUS = (BORDER_SIZE - STICK_SIZE) / 2
}
