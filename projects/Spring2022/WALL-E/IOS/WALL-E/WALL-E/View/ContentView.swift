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
    
    @State private var camera: Camera = .front
    @State private var fcamera: String = "http://188.134.71.123:8081/"
    @State private var bcamera: String = "http://188.134.71.123:8082/"
    
    
    @State private var client: Client = Client()
    @State private var car: Car = Car()
    @State private var settings: Settings = Settings()
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            if (client.isConnected()) {
                
                CameraView(camera: $camera, fcamera: $fcamera, bcamera: $bcamera)
                
                CarControlView(client: $client, car: $car, settings: $settings, camera: $camera)
            } else {
                ConnectView(client: $client, host: $host, port: $port, fcamera: $fcamera, bcamera: $bcamera)
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
