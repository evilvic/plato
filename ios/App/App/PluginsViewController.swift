//
//  PluginsViewController.swift
//  App
//
//  Created by Víctor Peña Romero on 13/05/24.
//

import UIKit
import Capacitor

class PluginsViewController: CAPBridgeViewController {

    override open func viewDidLoad() {
        super.viewDidLoad()

        bridge?.registerPluginInstance(SafeAreaPlugin())
        bridge?.registerPluginInstance(HealthKitPlugin())
        bridge?.registerPluginInstance(SuppressLongPressPlugin())
        bridge?.registerPluginInstance(CloudKitPlugin())
    }

}
