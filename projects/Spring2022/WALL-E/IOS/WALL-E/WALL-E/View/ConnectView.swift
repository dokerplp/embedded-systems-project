//
//  ConnectView.swift
//  WALL-E
//
//  Created by dokerplp on 4/28/22.
//

import Foundation
import SwiftUI


/// Custom data input
struct CustomFieldStyle: TextFieldStyle {
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(Color.gray)
            .cornerRadius(20)
            .shadow(color: .gray, radius: 10)
    }
}


/// Fields: host, port and camera adresses
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
        
                
                TextField(
                    "Port: ",
                    text: $port
                )
                .disableAutocorrection(true)
            }
            
            HStack {
                TextField(
                    "Front camera: ",
                    text: $fcamera
                )
                .disableAutocorrection(true)
        
                
                TextField(
                    "Back camera: ",
                    text: $bcamera
                )
                .disableAutocorrection(true)
        
            }
            
        }
        .textFieldStyle(
            CustomFieldStyle()
        )
        .frame(width: ConnectViewConstants.DATA_FIELD_SIZE)
    }
}


/// Connect button
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
            RoundedRectangle(cornerSize: CGSize(width: ConnectViewConstants.BUTTON_RADIUS, height: ConnectViewConstants.BUTTON_RADIUS))
                .fill(
                    Color.green
                )
                .frame(width: ConnectViewConstants.BUTTON_WIDTH, height: ConnectViewConstants.BUTTON_HEIGHT)
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


/// View for connection with server
struct ConnectView: View {
    @Binding public var client: Client
    @Binding public var host: String
    @Binding public var port: String
    @Binding public var fcamera: String
    @Binding public var bcamera: String
    
    var body: some View {
        VStack {
            DataView(host: $host, port: $port, fcamera: $fcamera, bcamera: $bcamera)
            ButtonView(host: $host, port: $port, client: $client)
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
