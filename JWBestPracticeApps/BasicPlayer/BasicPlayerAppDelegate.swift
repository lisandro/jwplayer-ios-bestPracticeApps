//
//  AppDelegate.swift
//  BestPracticeApp
//  BasicPlayer
//
//  Created by David Perez on 28/10/20.
//  Created by David Perez on 19/11/20.
//  Copyright © 2020 JWPlayer. All rights reserved.
//

import UIKit
import JWPlayerKit
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // MARK: License Key

        // Add your JWPlayer license key.
        JWPlayerKitLicense.setLicenseKey(<#Your License Key#>)
        let window = UIWindow(frame: UIScreen.main.bounds)

        window.rootViewController = BasicPlayerViewController() // Your initial view controller.
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}
