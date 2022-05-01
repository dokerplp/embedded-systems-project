//
//  CarControlView.swift
//  WALL-E
//
//  Created by dokerplp on 4/30/22.
//

import Foundation
import SwiftUI
import simd

struct CarControlView: View {
    
    @Binding public var client: Client
    @Binding public var car: Car
    @Binding public var settings: Settings
    
    @State var viewState = CGSize.zero
    
    @State private var speed: Double = 0.0
    @State private var timer: Timer?
    @State var isLongPressing = false
    
    @State var transmission: TransmissionView.TransmissionType = .drive
    
    func getPower(charge: String) -> Int32 {
        guard let battery = Int32(charge) else { return -1 }
        return battery > 100 ? 100 : battery < 0 ? 0 : battery
    }
    
    func onChanged(sx: Double, sy: Double, x: Double, y: Double, speed: Double, transmission: TransmissionView.TransmissionType) {
        let _x = x - ControlViewConstants.BORDER_SIZE / 2
        let _y = y - ControlViewConstants.BORDER_SIZE / 2
        
        let _sx = sx - ControlViewConstants.BORDER_SIZE / 2
        let _sy = sy - ControlViewConstants.BORDER_SIZE / 2
        
        let angle = atan2(_y, _x) * 180 / Double.pi
        let sangle = atan2(_sy, _sx) * 180 / Double.pi
        
 
        let rotate = angle - sangle
        let speed = transmission == .reverse ? -speed :
        transmission == .parking ? 0.0 : speed
    
        if (rotate >= -100 && rotate <= 100) {
            viewState.width = rotate
        }
        
        car.setCarParam(x: viewState.width / 100, y: speed / 100)

        guard let power = client.write(dir: car.getDirection(), speed: car.getSpeed()) else { return }
        
        let batteries = power.components(separatedBy: " ")
        let charge1 = getPower(charge: batteries[0])
        let charge2 = getPower(charge: batteries[1])

        settings.battery1 = charge1 != -1 ? charge1 : settings.battery1
        settings.battery2 = charge2 != -1 ? charge2 : settings.battery1
    }
    
    func changeSpeed(i: Int) {
        self.isLongPressing = true
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
            if ((i > 0 && self.speed < 100) || (i < 0 && self.speed > 0)) {
                self.speed = self.speed + Double(i)
            }
        })
    }
    
    var body: some View {
        
        HStack {
            
            VStack {
                HStack {
                    BatteryView(settings: $settings)
                        .padding()
                    Spacer()
                }
                Spacer()
                HStack {
                    VStack {
                        Spacer()
                        Button(
                            action: {
                                if(self.isLongPressing){
                                    self.isLongPressing.toggle()
                                    self.timer?.invalidate()
                                }
                            }, label: {
                                GazPedalView()
                                    .padding()
                            }
                        )
                        .simultaneousGesture(
                            LongPressGesture()
                                .onEnded { _ in
                                    changeSpeed(i: -5)
                        })
                    }
                    VStack {
                        Spacer()
                        Button(
                            action: {
                                if(self.isLongPressing){
                                    self.isLongPressing.toggle()
                                    self.timer?.invalidate()
                                }
                            }, label: {
                                BrakePedalView()
                                    .padding()
                            }
                        )
                        .simultaneousGesture(
                            LongPressGesture()
                                .onEnded { _ in
                                    changeSpeed(i: 5)
                        })
                    }
                    Spacer()
                }
            }

            Spacer()
            
            
            VStack {
                
                HStack {
                    Spacer()
                    Button(action: {
                        self.transmission = self.transmission == .drive ? .reverse :
                            self.transmission == .reverse
                        ? .parking : .drive
                    }) {
                        TransmissionView(transmission: $transmission)
                            .padding()
                    }
                }
              
                Spacer()
                
                HStack {
                    Spacer()
                    WheelView()
                        .padding()
                        .rotationEffect(Angle(degrees: Double(viewState.width)))
                                    .gesture(
                                        DragGesture().onChanged{ value in
                                            DispatchQueue.global(qos: .background).async {
                                            onChanged(sx: value.startLocation.x, sy: value.startLocation.y, x: value.location.x, y: value.location.y, speed: self.speed, transmission: transmission
                                            )
                                            }
                                        }.onEnded { value in
                                            withAnimation(.spring()) {
                                                viewState = .zero
                                            }
                                        }
                                )
                }
                            
            }
    
        }
     
    }
}

struct CarControlView_Previews: PreviewProvider {
    static var previews: some View {
        CarControlView(client: .constant(Client()), car: .constant(Car()), settings: .constant(Settings()))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
