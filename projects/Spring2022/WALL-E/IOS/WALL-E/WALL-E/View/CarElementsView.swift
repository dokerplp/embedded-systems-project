//
//  CarControlView.swift
//  WALL-E
//
//  Created by dokerplp on 4/30/22.
//

import Foundation
import SwiftUI

struct CustomCircle: Shape {
    public let radius: Double
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: radius, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: true)
        }
    }
}

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

struct GazPedalView: View {
    
    var body: some View {
        ZStack {
            GazPedal()
                .fill(Color("WheelBorder"))
                .frame(width: ControlViewConstants.BORDER_SIZE * 0.5, height: ControlViewConstants.BORDER_SIZE * 0.3)
            GazLines()
                .stroke(style: StrokeStyle(lineWidth: ControlViewConstants.BORDER_SIZE * 0.02, lineCap: .round))
                .foregroundColor(Color("WheelTriangle"))
                .frame(width: ControlViewConstants.BORDER_SIZE * 0.5, height: ControlViewConstants.BORDER_SIZE * 0.3)
        }
    }
}

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

struct BrakePedalView: View {
    var body: some View {
        ZStack {
            BrakePedal()
                .fill(Color("WheelBorder"))
                .frame(width: ControlViewConstants.BORDER_SIZE * 0.5, height: ControlViewConstants.BORDER_SIZE * 0.53)
            BrakeLines()
                .stroke(style: StrokeStyle(lineWidth: ControlViewConstants.BORDER_SIZE * 0.02, lineCap: .round))
                .foregroundColor(Color("WheelTriangle"))
                .frame(width: ControlViewConstants.BORDER_SIZE * 0.5, height: ControlViewConstants.BORDER_SIZE * 0.53)
            
        }
    }
}

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
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .foregroundColor(Color.white)
                    )
            )
        
    }
}

struct TransmissionView: View {
    
    @Binding public var transmission: TransmissionType
    
    struct TransmissionType: OptionSet {
        let rawValue: Int
        
        static let drive = TransmissionType(rawValue: 1)
        static let reverse = TransmissionType(rawValue: 2)
        static let parking = TransmissionType(rawValue: 3)

        static let all: TransmissionType = [.drive, .parking, .reverse]
    }
    
    var body: some View {
        VStack {
            switch transmission {
            case .drive:
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

struct SpeedometerView: View {
    
    @Binding var speed: Double
    
    var body: some View {
        Circle()
            .fill(
                Color.gray
            )
            .overlay(
                Circle()
                    .stroke(lineWidth: 10)
                    .fill(
                        Color("WheelBorder")
                    )
            )
            .overlay(
                Text("\(Int(speed))\nmph")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
            )
    }
}
