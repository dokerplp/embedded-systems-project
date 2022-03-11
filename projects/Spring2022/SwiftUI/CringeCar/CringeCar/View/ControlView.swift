//
//  ControlView.swift
//  CringeCar
//
//  Created by dokerplp on 3/10/22.
//

import SwiftUI

struct BorderView: View {
    
    let size: Double
    
    var body: some View {
        Circle()
            .stroke(lineWidth: 10)
            .fill(
                Color.gray
                    .opacity(0.3)
            )
            .frame(width: size, height: size)
        .padding()
    }
}

struct StickView: View {
    
    let size: Double
    
    var body: some View {
        Circle()
            .fill(
                Color.gray
            )
            .frame(width: size, height: size)
    }
    
}

struct ActionStickView: View {
    
    let borderSize: Double
    let stickSize: Double
    
    let maxRadius: Double
    
    init() {
        self.borderSize = UIScreen.screenWidth * 0.4
        self.stickSize = borderSize * 0.2
        self.maxRadius = (borderSize - stickSize) / 2
    }
    
    @State var viewState = CGSize.zero
    
    func getAngle(x: Double, y: Double) -> Double {
        return atan2(y, x)
    }
    
    func getDist(x: Double, y: Double) -> Double {
        return sqrt(pow(abs(x), 2) + pow(abs(y), 2))
    }
    
    func getWidth(dist: Double, angle: Double) -> Double {
        let d = dist < maxRadius ? dist : maxRadius
        return d * cos(angle)
    }
    
    func getHeight(dist: Double, angle: Double) -> Double {
        let d = dist < maxRadius ? dist : maxRadius
        return d * sin(angle)
    }
 
    var body: some View {
        BorderView(size: borderSize)
        StickView(size: stickSize)
            .offset(x: viewState.width, y: viewState.height)
            .gesture(
                DragGesture().onChanged { value in
                    
                    let dist = getDist(x: value.translation.width, y: -1 * value.translation.height)
                    let angle = getAngle(x: value.translation.width, y: value.translation.height)
        
                    viewState = CGSize(
                        width: getWidth(dist: dist, angle: angle),
                        height: getHeight(dist: dist, angle: angle)
                    )

                }
                .onEnded { value in
                    withAnimation(.spring()) {
                        viewState = .zero
                    }
                }
            )
    }
}

struct ButtonView: View {
    
    @Binding var car: Car
    @State var viewState = CGSize.zero
    
    var body: some View {
        HStack {
            Spacer()
            VStack (alignment: .leading) {
                Spacer()
                ZStack {
                    ActionStickView()
                }
            }
        }
    }
}

struct ControlVIew: View {
    
    private var car = Binding.constant(Car())
    
    var body: some View {
        
        HStack {
            ButtonView(car: car)
        }
    }
}

struct ControlVIew_Previews: PreviewProvider {
    static var previews: some View {
        ControlVIew()
    }
}
