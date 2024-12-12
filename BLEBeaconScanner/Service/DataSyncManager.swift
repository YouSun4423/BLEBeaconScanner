//
//  DataSyncManager.swift
//  BLEBeaconScanner
//
//  Created by 矢口悠月 on 2024/12/05.
//

import Foundation
import CoreLocation
import CoreBluetooth
import UIKit

class DataSyncManager: NSObject, ObservableObject {
    private let foregroundScanner = BLEForegroundScanner()
    private let backgroundScanner = BLEBackgroundScanner()
    @Published private(set) var locationManager = LocationManager()
    
    private let sendDataService = SendDataService()

    private var timestamp: String = ""
    private var bleData: [String: Any] = [:]
    private var locationData: [String: Any] = [:]
    private var csvFormattedData: String = ""
    
    override init() {
        super.init()
        // LocationManagerのdelegateをselfに設定
        locationManager.delegate = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleLocationUpdate(notification:)),
            name: .LocationDataUpdated,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleBLEUpdate(notification:)),
            name: .BLEDataUpdated,
            object: nil
        )
    }
    
    func startLocationUpdates() {
        print("Starting synchronization")
        locationManager.startLocationUpdates()
    }

    func startForegroundSynchronization() {
        print("Starting foreground synchronization.")
        backgroundScanner.stopBackgroundMonitoring()
        foregroundScanner.startScanning()
    }

    func startBackgroundSynchronization() {
        print("Starting background synchronization.")
        foregroundScanner.stopScanning()
        backgroundScanner.startBackgroundMonitoring()
        locationManager.startLocationUpdates()
        
    }

    func stopAllScans() {
        foregroundScanner.stopScanning()
        backgroundScanner.stopBackgroundMonitoring()
    }

    @objc private func handleBLEUpdate(notification: Notification) {
        if let data = notification.userInfo as? [String: Any] {
            bleData = data
            print("Received BLE Data")
            //print(bleData)
            checkAndSendData()  // BLEデータと位置データが揃ったかチェック
        }
    }

    @objc private func handleLocationUpdate(notification: Notification) {
        if let data = notification.userInfo as? [String: Any] {
            //位置情報データをリセット
            locationData = [:]
            locationData = data
            print("Received Location Data")
            checkAndSendData()  // BLEデータと位置データが揃ったかチェック
        }
    }

    private func checkAndSendData() {
        print("BLE Data: \(bleData)")
        print("Location Data: \(locationData)")
        
        // 両方のデータが揃った時のみ送信
        guard !bleData.isEmpty, !locationData.isEmpty else {
            print("Waiting for both BLE and Location data...")
            return
        }

        // タイムスタンプを統一
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        timestamp = formatter.string(from: Date())
        bleData["timestamp"] = timestamp
        locationData["timestamp"] = timestamp
        print("Timestamp: \(timestamp)")
        
        var deviceId: String = UIDevice.current.identifierForVendor!.uuidString

        // データ送信
        csvFormattedData = formatBLEAndLocationToCSV(bleData: bleData, locationData: locationData, deviceID: deviceId)
        
        sendDataService.sendCSV(csvData: csvFormattedData)
        // 送信後にデータをリセット
        bleData = [:]
    }

    private func formatBLEAndLocationToCSV(
        bleData: [String: Any],
        locationData: [String: Any],
        deviceID: String
    ) -> String {
        // BLEデータの解析
        guard let bleTimestamp = bleData["timestamp"] as? String,
              let peripherals = bleData["peripherals"] as? [[String: Any]] else {
            return "Invalid BLE Data"
        }
        
        // 位置情報データの解析
        guard let locationTimestamp = locationData["timestamp"] as? String,
              let latitude = locationData["latitude"] as? Double,
              let longitude = locationData["longitude"] as? Double,
              let altitude = locationData["altitude"] as? Double,
              let floor = locationData["floor"] as? Int else {
            return "Invalid Location Data"
        }
        
        // CSVのヘッダー
        var csvString = "MAC Address,RSSI,Timestamp,Latitude,Longitude,Altitude,Floor,Device ID\n"
        
        // 各ペリフェラルデータをCSV行として追加
        for peripheral in peripherals {
            guard let macAddress = peripheral["identifier"] as? String,
                  let rssi = peripheral["RSSI"] as? Int else {
                continue
            }
            
            // CSV行の生成
            let csvRow = "\(macAddress),\(rssi),\(locationTimestamp),\(latitude),\(longitude),\(altitude),\(floor),\(deviceID)"
            csvString.append(csvRow + "\n")
        }
        
        return csvString
    }
}
