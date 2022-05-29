//
//  CarControlView.swift
//  WALL-E
//
//  Created by dokerplp on 4/30/22.
//

import Foundation
import SwiftUI
import simd


/// Allows `WheelView`  to turn and send data
struct ActionWheelView: View {
    
    @Binding public var client: Client
    @Binding public var car: Car
    @Binding public var settings: Settings
    
    @State private var viewState = CGSize.zero
    
    func calcRotate(sx: Double, sy: Double, x: Double, y: Double) -> Double {
        let _x = x - ControlViewConstants.BORDER_SIZE / 2
        let _y = y - ControlViewConstants.BORDER_SIZE / 2
        
        let _sx = sx - ControlViewConstants.BORDER_SIZE / 2
        let _sy = sy - ControlViewConstants.BORDER_SIZE / 2
        
        let angle = atan2(_y, _x) * 180 / Double.pi
        let sangle = atan2(_sy, _sx) * 180 / Double.pi
        
        let rotate = angle - sangle
        
        if (sangle < -70 && angle > 70) {
            return rotate - 360
        } else if (angle < -70 && sangle > 70) {
            return rotate + 360
        } else {
            return rotate
        }
    }
    
    func setDirection(sx: Double, sy: Double, x: Double, y: Double) {
        let rotate = calcRotate(sx: sx, sy: sy, x: x, y: y)
        if (rotate >= -100 && rotate <= 100) {
            viewState.width = rotate
        }
        car.setDirection(dir: viewState.width / 100)
    }
    
    
    var body: some View {
        WheelView()
            .padding()
            .rotationEffect(Angle(degrees: Double(viewState.width)))
            .gesture(
                DragGesture().onChanged{ value in
                    setDirection(sx: value.startLocation.x, sy: value.startLocation.y, x: value.location.x, y: value.location.y)
                }.onEnded { value in
                    withAnimation(.spring()) {
                        viewState = .zero
                        car.setDirection(dir: 0.0)
                    }
                }
            )
    }
}

struct ActionTransmissionView: View {
    
    @Binding public var car: Car
    @Binding public var camera: Camera
    
    
    var body: some View {
        
        
        VStack {
            HStack {
                Button(action: {
                    car.setSpeed(speed: 0)
                    car.setTransmission(transmission: .drive1)
                }, label: {
                    CircleWithLetter(color: .green, letter: "D1")
                        .frame(width: CarControlViewConstants.TRANSMISSION_SIZE, height: CarControlViewConstants.TRANSMISSION_SIZE)
                })
                Button(action: {
                    car.setSpeed(speed: 0)
                    car.setTransmission(transmission: .drive2)
                }, label: {
                    CircleWithLetter(color: .yellow, letter: "D2")
                        .frame(width: CarControlViewConstants.TRANSMISSION_SIZE, height: CarControlViewConstants.TRANSMISSION_SIZE)
                })
                Button(action: {
                    car.setSpeed(speed: 0)
                    car.setTransmission(transmission: .drive3)
                }, label: {
                    CircleWithLetter(color: .orange, letter: "D3")
                        .frame(width: CarControlViewConstants.TRANSMISSION_SIZE, height: CarControlViewConstants.TRANSMISSION_SIZE)
                })
            }
            HStack {
                Button(action: {
                    car.setSpeed(speed: 0)
                    car.setTransmission(transmission: .reverse)
                }, label: {
                    CircleWithLetter(color: .red, letter: "R")
                        .frame(width: CarControlViewConstants.TRANSMISSION_SIZE, height: CarControlViewConstants.TRANSMISSION_SIZE)
                })
                Button(action: {
                    car.setSpeed(speed: 0)
                    car.setTransmission(transmission: .parking)
                }, label: {
                    CircleWithLetter(color: .blue, letter: "P")
                        .frame(width: CarControlViewConstants.TRANSMISSION_SIZE, height: CarControlViewConstants.TRANSMISSION_SIZE)
                })
            }
        }
        .padding()
        
    }
}

struct ActionPedalsView: View {
    
    @Binding public var car: Car
    @State private var timer: Timer?
    @State private var isLongPressing = false
    
    func changeSpeed(i: Int) {
        if (car.getTransmission() != .parking) {
            self.isLongPressing = true
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                let s = car.getSpeed() + Double(i)
                car.setSpeed(speed: s > car.getMaxSpeed() ? car.getMaxSpeed() : s < 0 ? 0 : s)
            })
        }
    }
    
    var body: some View {
        HStack {
            VStack {
                Spacer()
                Button(
                    action: {
                        if (self.isLongPressing) {
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
                            if (!isLongPressing) {
                                changeSpeed(i: -10)
                            }
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
                            if (!isLongPressing) {
                                changeSpeed(i: 3)
                            }
                        })
            }
            Spacer()
        }
    }
}

struct ActionSpeedometerView: View {
    
    @Binding var car: Car
    
    var body: some View {
        SpeedometerView(car: $car)
            .frame(width: CarControlViewConstants.SPEEDOMETER_SIZE, height: CarControlViewConstants.SPEEDOMETER_SIZE)
            .padding()
    }
}

struct ActionBatteryView: View {
    
    @Binding public var settings: Settings
    
    var body: some View {
        BatteryView(settings: $settings)
            .padding()
    }
    
}

struct CarControlView: View {
    
    @Binding public var client: Client
    @Binding public var car: Car
    @Binding public var settings: Settings
    @Binding public var camera: Camera
    
    @State private var decreaseTimer: Timer?
    
    var body: some View {
        VStack {
            ZStack {
                ActionSpeedometerView(car: $car)
                HStack {
                    ActionBatteryView(settings: $settings)
                    Spacer()
                    ActionTransmissionView(car: $car, camera: $camera)
                }
            }
            Spacer()
            HStack {
                VStack {
                    Spacer()
                    ActionPedalsView(car: $car)
                }
                VStack {
                    Spacer()
                    ActionWheelView(client: $client, car: $car, settings: $settings)
                }
            }
        }
        .onLoad {
            self.decreaseTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                let s = car.getSpeed() - 1
                let speed = s > car.getMaxSpeed() ? car.getMaxSpeed() : s < 0 ? 0 : s
                car.setSpeed(speed: speed)
            })
        }
    }
}

struct CarControlView_Previews: PreviewProvider {
    static var previews: some View {
        CarControlView(client: .constant(Client()), car: .constant(Car()), settings: .constant(Settings()), camera: .constant(.front))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
