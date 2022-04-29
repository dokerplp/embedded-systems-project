//
//  ControlView.swift
//  WALL-E
//
//  Created by dokerplp on 4/26/22.
//

import SwiftUI

struct ControlVIew: View {
    
    @Binding var client: Client
    @Binding var car: Car
    @Binding var settings: Settings
    
    @State var viewState = CGSize.zero
    
    var body: some View {
        HStack {
            VStack {
                BatteryView(settings: $settings)
                Spacer()
            }
            Spacer()
            VStack (alignment: .leading) {
                Spacer()
                ZStack {
                    ActionStickView(client: $client, car: $car, settings: $settings)
                }
            }
        }
    }
}


struct ControlVIew_Previews: PreviewProvider {
    static var previews: some View {
        ControlVIew(client: .constant(Client()), car: .constant(Car()), settings: .constant(Settings()))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
