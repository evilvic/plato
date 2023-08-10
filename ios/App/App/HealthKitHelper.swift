//
//  HealthKitHelper.swift
//  App
//
//  Created by Víctor Peña Romero on 08/08/23.
//

import Foundation
import HealthKit

public class HealthKitHelper {

    public static let healthStore = HKHealthStore()

    public class func getTypes(items: [String]) -> Set<HKSampleType> {
        var types: Set<HKSampleType> = []
        for item in items {
            switch item {
            case "water":
                types.insert(HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)!)
            default:
                print("no match in case: " + item)
            }
        }
        return types
    }

    public class func getSampleType(sampleName: String) -> HKSampleType? {
        switch sampleName {
        case "water":
            return HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)!
        default:
            return nil
        }
    }

    public class func generateOutput(sampleName: String, results: [HKSample]?) -> [[String: Any]]? {
        var output: [[String: Any]] = []
        if results == nil {
            return output
        }
        for result in results! {
                guard let sample = result as? HKQuantitySample else {
                    return nil
                }
                var unit: HKUnit?
                var unitName: String?
                
                if sampleName == "water" {
                    unit = HKUnit.literUnit(with: .milli)
                    unitName = "milliliter"
                } else {
                    print("Error: unknown unit type")
                }
                
                let quantitySD: NSDate
                let quantityED: NSDate
                quantitySD = sample.startDate as NSDate
                quantityED = sample.endDate as NSDate
                let quantityInterval = quantityED.timeIntervalSince(quantitySD as Date)
                let quantitySecondsInAnHour: Double = 3600
                let quantityHoursBetweenDates = quantityInterval / quantitySecondsInAnHour
                
                
                output.append([
                    "uuid": sample.uuid.uuidString,
                    "value": sample.quantity.doubleValue(for: unit!),
                    "unitName": unitName!,
                    "startDate": ISO8601DateFormatter().string(from: sample.startDate),
                    "endDate": ISO8601DateFormatter().string(from: sample.endDate),
                    "duration": quantityHoursBetweenDates,
                    "source": sample.sourceRevision.source.name,
                    "sourceBundleId": sample.sourceRevision.source.bundleIdentifier,
                ])
            
        }
        return output
    }

    public class func getDateFromString(inputDate: String) -> Date {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions =  [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: inputDate)!
    }

}
