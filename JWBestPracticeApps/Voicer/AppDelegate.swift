//
//  AppDelegate.swift
//  Voicer
//
//  Created by Karim Mourra on 9/21/16.
//  Copyright © 2016 Karim Mourra. All rights reserved.
//

import UIKit
import Intents
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.enableBackgroundAudio()
        return true
    }
    
    func enableBackgroundAudio() -> Void {
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(AVAudioSessionCategoryPlayback)
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
        } catch {
            print("failure")
        }
        try? audioSession.setActive(true)
        do {
            try audioSession.setActive(true)
        } catch {
            print("failure")
        }
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        let navigationController = application.keyWindow?.rootViewController as! UINavigationController
        let currentVoicerViewController = navigationController.childViewControllers[0] as? VoicerViewController
        let userIntent = userActivity.interaction?.intent
        currentVoicerViewController?.handle(intent: userIntent!)
        return true
    }
}

