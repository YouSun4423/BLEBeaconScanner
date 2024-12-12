//
//  BLEBeaconScannerApp.swift
//  BLEBeaconScanner
//
//  Created by 矢口悠月 on 2024/12/05.
//

import SwiftUI
import MapKit
import AVFoundation

struct ContentView: View {
    @StateObject private var dataSyncManager = DataSyncManager()

        var body: some View {
            MapView(locationManager: dataSyncManager.locationManager)
        }
}
