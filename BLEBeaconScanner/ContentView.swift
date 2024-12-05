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
    @ObservedObject var manager = LocationManager() // 位置情報管理
    @State private var trackingMode = MapUserTrackingMode.follow // ユーザートラッキングモード
    @State private var OACNumber: String = "" // QRコードから取得する固有番号
    @State private var phoneNumber: String = "" // ユーザー入力の電話番号
    @State private var showCamera: Bool = false // QRコードスキャナ表示フラグ
    @State private var errorMessage: String = "" // エラーメッセージ表示用
    @State private var mailAddress: String = "" // エラーメッセージ表示用
    
    
    var body: some View {
        // マップ表示
        Map(coordinateRegion: $manager.region,
            showsUserLocation: true,
            userTrackingMode: $trackingMode)
            .edgesIgnoringSafeArea(.bottom)
    }
    
    // QRコード読み取り結果のハンドリング
    func handleQRCodeResult(_ result: String) {
        if let _ = Int(result), result.count == 10 {
            OACNumber = result
            errorMessage = ""
        } else {
            errorMessage = "QRコードの内容が10桁の整数ではありません。"
        }
    }

    
    // 初回インストール時チェック
    func checkFirstLaunch() {
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "hasLaunchedBefore") == false {
            // 初回起動時の処理
            defaults.set(true, forKey: "hasLaunchedBefore")
            print("初回起動時の処理を実行")
        }
    }
}
