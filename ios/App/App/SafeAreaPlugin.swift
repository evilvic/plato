//
//  SafeAreaPlugin.swift
//  App
//
//  Created by Víctor Peña Romero on 08/08/23.
//

import Foundation
import Capacitor

@objc(SafeAreaPlugin)
public class SafeAreaPlugin: CAPPlugin {
    @objc func getInsets(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first else {
                return call.reject("Unable to get the main window")
            }

            let insets = window.safeAreaInsets
            call.resolve([
                "top": insets.top,
                "left": insets.left,
                "bottom": insets.bottom,
                "right": insets.right
            ])
        }
    }
}
