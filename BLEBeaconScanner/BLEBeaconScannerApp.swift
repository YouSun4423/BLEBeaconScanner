//
//  BLEBeaconScannerApp.swift
//  BLEBeaconScanner
//
//  Created by 矢口悠月 on 2024/12/05.
//

import SwiftUI

@main
struct BLEBeaconScannerApp: App {
    
    // AppDelegateを登録
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            EmptyView() // SceneDelegateでUIを管理するため空のビューを設定
        }
    }
}


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let dataSyncManager = DataSyncManager()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {
            print("Failed to cast UIScene to UIWindowScene")
            return
        }
        
        print("Scene connected successfully")
        let contentView = ContentView()
        let hostingController = UIHostingController(rootView: contentView)
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = hostingController
        window?.makeKeyAndVisible()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // アプリがフォアグラウンドになったとき
        print("App became active - starting foreground synchronization.")
        dataSyncManager.startForegroundSynchronization()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // アプリがバックグラウンドに入る直前
        print("App will resign active.")
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // アプリがバックグラウンドになったとき
        print("App entered background - starting background synchronization.")
        dataSyncManager.startBackgroundSynchronization()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // アプリがフォアグラウンドに戻る直前
        print("App will enter foreground.")
    }
}
