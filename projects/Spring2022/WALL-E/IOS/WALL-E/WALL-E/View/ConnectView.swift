//
//  ConnectView.swift
//  WALL-E
//
//  Created by dokerplp on 4/28/22.
//

import Foundation
import SwiftUI

struct CustomFieldStyle: TextFieldStyle {
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(Color.gray)
            .cornerRadius(20)
            .shadow(color: .gray, radius: 10)
    }
}

struct DataView: View {
    @Binding public var host: String
    @Binding public var port: String
    @Binding public var fcamera: String
    @Binding public var bcamera: String
    
    var body: some View {
        VStack {
                HStack {
                    TextField(
                        "Host: ",
                        text: $host
                    )
                    .disableAutocorrection(true)
                    .padding()
                    
                    TextField(
                        "Port: ",
                        text: $port
                    )
                    .disableAutocorrection(true)
                    .padding()
                }
                
                HStack {
                    TextField(
                        "Front camera: ",
                        text: $fcamera
                    )
                    .disableAutocorrection(true)
                    .padding()
                    
                    TextField(
                        "Back camera: ",
                        text: $bcamera
                    )
                    .disableAutocorrection(true)
                    .padding()
                }

            }
            .textFieldStyle(
                CustomFieldStyle()
            )
            .frame(width: ConnectViewConstants.DATA_FIELD_SIZE)
    }
}

struct ButtonView: View {
    @Binding public var host: String
    @Binding public var port: String
    @Binding public var client: Client
    
    var body: some View {
        Button(
            action: {
                guard let p = Int32(port) else {return}
                client.connect(host: host, port: p)
            }
        ) {
            Circle()
                .fill(
                    Color.green
                )
                .frame(width: ConnectViewConstants.BUTTON_SIZE, height: ConnectViewConstants.BUTTON_SIZE)
                .overlay(
                    Text("Connect")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(Color.white)
                    
                )
                .shadow(color: .gray, radius: 30)
                .padding()
        }
    }
}

struct ConnectView: View {
    @Binding public var client: Client
    @Binding public var host: String
    @Binding public var port: String
    @Binding public var fcamera: String
    @Binding public var bcamera: String
    
    var body: some View {
        VStack {
            Spacer()
            DataView(host: $host, port: $port, fcamera: $fcamera, bcamera: $bcamera)
            ButtonView(host: $host, port: $port, client: $client)
            Spacer()
        }
    }
}

struct ConnectView_Previews: PreviewProvider {
    static var previews: some View {
    
        ConnectView(client: .constant(Client()), host: .constant("127.0.0.1"), port: .constant("2113"), fcamera: .constant("127.0.0.1"), bcamera: .constant("127.0.0.1"))
            .preferredColorScheme(.dark)
            .previewInterfaceOrientation(.landscapeRight)
    }
}
