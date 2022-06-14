//
//  ContentView.swift
//  WALL-E
//
//  Created by dokerplp on 4/26/22.
//

import SwiftUI
import AVKit

///`ContentView` is the main View that returns ``CameraView`` and ``CarControlView`` or ``ConnectView`` if client isn't connected
struct ContentView: View {
    @State private var host = "172.20.10.4"
    @State private var port = "25565"
    
    @State private var camera: Camera = .front
    @State private var fcamera: String = "http://172.20.10.4:8081"
    @State private var bcamera: String = "http://172.20.10.4:8082"
    
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
            
            DispatchQueue.global(qos: .background).async {
                while true {
                    if client.isConnected() {
                        let speed = car.transmission == .reverse ? -car.speed: car.speed
                        guard let power = client.write(dir: car.direction, speed: speed) else {continue}
                        settings.setCharge(charge: power)
                    }
                }
            }
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
