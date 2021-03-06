//
//  ViewDidLoadModifier.swift
//  WALL-E
//
//  Created by dokerplp on 5/2/22.
//

import Foundation
import SwiftUI


///This modifier allows to run some code when view is loaded
struct ViewDidLoadModifier: ViewModifier {
    
    @State private var didLoad = false
    private let action: (() -> Void)?
    
    init(perform action: (() -> Void)? = nil) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content.onAppear {
            if didLoad == false {
                didLoad = true
                action?()
            }
        }
    }
    
}

extension View {
    
    func onLoad(perform action: (() -> Void)? = nil) -> some View {
        modifier(ViewDidLoadModifier(perform: action))
    }
    
}
