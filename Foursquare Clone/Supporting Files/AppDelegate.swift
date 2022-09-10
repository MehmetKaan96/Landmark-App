//
//  AppDelegate.swift
//  Foursquare Clone
//
//  Created by mehmet on 6.09.2022.
//

import UIKit
import Parse

@main
@available(iOS 13.0, *)
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let configuration = ParseClientConfiguration { ParseMutableClientConfiguration in
            ParseMutableClientConfiguration.applicationId = "cYUTfFij4xGzrC65xBs4jUnuEhRhOEeeDLYjhh3l"
            ParseMutableClientConfiguration.clientKey = "57zDD11XCRHiZhs6e0XoJPqkdnoiTUV9JolSDjfk"
            ParseMutableClientConfiguration.server = "https://parseapi.back4app.com/"
        }
        Parse.initialize(with: configuration)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

