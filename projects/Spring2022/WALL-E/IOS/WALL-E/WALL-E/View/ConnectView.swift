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
    
    var body: some View {
        VStack {
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
            .textFieldStyle(
                CustomFieldStyle()
            )
            .frame(width: ScreenConstants.SCREEN_WIDTH * 0.9)
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
                .frame(width: 150, height: 150)
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
    
    var body: some View {
        VStack {
            DataView(host: $host, port: $port)
            ButtonView(host: $host, port: $port, client: $client)
        }
    }
}

struct ConnectView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectView(client: .constant(Client()), host: .constant("127.0.0.1"), port: .constant("2113"))
            .previewInterfaceOrientation(.landscapeRight)
        ConnectView(client: .constant(Client()), host: .constant("127.0.0.1"), port: .constant("2113"))
            .preferredColorScheme(.dark)
    }
}
