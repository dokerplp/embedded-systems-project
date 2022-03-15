//
//  ContentView.swift
//  CringeCar
//
//  Created by dokerplp on 3/10/22.
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
