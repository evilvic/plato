//
//  HealthKitPlugin.swift
//  App
//
//  Created by Víctor Peña Romero on 08/08/23.
//

import Foundation
import Capacitor
import HealthKit

@objc(HealthKitPlugin)
public class HealthKitPlugin: CAPPlugin {

    @objc func requestAuthorization(_ call: CAPPluginCall) {
        if !HKHealthStore.isHealthDataAvailable() {
            return call.reject("Health data not available")
        }
        guard let _all = call.options["all"] as? [String] else {
            return call.reject("Must provide all")
        }
        guard let _read = call.options["read"] as? [String] else {
            return call.reject("Must provide read")
        }
        guard let _write = call.options["write"] as? [String] else {
            return call.reject("Must provide write")
        }
        
        let writeTypes: Set<HKSampleType> = HealthKitHelper.getTypes(items: _write).union(HealthKitHelper.getTypes(items: _all))
        let readTypes: Set<HKSampleType> = HealthKitHelper.getTypes(items: _read).union(HealthKitHelper.getTypes(items: _all))
        
        HealthKitHelper.healthStore.requestAuthorization(toShare: writeTypes, read: readTypes) { success, error in
            if !success {
                call.reject(error?.localizedDescription ?? "Could not get permission")
                return
            }
            call.resolve()
        }
    }

}
