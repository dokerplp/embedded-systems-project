//
//  StickView.swift
//  WALL-E
//
//  Created by dokerplp on 4/29/22.
//

import Foundation
import SwiftUI

///Stick border
struct BorderView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    Color("BackgroundStick")
                )
                .frame(width: ControlViewConstants.BORDER_SIZE, height: ControlViewConstants.BORDER_SIZE)
            Circle()
                .stroke(lineWidth: 10)
                .fill(
                    Color("BorderStick")
                )
                .frame(width: ControlViewConstants.BORDER_SIZE, height: ControlViewConstants.BORDER_SIZE)
        }
        .padding()
    }
}

///Stick
struct StickView: View {
    var body: some View {
        Circle()
            .fill(
                Color("Stick")
            )
            .frame(width: ControlViewConstants.STICK_SIZE, height: ControlViewConstants.STICK_SIZE)
    }
}

///This view send data to `Client` struct and makes drag animation
struct ActionStickView: View {
    @State var viewState = CGSize.zero
    
    @Binding var client: Client
    @Binding var car: Car
    @Binding var settings: Settings
    
    func getPower(charge: String) -> Int32 {
        guard let battery = Int32(charge) else { return -1 }
        return battery > 100 ? 100 : battery < 0 ? 0 : battery
    }
    
    func onChanged(w: Double, h: Double) {
        let angle = atan2(w, h)
        var d = sqrt(pow(abs(w), 2) + pow(abs(-h), 2))
        d = d < ControlViewConstants.MAX_RADIUS ? d : ControlViewConstants.MAX_RADIUS
        let w = d * sin(angle)
        let h = d * cos(angle)
        
        viewState = CGSize (width: w, height: h)
        
        car.setParam(x: w, y: -h)
        
        guard let power = client.write(dir: car.direction, speed: car.speed) else { return }
        let batteries = power.components(separatedBy: " ")
        let charge1 = getPower(charge: batteries[0])
        let charge2 = getPower(charge: batteries[1])
        
        settings.battery1 = charge1 != -1 ? charge1 : settings.battery1
        settings.battery2 = charge2 != -1 ? charge2 : settings.battery1
    }
    
    
    var body: some View {
        ZStack {
            BorderView()
            StickView()
                .offset(x: viewState.width, y: viewState.height)
                .gesture(
                    DragGesture().onChanged { value in
                        DispatchQueue.global(qos: .background).async {
                            onChanged(w: value.translation.width, h: value.translation.height)
                        }
                    }
                        .onEnded { value in
                            withAnimation(.spring()) {
                                viewState = .zero
                            }
                        }
                )
        }
    }
}
