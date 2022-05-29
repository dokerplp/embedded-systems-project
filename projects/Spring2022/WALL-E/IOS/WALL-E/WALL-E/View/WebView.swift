//
//  WebView.swift
//  WALL-E
//
//  Created by dokerplp on 5/27/22.
//

import Foundation
import SwiftUI
import Combine
import WebKit
import UIKit


enum URLType {
    case local, `public`
}

enum WebViewNavigationAction {
    case backward, forward, reload
}

struct WebView: UIViewRepresentable {
    
    var type: URLType
    var url: String?
    
    func makeUIView(context: Context) -> WKWebView {
        let preferences = WKPreferences()
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.isScrollEnabled = true
        return webView
        
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if let urlValue = url  {
            if let requestUrl = URL(string: urlValue) {
                webView.load(URLRequest(url: requestUrl))
            }
        }
    }
}
