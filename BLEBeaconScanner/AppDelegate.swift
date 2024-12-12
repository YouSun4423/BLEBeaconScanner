//
//  AppDelegate.swift
//  MyLocation
//
//  Created by 矢口悠月 on 2024/07/19.
//

import UIKit


class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {

        let config = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        config.delegateClass = SceneDelegate.self
        return config
    }
    
}

