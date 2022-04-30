//
//  CarControlView.swift
//  WALL-E
//
//  Created by dokerplp on 4/30/22.
//

import Foundation
import SwiftUI

struct CarControlView: View {
    
    @Binding public var client: Client
    @Binding public var car: Car
    @Binding public var settings: Settings
    
    var body: some View {
        
        HStack {
            
            VStack {
                HStack {
                    BatteryView(settings: $settings)
                        .padding()
                    Spacer()
                }
                Spacer()
                HStack {
                    VStack {
                        Spacer()
                        Button(
                            action: {
                                print(1)
                            }
                        ) {
                            GazPedalView()
                                .padding()
                        }
                    }
                    VStack {
                        Spacer()
                        Button(
                            action: {
                                print(2)
                            }
                        ) {
                            BrakePedalView()
                                .padding()
                        }
                    }
                    Spacer()
                }
            }
            
    
        
            Spacer()
            VStack {
                Spacer()
                WheelView()
                    .padding()
            }
    
        }
     
    }
}

struct CarControlView_Previews: PreviewProvider {
    static var previews: some View {
        CarControlView(client: .constant(Client()), car: .constant(Car()), settings: .constant(Settings()))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
