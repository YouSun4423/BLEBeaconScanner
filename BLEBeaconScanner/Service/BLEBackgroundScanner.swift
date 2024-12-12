//
//  BLEManager.swift
//  BLEBeaconScanner
//
//  Created by 矢口悠月 on 2024/12/05.
//
import UIKit
import CoreLocation

class BLEBackgroundScanner: NSObject, CLLocationManagerDelegate {
    
    private var locationManager: CLLocationManager!
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()

        // バックグラウンドでのロケーション更新を許可
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
    }

    func startBackgroundMonitoring() {
        // 任意のビーコンUUIDを使ってレンジングを開始
        let uuidString = "5DD74D52-4E4E-4E9C-BBD3-738DF1CAADAC"  // 任意のUUID
        if let uuid = UUID(uuidString: uuidString) {
            let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "MyBeaconRegion")
            locationManager.startRangingBeacons(in: beaconRegion)
            
            print("Started ranging for beacon region with UUID: \(uuid)")
        } else {
            print("Invalid UUID string")
        }
    }

    func stopBackgroundMonitoring() {
        // レンジングを停止
        let uuid = UUID() // 任意のUUIDに変更
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "AnyBeacon")
        
        locationManager.stopRangingBeacons(in: beaconRegion)
        print("Stopped ranging for beacon region with UUID: \(uuid)")
    }

    // レンジング結果を受信
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        // ビーコンが見つかった場合
        if beacons.count > 0 {
            for beacon in beacons {
                print("Ranged beacon: \(beacon.uuid) - Proximity: \(beacon.proximity.rawValue) - Accuracy: \(beacon.accuracy) meters")
            }
        } else {
            print("No beacons found in the region.")
        }
    }

    // エラー処理
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Monitoring failed for region: \(region?.identifier ?? "Unknown") - Error: \(error.localizedDescription)")
    }

    // ユーザー通知（オプション）
    private func notifyUser(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

