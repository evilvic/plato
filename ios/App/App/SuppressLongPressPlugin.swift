//
//  SuppressLongPressPlugin.swift
//  App
//
//  Created by Víctor Peña Romero on 05/09/23.
//

import Foundation
import Capacitor

@objc(SuppressLongPressPlugin)
public class SuppressLongPressPlugin: CAPPlugin {
    
    @objc(activate:)
        func activate(call: CAPPluginCall) {
            
            guard let webView = self.bridge?.webView else {
                call.reject("Failed to get WebView")
                return
            }
            
            let recognizeLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongpressGesture))
            recognizeLongPressGesture.minimumPressDuration = 0.45
            recognizeLongPressGesture.allowableMovement = 100.0
            
            DispatchQueue.main.async {
                webView.addGestureRecognizer(recognizeLongPressGesture)
                call.resolve()
            }
        }
        
        @objc func handleLongpressGesture() {
            print("Long-press gesture suppressed")
        }

}
