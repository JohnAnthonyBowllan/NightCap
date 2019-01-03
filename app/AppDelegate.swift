//
//  AppDelegate.swift
//  STEM1.0
//
//  Copyright © 2017 John Anthony Bowllan. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    var manager = CLLocationManager()
    var window: UIWindow?
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
        // function implicit to iOS that obtains up-to-date location information
    {
        Core.shared.gotLocation(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude,altitude:locations[0].altitude)
        
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Accessing saved user settings at launch
        if let savedMalePreference = UserDefaults.standard.object(forKey: "malePreference")as? Bool{
            Core.shared.malePreference = savedMalePreference
        }
        if let savedFemalePreference = UserDefaults.standard.object(forKey: "femalePreference")as? Bool{
            Core.shared.femalePreference = savedFemalePreference
        }
        if let savedOtherPreference = UserDefaults.standard.object(forKey: "other")as? Bool{
            Core.shared.other = savedOtherPreference
        }
        if let saved = UserDefaults.standard.object(forKey: "sUsername")as? String {
            Core.shared.sUsername = saved
        }
        if let savedGender = UserDefaults.standard.object(forKey: "userGender")as? String {
            Core.shared.userGender = savedGender
            
        }
        
        Core.shared.checkDictionaryOfRequestsTimer()

        // required for initializing Apple's location services
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
    }


}

