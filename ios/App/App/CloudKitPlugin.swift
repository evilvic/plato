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
        
        CKContainer.default().publicCloudDatabase.save(record) { savedRecord, error in
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
}
