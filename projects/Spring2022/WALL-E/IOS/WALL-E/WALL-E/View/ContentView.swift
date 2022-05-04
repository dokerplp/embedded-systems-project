//
//  ContentView.swift
//  WALL-E
//
//  Created by dokerplp on 4/26/22.
//

import SwiftUI
import AVKit

struct Video: View {
    @Binding public var player: AVPlayer
    @Binding public var videoUrl: String
    
    var body: some View {
        VideoPlayer(player: player)
            .onAppear() {
                player = AVPlayer(url: URL(string: videoUrl)!)
            }
    }
}

struct ContentView: View {
    @State private var host = "172.28.27.194"
    @State private var port = "2113"
    @State private var player = AVPlayer()
    @State private var videoUrl: String = "https://vkvd148.mycdn.me/video.m3u8?srcIp=77.234.205.3&expires=1652117853619&srcAg=SAFARI_MAC&fromCache=1&ms=45.136.21.150&mid=1399293093983&type=4&sig=NAEobb5YRfY&ct=8&urls=185.226.53.204&clientType=13&cmd=videoPlayerCdn&id=665679628895"
    
    
    @State private var client: Client = Client()
    @State private var car: Car = Car()
    @State private var settings: Settings = Settings()
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            if (client.isConnected()) {
                Video(player: $player, videoUrl: $videoUrl)
                CarControlView(client: $client, car: $car, settings: $settings)
            } else {
                ConnectView(client: $client, host: $host, port: $port)
            }
        }
        .onAppear {
                    UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation") // Forcing the rotation to portrait
                    AppDelegate.orientationLock = .landscape // And making sure it stays that way
                }.onDisappear {
                    AppDelegate.orientationLock = .all // Unlocking the rotation when leaving the view
                }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
