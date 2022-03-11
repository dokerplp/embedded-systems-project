//
//  ContentView.swift
//  CringeCar
//
//  Created by dokerplp on 3/10/22.
//

import SwiftUI

extension UIScreen {
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}



struct ContentView: View {
    
    var body: some View {
        ControlVIew()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
