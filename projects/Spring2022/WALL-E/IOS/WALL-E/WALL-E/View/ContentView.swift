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
    
    @State private var host = "172.20.10.2"
    @State private var port = "2113"
    @State private var player = AVPlayer()
    @State private var videoUrl: String = "https://bit.ly/3OQ0ruC"
    
    @State private var client: Client = Client()
    @State private var car: Car = Car()
    @State private var settings: Settings = Settings()
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            if (client.isConnected()) {
                Video(player: $player, videoUrl: $videoUrl)
                ControlVIew(client: $client, car: $car, settings: $settings)
            } else {
                ConnectView(client: $client, host: $host, port: $port)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
