//
//  CameraView.swift
//  WALL-E
//
//  Created by dokerplp on 5/27/22.
//

import Foundation
import SwiftUI


enum Camera {
    case front, back
}

struct CameraView: View {
    @Binding public var camera: Camera
    @Binding public var fcamera: String
    @Binding public var bcamera: String
    
    var body: some View {
        
        switch camera {
        case .front:
            WebView(type: .public, url: fcamera)
        case .back:
            WebView(type: .public, url: bcamera)
        }
        
    }
}
