//
//  MapView.swift
//  BLEBeaconScanner
//
//  Created by 矢口悠月 on 2024/12/05.
//
import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var locationManager: LocationManager
    @State private var trackingMode = MapUserTrackingMode.follow // ユーザートラッキングモード
    
    var body: some View {
        Map(coordinateRegion: $locationManager.region,
            showsUserLocation: true,
            userTrackingMode: $trackingMode)
            .onAppear {
                locationManager.startLocationUpdates()
            }
    }
}
