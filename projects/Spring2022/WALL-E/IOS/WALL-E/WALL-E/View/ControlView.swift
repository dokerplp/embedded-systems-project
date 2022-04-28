//
//  ControlView.swift
//  WALL-E
//
//  Created by dokerplp on 4/26/22.
//

import SwiftUI

struct BorderView: View {
    
    let size = ControlViewConstants.BORDER_SIZE
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    Color("BackgroundStick")
                )
                .frame(width: size, height: size)
            Circle()
                .stroke(lineWidth: 10)
                .fill(
                    Color("BorderStick")
                )
            .frame(width: size, height: size)
        }
        .padding()
        
    }
}

struct StickView: View {
    
    let size = ControlViewConstants.STICK_SIZE
    
    var body: some View {
        Circle()
            .fill(
                Color("Stick")
            )
            .frame(width: size, height: size)
    }
}

struct ActionStickView: View {

    @Binding var client: Client
    @Binding var car: Car
    @State var viewState = CGSize.zero
        
    let mr = ControlViewConstants.MAX_RADIUS
     
    var body: some View {
        BorderView()
        StickView()
            .offset(x: viewState.width, y: viewState.height)
            .gesture(
                DragGesture().onChanged { value in
                    var w = value.translation.width
                    var h = value.translation.height
                    let angle = atan2(w, h)
                    var d = sqrt(pow(abs(w), 2) + pow(abs(-h), 2))
                    d = d < mr ? d : mr
                    w = d * sin(angle)
                    h = d * cos(angle)

                    viewState = CGSize (width: w, height: h)
                    
                    car.go(x: w, y: -h)
                    if (car.isGo()) {
                        client.write(dir: car.getDirection(), speed: car.getSpeed())
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


struct ControlVIew: View {
    
    @Binding var client: Client
    @Binding var car: Car
    @State var viewState = CGSize.zero
    
    var body: some View {
        HStack {
            Spacer()
            VStack (alignment: .leading) {
                Spacer()
                ZStack {
                    ActionStickView(client: $client, car: $car)
                }
            }
        }
    }
}

struct ControlVIew_Previews: PreviewProvider {
    

    
    static var previews: some View {
        ControlVIew(client: .constant(Client()), car: .constant(Car()))
            .previewInterfaceOrientation(.portraitUpsideDown)
    }
}
