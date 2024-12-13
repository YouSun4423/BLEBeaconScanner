//
//  BLEDataLogger.swift
//  BLEBeaconScanner
//
//  Created by 矢口悠月 on 2024/12/05.
//
import Foundation

class DataLogger {
    static let shared = DataLogger()
    private let fileName = "Data.csv"

    private init() {
        createCSVFileIfNeeded()
    }

    private func createCSVFileIfNeeded() {
        let filePath = getDocumentsDirectory().appendingPathComponent(fileName)
        if !FileManager.default.fileExists(atPath: filePath.path) {
            // ヘッダー行を作成
            //let header = "MACAddress,RSSI,Timestamp\n"
            //try? header.write(to: filePath, atomically: true, encoding: .utf8)
        }
    }

    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    func logData(macAddress: String, rssi: Int) {
        let filePath = getDocumentsDirectory().appendingPathComponent(fileName)
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)
        let entry = "\(macAddress),\(rssi),\(timestamp)\n"

        // ファイルに追記
        if let handle = try? FileHandle(forWritingTo: filePath) {
            handle.seekToEndOfFile()
            if let data = entry.data(using: .utf8) {
                handle.write(data)
            }
            handle.closeFile()
        }
    }

    func getCSVFilePath() -> URL {
        return getDocumentsDirectory().appendingPathComponent(fileName)
    }
}
