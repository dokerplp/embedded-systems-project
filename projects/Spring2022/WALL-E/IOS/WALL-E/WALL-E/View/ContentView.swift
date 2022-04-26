//
//  ContentView.swift
//  WALL-E
//
//  Created by dokerplp on 4/26/22.
//

import SwiftUI
import AVKit

struct ContentView: View {
    
    let videoUrl: String = "https://bit.ly/swswift"
    
    @State var car = Car()
    
    var body: some View {
        ZStack {
            VideoPlayer(player: AVPlayer(url:  URL(string: videoUrl)!))
                .frame(height: 400)
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
