//
//  Locationmodel.swift
//  BLEBeaconScanner
//
//  Created by 矢口悠月 on 2024/12/05.
//

import CoreLocation
import UIKit

class LocationModel: ObservableObject {
    
    //年月日時分秒
    var timestamp: String = ""
    //緯度
    var latitude: Double = 0
    //経度
    var longitude: Double = 0
    //高度
    var altitude: Double = 0
    //フロア(階層)
    var floor: Int = 0


    func updateLocation(_ location: CLLocation) {
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        self.altitude = location.altitude
        self.floor = location.floor?.level ?? 0
        self.timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short)
    }
}
