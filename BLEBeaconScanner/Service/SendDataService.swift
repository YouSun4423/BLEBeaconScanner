//
//  LocationService.swift
//  BLEBeaconScanner
//
//  Created by 矢口悠月 on 2024/12/05.
//

import Foundation

class SendDataService {
    func sendCSV(csvData: String) {
        // ここでAPIリクエストを行う
        let baseUrl: String = "http://arta.exp.mnb.ees.saitama-u.ac.jp/agp/wheelchair/upload_ble_beacon.php"
        
        // Base URLをチェック
        guard let url = URL(string: baseUrl) else {
            print("Invalid base URL")
            return
        }
        
        // 改行コードを統一 (UNIXスタイルの改行 `\n` に変換)
        let normalizedCSVData = csvData.replacingOccurrences(of: "\r\n", with: "\n")
        
        // リクエスト作成
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("text/csv", forHTTPHeaderField: "Content-Type") // Content-Typeを適切に設定
        request.httpBody = normalizedCSVData.data(using: .utf8) // 生のCSVデータを送信
        
        // リクエスト送信
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Failed to send data: \(error.localizedDescription)")
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Server response status code: \(response.statusCode)")
            }
            
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Server response: \(responseString)")
            }
        }
        task.resume()
    }
}
