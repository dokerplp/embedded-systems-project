//
//  ContentView.swift
//  WALL-E
//
//  Created by dokerplp on 4/26/22.
//

import SwiftUI
import AVKit

struct Video: View {
    
    @Binding var player: AVPlayer
    @Binding var videoUrl: String
    
    var body: some View {
        VideoPlayer(player: player)
                        .onAppear() {
                                player = AVPlayer(url: URL(string: videoUrl)!)
                        }
    }
}

struct ContentView: View {
    
    @State private var host = "192.168.0.24"
    @State private var port = "2113"
    @State private var player = AVPlayer()
    @State private var videoUrl: String = "https://bit.ly/3vzeFIJ"
    
    @State var client: Client = Client()
    @State var car: Car = Car()
    
    var body: some View {
        ZStack {
            Color.black
            if (client.isConnected()) {
                Video(player: $player, videoUrl: $videoUrl)
                ControlVIew(client: $client, car: $car)
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
