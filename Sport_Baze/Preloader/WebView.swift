//
//  WebView.swift
//  Sport_Baze
//
//  Created by Андрій Кузьмич on 17.08.2023.
//

import SwiftUI
import WebKit

struct MyWebViewRepresentable: UIViewRepresentable {
    let url: URL?
    var loadStatusChanged: ((String?, Bool, Error?) -> Void)? = nil
    
    func makeCoordinator() -> MyWebViewRepresentable.Coordinator {
        Coordinator(self)
    }
    func makeUIView(context: Context) -> WKWebView {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        configuration.allowsAirPlayForMediaPlayback = true
        configuration.allowsPictureInPictureMediaPlayback = true
        configuration.allowsInlineMediaPlayback = true
        
        let view = WKWebView(
            frame: .zero,
            configuration: configuration
        )
        
        view.navigationDelegate = context.coordinator
        return view
    }
    
    func onLoadStatusChanged(perform: ((String?, Bool, Error?) -> Void)?) -> some View {
        var copy = self
        copy.loadStatusChanged = perform
        return copy
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let myURl = url else {return}
        
        let request = URLRequest(url: myURl)
        uiView.allowsBackForwardNavigationGestures = true
        uiView.configuration.allowsAirPlayForMediaPlayback = true
        uiView.configuration.allowsInlineMediaPlayback = true
        uiView.load(request)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: MyWebViewRepresentable
        init(_ parent: MyWebViewRepresentable) {
            self.parent = parent
        }
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            parent.loadStatusChanged?(webView.url?.absoluteString, true, nil)
        }
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//            print("This is FINISH:", webView.url?.absoluteString)
//            AnalyticsService.userLevelsCategory = webView.url?.absoluteString ?? ""
            parent.loadStatusChanged?(webView.url?.absoluteString, false, nil)
        }
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            parent.loadStatusChanged?(webView.url?.absoluteString, false, error)
        }
    }
}
