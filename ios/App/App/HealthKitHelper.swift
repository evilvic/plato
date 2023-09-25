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
            case "weight":
                types.insert(HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!)
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
        case "weight":
            return HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!
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
                } else if sampleName == "weight" {
                    unit = HKUnit.gramUnit(with: .kilo)
                    unitName = "kilogram"
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

    public class func generateOutputForSingleSample(sampleName: String, sample: HKQuantitySample) -> [String: Any]? {
    var unit: HKUnit?
    var unitName: String?

    // Determinar la unidad basada en el nombre de la muestra
    if sampleName == "water" {
        unit = HKUnit.literUnit(with: .milli)
        unitName = "milliliter"
    } else if sampleName == "weight" {
        unit = HKUnit.gramUnit(with: .kilo)
        unitName = "kilogram"
    } else {
        print("Error: unknown unit type")
        return nil
    }

    // Calcular la duración entre las fechas de inicio y fin
    let quantitySD: NSDate = sample.startDate as NSDate
    let quantityED: NSDate = sample.endDate as NSDate
    let quantityInterval = quantityED.timeIntervalSince(quantitySD as Date)
    let quantitySecondsInAnHour: Double = 3600
    let quantityHoursBetweenDates = quantityInterval / quantitySecondsInAnHour

    // Crear y devolver el diccionario de salida
    return [
        "uuid": sample.uuid.uuidString,
        "value": sample.quantity.doubleValue(for: unit!),
        "unitName": unitName!,
        "startDate": ISO8601DateFormatter().string(from: sample.startDate),
        "endDate": ISO8601DateFormatter().string(from: sample.endDate),
        "duration": quantityHoursBetweenDates,
        "source": sample.sourceRevision.source.name,
        "sourceBundleId": sample.sourceRevision.source.bundleIdentifier,
    ]
}


    public class func getDateFromString(inputDate: String) -> Date {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions =  [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: inputDate)!
    }

}
