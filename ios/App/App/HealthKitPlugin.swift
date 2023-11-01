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

    @objc func saveHKitSampleType(_ call: CAPPluginCall) {
        guard let _sampleName = call.options["sampleName"] as? String else {
            return call.reject("Must provide sampleName")
        }
        guard let _value = call.options["value"] as? Double else {
            return call.reject("Must provide value")
        }
        guard let dateString = call.options["date"] as? String else {
            return call.reject("Must provide date")
        }
        
        let _date = HealthKitHelper.getDateFromString(inputDate: dateString)
        
        switch _sampleName {
        case "water":
            guard let quantityType = HKObjectType.quantityType(forIdentifier: .dietaryWater) else {
                return call.reject("Water Intake Type is not available in HealthKit")
            }
            let waterQuantity = HKQuantity(unit: HKUnit.literUnit(with: .milli), doubleValue: _value)
            let waterIntakeSample = HKQuantitySample(type: quantityType, quantity: waterQuantity, start: _date, end: _date)
            HealthKitHelper.healthStore.save(waterIntakeSample) { (success, error) in
                if success {
                    if let sampleData = HealthKitHelper.generateOutputForSingleSample(sampleName: _sampleName, sample: waterIntakeSample) {
                        call.resolve(["sample": sampleData])
                    } else {
                        call.reject("Error generating sample data")
                    }
                } else {
                    call.reject("Error saving water intake: \(String(describing: error?.localizedDescription))")
                }
            }
        case "weight":
            guard let quantityType = HKObjectType.quantityType(forIdentifier: .bodyMass) else {
                return call.reject("Body Mass Type is not available in HealthKit")
            }
            let weightQuantity = HKQuantity(unit: HKUnit.gramUnit(with: .kilo), doubleValue: _value)
            let weightSample = HKQuantitySample(type: quantityType, quantity: weightQuantity, start: _date, end: _date)
            HealthKitHelper.healthStore.save(weightSample) { (success, error) in
            if success {
                if let sampleData = HealthKitHelper.generateOutputForSingleSample(sampleName: _sampleName, sample: weightSample) {
                    call.resolve(["sample": sampleData])
                } else {
                    call.reject("Error generating sample data")
                }
            } else {
                call.reject("Error saving weight: \(String(describing: error?.localizedDescription))")
            }
        }
        default:
            call.reject("Unsupported sample type: \(_sampleName)")
        }
    }

}
