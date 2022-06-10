//
//  CameraView.swift
//  WALL-E
//
//  Created by dokerplp on 5/27/22.
//

import Foundation
import SwiftUI
import WebKit
 
struct CustomWebView: UIViewRepresentable {
 
    var url: String
 
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.loadHTMLString(getCameraData(url: url), baseURL: nil)
        webView.scrollView.isScrollEnabled = false
        webView.configuration.userContentController.addUserScript(self.getZoomDisableScript())
        return webView
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.loadHTMLString(getCameraData(url: url), baseURL: nil)
    }
    
    private func getCameraData(url: String) -> String {
            return "<style>img{display: block; background-color: hsl(0, 0%, 25%); height: auto; max-width: 100%;margin-left: auto;margin-right: auto}</style><img src=\"\(url)/\" width=\"1280\" height=\"720\">"
    }
    
    private func getZoomDisableScript() -> WKUserScript {
        let source: String = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum- scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);"
        return WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    }
}

enum Camera {
    case front, back
}

struct CameraView: View {
    @Binding public var camera: Camera
    @Binding public var fcamera: String
    @Binding public var bcamera: String
    
    var body: some View {
        
        switch camera {
        case .front:
            CustomWebView(url: fcamera)
        case .back:
            CustomWebView(url: bcamera)
        }
        
    }
}
