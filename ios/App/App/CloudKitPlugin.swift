//
//  CloudKitPlugin.swift
//  App
//
//  Created by Víctor Peña Romero on 09/05/24.
//

import Foundation
import Capacitor
import CloudKit

@objc(CloudKitPlugin)
public class CloudKitPlugin: CAPPlugin {
    @objc func createRecord(_ call: CAPPluginCall) {
        guard let recordType = call.options["recordType"] as? String else {
            return call.reject("Must provide recordType")
        }
        guard let fields = call.options["fields"] as? [String: Any] else {
            return call.reject("Must provide fields")
        }
        
        let record = CKRecord(recordType: recordType)

        for (key, value) in fields {
            record.setValue(value, forKey: key)
        }
        
        print("Using default container: \(CKContainer.default().containerIdentifier ?? "Unknown Container")")
        
        CKContainer.default().privateCloudDatabase.save(record) { savedRecord, error in
            if let error = error {
                call.reject("Error saving record: \(error.localizedDescription)")
                return
            }

            if let savedRecord = savedRecord {
                var result = [String: Any]()
                result["recordName"] = savedRecord.recordID.recordName
                call.resolve(result)
            } else {
                call.resolve()
            }
        }
  }

  @objc func fetchRecords(_ call: CAPPluginCall) {
        guard let recordType = call.options["recordType"] as? String else {
            return call.reject("Must provide recordType")
        }

        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: recordType, predicate: predicate)

        CKContainer.default().privateCloudDatabase.perform(query, inZoneWith: nil) { records, error in
            if let error = error {
                print("Error fetching records: \(error.localizedDescription)")
                call.reject("Error fetching records: \(error.localizedDescription)")
                return
            }

            if let records = records {
                let recordData = records.map { record -> [String: Any] in
                    var data = [String: Any]()
                    data["uuid"] = record.recordID.recordName
                    data["creationDate"] = ISO8601DateFormatter().string(from: record.creationDate!)
                    for key in record.allKeys() {
                        data[key] = record[key]
                    }
                    return data
                }

                call.resolve([
                    "records": recordData
                ])
            } else {
                print("No records found")
                call.resolve([
                    "records": []
                ])
            }
        }
    }
}
