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
            case "workout":
                types.insert(HKWorkoutType.workoutType())
            case "dietaryEnergy":
                types.insert(HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed)!)
            case "totalFat":
                types.insert(HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFatTotal)!)
            case "protein":
                types.insert(HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryProtein)!)
            case "carbohydrates":
                types.insert(HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCarbohydrates)!)
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
        case "workout":
            return HKWorkoutType.workoutType()
        case "dietaryEnergy":
            return HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed)!
        case "totalFat":
            return HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFatTotal)!
        case "protein":
            return HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryProtein)!
        case "carbohydrates":
            return HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCarbohydrates)!
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
            if sampleName == "workout" {
                guard let sample = result as? HKWorkout else {
                    return nil
                }

                var TEBData: Double? = -1
                var TDData: Double? = -1
                var TFCData: Double? = -1
                var TSSCData: Double? = -1

                var unitTEB: HKUnit?
                if (sample.totalEnergyBurned) != nil {
                    if (sample.totalEnergyBurned?.is(compatibleWith: HKUnit.kilocalorie()))! {
                        unitTEB = HKUnit.kilocalorie()
                    }
                    guard unitTEB != nil else { return nil }
                    TEBData = sample.totalEnergyBurned?.doubleValue(for: unitTEB!)
                }

                var unitTD: HKUnit?
                if (sample.totalDistance) != nil {
                    if (sample.totalDistance?.is(compatibleWith: HKUnit.meter()))! {
                        unitTD = HKUnit.meter()
                    }
                    guard unitTD != nil else { return nil }
                    TDData = sample.totalDistance?.doubleValue(for: unitTD!)
                }

                var unitTFC: HKUnit?
                if (sample.totalFlightsClimbed) != nil {
                    if (sample.totalFlightsClimbed?.is(compatibleWith: HKUnit.count()))! {
                        unitTFC = HKUnit.count()
                    }
                    guard unitTFC != nil else { return nil }
                    TFCData = sample.totalFlightsClimbed?.doubleValue(for: unitTFC!)
                }

                var unitTSSC: HKUnit?
                if (sample.totalSwimmingStrokeCount) != nil {
                    if (sample.totalSwimmingStrokeCount?.is(compatibleWith: HKUnit.count()))! {
                        unitTSSC = HKUnit.count()
                    }
                    guard unitTSSC != nil else { return nil }
                    TSSCData = sample.totalSwimmingStrokeCount?.doubleValue(for: unitTSSC!)
                }

                let workoutSD = sample.startDate as NSDate
                let workoutED = sample.endDate as NSDate
                let workoutInterval = workoutED.timeIntervalSince(workoutSD as Date)
                let workoutHoursBetweenDates = workoutInterval / 60

                output.append([
                    "uuid": sample.uuid.uuidString,
                    "startDate": ISO8601DateFormatter().string(from: sample.startDate),
                    "endDate": ISO8601DateFormatter().string(from: sample.endDate),
                    "duration": workoutHoursBetweenDates,
                    "source": sample.sourceRevision.source.name,
                    "sourceBundleId": sample.sourceRevision.source.bundleIdentifier,
                    "workoutActivityId": sample.workoutActivityType.rawValue,
                    "workoutActivityName": returnWorkoutActivityTypeValueDictionnary(activityType: sample.workoutActivityType),
                    "totalEnergyBurned": TEBData!, // kilocalorie
                    "totalDistance": TDData!, // meter
                    "totalFlightsClimbed": TFCData!, // count
                    "totalSwimmingStrokeCount": TSSCData!, // count
                ])

            } else {    

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
        } else if sampleName == "dietaryEnergy" {
            unit = HKUnit.kilocalorie()
            unitName = "kilocalorie"
        } else if sampleName == "totalFat" {
            unit = HKUnit.gram()
            unitName = "gram"
        } else if sampleName == "protein" {
            unit = HKUnit.gram()
            unitName = "gram"
        } else if sampleName == "carbohydrates" {
            unit = HKUnit.gram()
            unitName = "gram"
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

    public class func returnWorkoutActivityTypeValueDictionnary(activityType: HKWorkoutActivityType) -> String {
        switch activityType {
            case HKWorkoutActivityType.walking:
                return "Walking"
            default:
                return "Other"
        }

    }

}
