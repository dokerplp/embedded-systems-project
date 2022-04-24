//
//  ContentView.swift
//  WALL_E
//
//  Created by dokerplp on 4/24/22.
//

import SwiftUI

struct ContentView: View {
    @State var car = Car()
        
    var body: some View {
        ControlVIew(car: $car)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
                    .previewInterfaceOrientation(.landscapeLeft)
    }
}
