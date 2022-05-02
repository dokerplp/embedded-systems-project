//
//  CarControlView.swift
//  WALL-E
//
//  Created by dokerplp on 4/30/22.
//

import Foundation
import SwiftUI
import simd

struct ActionWheelView: View {
    
    @Binding public var client: Client
    @Binding public var car: Car
    @Binding public var settings: Settings
    
    @Binding public var speed: Double
    @Binding public var transmission: TransmissionView.TransmissionType
    
    @State private var viewState = CGSize.zero
    
    
    func getPower(charge: String) -> Int32 {
        guard let battery = Int32(charge) else { return -1 }
        return battery > 100 ? 100 : battery < 0 ? 0 : battery
    }
        
    func calcRotate(sx: Double, sy: Double, x: Double, y: Double) -> Double {
        let _x = x - ControlViewConstants.BORDER_SIZE / 2
        let _y = y - ControlViewConstants.BORDER_SIZE / 2
        
        let _sx = sx - ControlViewConstants.BORDER_SIZE / 2
        let _sy = sy - ControlViewConstants.BORDER_SIZE / 2
    
        let angle = atan2(_y, _x) * 180 / Double.pi
        let sangle = atan2(_sy, _sx) * 180 / Double.pi
    
        
        print("\(angle) \(sangle)")
        
        let rotate = angle - sangle
        
        if (sangle < -70 && angle > 70) {
            return rotate - 360
        } else if (angle < -70 && sangle > 70) {
            return rotate + 360
        } else {
            return rotate
        }
    }
    
    func onChanged(sx: Double, sy: Double, x: Double, y: Double, speed: Double, transmission: TransmissionView.TransmissionType) {
        
        let rotate = calcRotate(sx: sx, sy: sy, x: x, y: y)
        
        let speed = transmission == .reverse ? -speed :
        transmission == .parking ? 0.0 : speed
        
        print(rotate)
        
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
    
    
    var body: some View {
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

struct ActionTransmissionView: View {
    
    @Binding public var speed: Double
    @Binding public var transmission: TransmissionView.TransmissionType
    
    var body: some View {
        Button(action: {
            speed = 0
            self.transmission = self.transmission == .drive ? .reverse :
                self.transmission == .reverse
            ? .parking : .drive
        }) {
            TransmissionView(transmission: $transmission)
                .padding()
        }
    }
}

struct ActionPedalsView: View {

    @Binding public var speed: Double
    @Binding public var transmission: TransmissionView.TransmissionType
    
    @State private var timer: Timer?
    @State private var isLongPressing = false
    
    func changeSpeed(i: Int) {
        if (transmission != .parking) {
            self.isLongPressing = true
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                let s = self.speed + Double(i)
                self.speed = s > 100 ? 100 : s < 0 ? 0 : s
            })
        }
    }
    
    var body: some View {
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
}

struct ActionSpeedometerView: View {
    
    @Binding var speed: Double
    
    var body: some View {
        SpeedometerView(speed: $speed)
            .frame(width: 150, height: 150)
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
    
    @State private var transmission: TransmissionView.TransmissionType = .drive
    @State private var speed: Double = 0.0
    
    @State private var decreaseTimer: Timer?
    
    var body: some View {
        VStack {
            HStack {
                ActionBatteryView(settings: $settings)
                Spacer()
                ActionSpeedometerView(speed: $speed)
                Spacer()
                ActionTransmissionView(speed: $speed, transmission: $transmission)
            }
            Spacer()
            HStack {
                VStack {
                    Spacer()
                    ActionPedalsView(speed: $speed, transmission: $transmission)
                }
                VStack {
                    Spacer()
                    ActionWheelView(client: $client, car: $car, settings: $settings, speed: $speed, transmission: $transmission)
                }
            }
        }
        .onLoad {
            self.decreaseTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                let s = self.speed + Double(-1)
                self.speed = s > 100 ? 100 : s < 0 ? 0 : s
            })
        }
    }
}

struct CarControlView_Previews: PreviewProvider {
    static var previews: some View {
        CarControlView(client: .constant(Client()), car: .constant(Car()), settings: .constant(Settings()))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
