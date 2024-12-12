//
//  NotificationNameExtensions.swift
//  BLEBeaconScanner
//
//  Created by 矢口悠月 on 2024/12/05.
//

import Foundation

extension Notification.Name {
    static let BLEDataUpdated = Notification.Name("BLEDataUpdated")
    static let LocationDataUpdated = Notification.Name("LocationDataUpdated")
}
