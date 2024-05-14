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
        var assets: [CKAsset] = []

        for (key, value) in fields {
            if key == "images", let imagePaths = value as? [String] {
                for imagePath in imagePaths {
                    if let data = Data(base64Encoded: imagePath, options: .ignoreUnknownCharacters),
                        let url = createTemporaryFile(data: data) {
                            let asset = CKAsset(fileURL: url)
                            assets.append(asset)
                        }
                    }
                    record.setValue(assets, forKey: key)
                } else {
                    record.setValue(value, forKey: key)
                }
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
    
    func createTemporaryFile(data: Data) -> URL? {
        let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let temporaryFileURL = temporaryDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
        do {
            try data.write(to: temporaryFileURL)
            return temporaryFileURL
        } catch {
            print("Error writing file: \(error)")
            return nil
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
                        let value = record[key]
                        if let asset = value as? CKAsset, let fileURL = asset.fileURL {
                            data[key] = fileURL.absoluteString
                        } else if let date = value as? Date {
                            data[key] = ISO8601DateFormatter().string(from: date)
                        } else if let number = value as? NSNumber {
                            data[key] = number
                        } else if let string = value as? String {
                            data[key] = string
                        } else {
                            data[key] = "\(String(describing: value))"
                        }
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
