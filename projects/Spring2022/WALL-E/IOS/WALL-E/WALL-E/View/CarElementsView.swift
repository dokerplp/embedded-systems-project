//
//  CarControlView.swift
//  WALL-E
//
//  Created by dokerplp on 4/30/22.
//

import Foundation
import SwiftUI

///The element of `WheelView`
struct CustomCircle: Shape {
    public let radius: Double
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: radius, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: true)
        }
    }
}

///The element of `WheelView`
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            let s = CarControlViewConstants.WHEEL_SIZE / 2
            let r = rect.maxX
            path.move(to: CGPoint(x: rect.midX - s, y: rect.midY - s))
            path.addLine(to: CGPoint(x: r * 0.2, y: r * 0.28))
            path.addLine(to: CGPoint(x: r * 0.14, y: r * 0.39))
            path.addLine(to: CGPoint(x: rect.midX - s, y: rect.midY + s))
            path.addLine(to: CGPoint(x: rect.midX - s, y: rect.midY - s))
            
            path.move(to: CGPoint(x: rect.midX + s, y: rect.midY - s))
            path.addLine(to: CGPoint(x: r * 0.8, y: r * 0.28))
            path.addLine(to: CGPoint(x: r * 0.86, y: r * 0.39))
            path.addLine(to: CGPoint(x: rect.midX + s, y: rect.midY + s))
            path.addLine(to: CGPoint(x: rect.midX + s, y: rect.midY - s))
            
            path.move(to: CGPoint(x: rect.midX - s, y: rect.midY + s))
            path.addLine(to: CGPoint(x: rect.midX - s * 1.5, y: r * 0.9))
            path.addLine(to: CGPoint(x: rect.midX + s * 1.5, y: r * 0.9))
            path.addLine(to: CGPoint(x: rect.midX + s, y: rect.midY + s))
            
        }
    }
}

///Wheel for car control
struct WheelView: View {
    var body: some View {
        ZStack {
            Triangle()
                .fill(Color("WheelTriangle"))
                .frame(width: ControlViewConstants.BORDER_SIZE, height: ControlViewConstants.BORDER_SIZE)
            
            CustomCircle(radius: ControlViewConstants.MAX_RADIUS)
                .stroke(Color("WheelBorder"), lineWidth: CarControlViewConstants.WHEEL_SIZE)
            
            
            CustomCircle(radius: CarControlViewConstants.WHEEL_SIZE * 0.75)
                .fill(Color("WheelBorder"))
        }
        .frame(width: ControlViewConstants.BORDER_SIZE, height: ControlViewConstants.BORDER_SIZE)
    }
}

/// The element of `GazPedalView`
struct GazPedal: Shape {
    func path(in rect: CGRect) -> Path {
        Path { p in
            
            let r = rect.maxX
            
            let rad = CGFloat(r * 0.05)
            
            let p1 = CGPoint(x: 0, y: 0)
            let p2 = CGPoint(x: r, y: 0)
            let p3 = CGPoint(x: r * 0.8, y: r * 0.5)
            let p4 = CGPoint(x: r * 0.2, y: r * 0.5)
            
            let path = CGMutablePath()
            path.move(to: p1)
            path.addArc(tangent1End: p1, tangent2End: p2, radius: rad)
            path.addArc(tangent1End: p2, tangent2End: p3, radius: rad)
            path.addArc(tangent1End: p3, tangent2End: p4, radius: rad)
            path.addArc(tangent1End: p4, tangent2End: p1, radius: rad)
            path.addArc(tangent1End: p1, tangent2End: p2, radius: rad)
            path.closeSubpath()
            
            p.addPath(Path(path))
            
        }
    }
}

/// The element of `GazPedalView`
struct GazLines: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            
            let r = rect.maxX
            
            path.move(to: CGPoint(x: r * 0.2, y: r * 0.1))
            path.addLine(to: CGPoint(x: r * 0.8, y: r * 0.1))
            
            path.move(to: CGPoint(x: r * 0.25, y: r * 0.2))
            path.addLine(to: CGPoint(x: r * 0.75, y: r * 0.2))
            
            path.move(to: CGPoint(x: r * 0.3, y: r * 0.3))
            path.addLine(to: CGPoint(x: r * 0.7, y: r * 0.3))
            
            path.move(to: CGPoint(x: r * 0.35, y: r * 0.4))
            path.addLine(to: CGPoint(x: r * 0.65, y: r * 0.4))
        }
    }
}

/// Gaz pedal - used for increasing car speed
struct GazPedalView: View {
    
    var body: some View {
        ZStack {
            GazPedal()
                .fill(Color("WheelBorder"))
                .frame(width: CarControlViewConstants.GAZ_PEDAL_WIDTH, height: CarControlViewConstants.GAZ_PEDAL_HEIGHT, alignment: .top)
            
            GazLines()
                .stroke(style: StrokeStyle(lineWidth: CarControlViewConstants.LINE_WIDTH, lineCap: .round))
                .foregroundColor(Color("WheelTriangle"))
                .frame(width: CarControlViewConstants.GAZ_PEDAL_WIDTH, height: CarControlViewConstants.GAZ_PEDAL_HEIGHT, alignment: .top)
        }
    }
}

