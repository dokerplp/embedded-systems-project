//
//  ContentView.swift
//  WALL-E
//
//  Created by dokerplp on 4/26/22.
//

import SwiftUI
import AVKit

struct Direct: View {
    
    @Binding var car: Car
    
    var body: some View {
        Rectangle()
            .fill(
                Color.blue
            )
            .frame(width: 500, height: 100)
            .overlay(Text("Direction: \(car.getDirection()) Speed:  \(car.getSpeed())")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.white))
            .padding(.bottom, 500.0)
    }
}

struct ContentView: View {
    
    @State var player = AVPlayer()
    let videoUrl: String = "https://vkvd148.mycdn.me/video.m3u8?cmd=videoPlayerCdn&expires=1651239686613&srcIp=188.243.183.252&srcAg=SAFARI_MAC&ms=45.136.21.150&mid=1399293093983&type=4&sig=RbgEKwruQQE&ct=8&urls=185.226.53.204&clientType=13&id=665679628895"
    

    @State var car = Car()
    
    var body: some View {
        ZStack {
            VideoPlayer(player: player)
                            .onAppear() {
                                    player = AVPlayer(url: URL(string: videoUrl)!)
                            }
            Direct(car: $car)
            ControlVIew(car: $car)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
