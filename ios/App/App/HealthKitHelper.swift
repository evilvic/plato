//
//  HealthKitHelper.swift
//  App
//
//  Created by Víctor Peña Romero on 08/08/23.
//

import Foundation
import HealthKit

var healthStore = HKHealthStore()

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

}