///The element of `BrakePedalView`
struct BrakePedal: Shape {
    func path(in rect: CGRect) -> Path {
        Path { p in
            
            let r = rect.maxX
            
            let rad = CGFloat(r * 0.05)
            
            let p1 = CGPoint(x: r * 0.25, y: 0)
            let p2 = CGPoint(x: r * 0.5, y: 0)
            let p3 = CGPoint(x: r * 0.35, y: r)
            let p4 = CGPoint(x: 0, y: r)
            
            let path = CGMutablePath()
            path.move(to: p1)
            path.addArc(tangent1End: p1, tangent2End: p2, radius: rad)
            path.addArc(tangent1End: p2, tangent2End: p3, radius: rad)
            path.addArc(tangent1End: p3, tangent2End: p4, radius: rad)
            path.addArc(tangent1End: p4, tangent2End: p1, radius: rad)
            path.addArc(tangent1End: p1, tangent2End: p2, radius: rad)
            path.closeSubpath()
            
            p.addPath(Path(path))
            
        }
    }
}

///The element of `BrakePedalView`
struct BrakeLines: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            
            let r = rect.maxX
            
            path.move(to: CGPoint(x: r * 0.3, y: r * 0.1))
            path.addLine(to: CGPoint(x: r * 0.4, y: r * 0.1))
            
            path.move(to: CGPoint(x: r * 0.27, y: r * 0.2))
            path.addLine(to: CGPoint(x: r * 0.39, y: r * 0.2))
            
            path.move(to: CGPoint(x: r * 0.25, y: r * 0.3))
            path.addLine(to: CGPoint(x: r * 0.38, y: r * 0.3))
            
            path.move(to: CGPoint(x: r * 0.23, y: r * 0.4))
            path.addLine(to: CGPoint(x: r * 0.37, y: r * 0.4))
            
            path.move(to: CGPoint(x: r * 0.21, y: r * 0.5))
            path.addLine(to: CGPoint(x: r * 0.36, y: r * 0.5))
            
            path.move(to: CGPoint(x: r * 0.19, y: r * 0.6))
            path.addLine(to: CGPoint(x: r * 0.34, y: r * 0.6))
            
            path.move(to: CGPoint(x: r * 0.17, y: r * 0.7))
            path.addLine(to: CGPoint(x: r * 0.32, y: r * 0.7))
            
            path.move(to: CGPoint(x: r * 0.15, y: r * 0.8))
            path.addLine(to: CGPoint(x: r * 0.3, y: r * 0.8))
            
            path.move(to: CGPoint(x: r * 0.13, y: r * 0.9))
            path.addLine(to: CGPoint(x: r * 0.27, y: r * 0.9))
        }
    }
}

/// Brake pedal - used for decreasing car speed
struct BrakePedalView: View {
    var body: some View {
        ZStack {
            BrakePedal()
                .fill(Color("WheelBorder"))
                .frame(width: CarControlViewConstants.BREAK_PEDAL_WIDTH, height: CarControlViewConstants.BREAK_PEDAL_HEIGHT)
            BrakeLines()
                .stroke(style: StrokeStyle(lineWidth: CarControlViewConstants.LINE_WIDTH, lineCap: .round))
                .foregroundColor(Color("WheelTriangle"))
                .frame(width: CarControlViewConstants.BREAK_PEDAL_WIDTH, height: CarControlViewConstants.BREAK_PEDAL_HEIGHT)
            
        }
    }
}

///The element of `TransmissionView`
struct CircleWithLetter: View {
    
    public let color: Color
    public let letter: String
    
    var body: some View {
        
        Circle()
            .fill(color)
            .overlay(
                Circle()
                    .stroke(lineWidth: 5)
                    .fill(
                        Color("BorderStick")
                    ).overlay(
                        Text(letter)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                    )
            )
        
    }
}


/// Shows car transmission
struct TransmissionView: View {
    
    @Binding public var car: Car
    
    struct TransmissionType: OptionSet {
        let rawValue: Int
        
        static let drive1 = TransmissionType(rawValue: 1)
        static let drive2 = TransmissionType(rawValue: 2)
        static let drive3 = TransmissionType(rawValue: 3)
        static let reverse = TransmissionType(rawValue: 4)
        static let parking = TransmissionType(rawValue: 5)
        
        static let all: TransmissionType = [.drive1, .parking, .reverse]
    }
    
    var body: some View {
        VStack {
            switch car.getTransmission() {
            case .drive1:
                CircleWithLetter(color: .green, letter: "D")
            case .reverse:
                CircleWithLetter(color: .red, letter: "R")
            default:
                CircleWithLetter(color: .blue, letter: "P")
            }
        }
        .frame(width: CarControlViewConstants.TRANSMISSION_SIZE, height: CarControlViewConstants.TRANSMISSION_SIZE)
    }
}

/// Speedometer
struct SpeedometerView: View {
    
    @Binding var car: Car
    
    var body: some View {
        Circle()
            .fill(
                Color.gray
            )
            .overlay(
                Circle()
                    .stroke(lineWidth: 5)
                    .fill(
                        Color("WheelBorder")
                    )
            )
            .overlay(
                Text("\(Int(car.getSpeed()))\nmph")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
            )
    }
}
