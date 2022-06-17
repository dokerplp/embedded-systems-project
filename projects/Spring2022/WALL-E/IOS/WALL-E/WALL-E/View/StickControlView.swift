//
//  ControlView.swift
//  WALL-E
//
//  Created by dokerplp on 4/26/22.
//

import SwiftUI

///`ControlView` is the stick control for car
/// - Remark: now deprecarted
struct ControlView: View {
    @Binding public var client: Client
    @Binding public var car: Car
    @Binding public var settings: Settings
    
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


struct ControlView_Previews: PreviewProvider {
    static var previews: some View {
        ControlView(client: .constant(Client()), car: .constant(Car()), settings: .constant(Settings()))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
