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

    @objc func queryHKitSampleType(_ call: CAPPluginCall) {
        guard let _sampleName = call.options["sampleName"] as? String else {
            return call.reject("Must provide sampleName")
        }
        guard let startDateString = call.options["startDate"] as? String else {
            return call.reject("Must provide startDate")
        }
        guard let endDateString = call.options["endDate"] as? String else {
            return call.reject("Must provide endDate")
        }
        guard let _limit = call.options["limit"] as? Int else {
            return call.reject("Must provide limit")
        }
        
        let _startDate = HealthKitHelper.getDateFromString(inputDate: startDateString)
        let _endDate = HealthKitHelper.getDateFromString(inputDate: endDateString)
        
        let limit: Int = (_limit == 0) ? HKObjectQueryNoLimit : _limit
        
        let predicate = HKQuery.predicateForSamples(withStart: _startDate, end: _endDate, options: HKQueryOptions.strictStartDate)
        
        guard let sampleType: HKSampleType = HealthKitHelper.getSampleType(sampleName: _sampleName) else {
            return call.reject("Error in sample name")
        }
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: limit, sortDescriptors: nil) {
            _, results, _ in
            guard let output: [[String: Any]] = HealthKitHelper.generateOutput(sampleName: _sampleName, results: results) else {
                return call.reject("Error happened while generating outputs")
            }
            call.resolve([
                "countReturn": output.count,
                "resultData": output,
            ])
        }
        HealthKitHelper.healthStore.execute(query)
    }

}
