//
//  BLEForegroundScanner.swift
//  BLEBeaconScanner
//
//  Created by 矢口悠月 on 2024/12/05.
//

import CoreBluetooth
import UIKit

class BLEForegroundScanner: NSObject, CBCentralManagerDelegate {
    private var centralManager: CBCentralManager!
    private var discoveredPeripherals: [CBPeripheral] = []
    weak var delegate: DataSyncManager?

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func startScanning() {
        centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }

    func stopScanning() {
        print("call stopScanning")
        centralManager.stopScan()
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            startScanning()
        }
    }
    
    // ペリフェラルが検出されたときに呼び出される
    func centralManager(
        _ central: CBCentralManager,
        didDiscover peripheral: CBPeripheral,
        advertisementData: [String: Any],
        rssi RSSI: NSNumber
    ) {
        // 配列に重複しないよう追加
        if !discoveredPeripherals.contains(where: { $0.identifier == peripheral.identifier }) {
            discoveredPeripherals.append(peripheral)
        }

        // Retrieve the service UUIDs from advertisementData
        if let serviceUUIDs = advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] {
            // Extract the UUIDs as strings
            let serviceUUIDStrings = serviceUUIDs.map { $0.uuidString }
            
            // 1秒ごとに通知
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if !self.discoveredPeripherals.isEmpty {
                    // 発見されたペリフェラル情報を通知
                    let peripheralsInfo = self.discoveredPeripherals.map { peripheral in
                        [
                            "identifier": peripheral.identifier.uuidString,
                            "RSSI": RSSI,
                            "name": peripheral.name,
                            "serviceUUID": serviceUUIDStrings
                        ]
                    }

                    NotificationCenter.default.post(
                        name: .BLEDataUpdated,
                        object: nil,
                        userInfo: ["peripherals": peripheralsInfo]
                    )

                    // 配列をクリア
                    self.discoveredPeripherals.removeAll()
                }
            }
        }
    }
    
    // 中央管理者が復元状態を通知するメソッド
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        print("Central manager will restore state")
        if let peripherals = dict[CBCentralManagerRestoredStatePeripheralsKey] as? [CBPeripheral] {
            for peripheral in peripherals {
                if !discoveredPeripherals.contains(peripheral) {
                    discoveredPeripherals.append(peripheral)
                }
            }
        }

        // 必要に応じて復元後の処理を実行
        delegate?.startLocationUpdates()
    }

    func getDiscoveredPeripherals() -> [CBPeripheral] {
        return discoveredPeripherals
    }
}
