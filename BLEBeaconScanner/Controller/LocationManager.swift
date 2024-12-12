//
//  LocationManager.swift
//  BLEBeaconScanner
//
//  Created by 矢口悠月 on 2024/12/05.
//


import CoreLocation
import MapKit

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    private var manager = CLLocationManager()
    private var latestLocation: LocationModel?
    var delegate: DataSyncManager?

    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    override init() {
        super.init()
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func startLocationUpdates() {
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let locationModel = LocationModel()
        locationModel.updateLocation(location)
        latestLocation = locationModel

        // 新しい位置情報を元に中心座標を更新
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

        // regionの中心座標を更新
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(center: center, span: self.region.span)
        }
        //print(latestLocation?.latitude)

        // データを整形して通知を発行
        let locationData: [String: Any] = [
            "latitude": latestLocation?.latitude ?? 0.0,
            "longitude": latestLocation?.longitude ?? 0.0,
            "altitude": latestLocation?.altitude ?? 0.0,
            "floor": latestLocation?.floor ?? 0,
        ]

        // 通知を発行
        NotificationCenter.default.post(name: .LocationDataUpdated, object: nil, userInfo: locationData)
    }

    func getLatestLocation() -> LocationModel? {
        return latestLocation
    }
}
