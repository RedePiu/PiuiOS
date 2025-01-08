//
//  AppDelegate.swift
//  MyQiwi
//
//  Created by ailton on 12/12/17.
//  Copyright © 2017 Qiwi. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import AWSCore
import AWSMobileClient
import Firebase
import FirebaseMessaging
import GoogleMaps
import GooglePlaces
//import FacebookCore
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?
    var orientationLock = UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        ApplicationRN.incrementAppInitCount()

        var preferredStatusBarStyle : UIStatusBarStyle {
            return .lightContent
        }

        // Config Teclado
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 150
        AWSMobileClient.sharedInstance().interceptApplication(application, didFinishLaunchingWithOptions: launchOptions)
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        PushNotification.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        GMSServices.provideAPIKey("AIzaSyBg3f7_xz_5LxIfNTfHmUd1-Eq2x0DuvSc")
        GMSPlacesClient.provideAPIKey("AIzaSyBg3f7_xz_5LxIfNTfHmUd1-Eq2x0DuvSc")

//        UINavigationBar.appearance().barTintColor = Theme.default.blue
//        //UINavigationBar.appearance().isFirstResponder = true
//        UINavigationBar.appearance().tintColor = UIColor.white
//        UINavigationBar.appearance().isTranslucent = false
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
//        UISearchBar.appearance().backgroundColor = UIColor.white
        
        UINavigationBar.appearance().barTintColor = Theme.default.blue
        //UINavigationBar.appearance().isFirstResponder = true
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        UISearchBar.appearance().backgroundColor = UIColor.white
        
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = Theme.default.blue
            appearance.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
            
            UINavigationBar.appearance().standardAppearance = appearance;
            UINavigationBar.appearance().scrollEdgeAppearance = UINavigationBar.appearance().standardAppearance
        } else {
            // Fallback on earlier versions
        }
        
        let segmentedAppearance = UISegmentedControl.appearance()
        if #available(iOS 13.0, *) {
            segmentedAppearance.overrideUserInterfaceStyle = .dark
        } else {
            // Fallback on earlier versions
        }

        let textViewAppearance = UITextView.appearance()
        textViewAppearance.backgroundColor = .white
        textViewAppearance.textColor = UIColor.init(hexString: Constants.Colors.Hex.colorGrey6)

        let tableViewAppearance = UITableView.appearance()
        tableViewAppearance.backgroundColor = .white

//        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
//
//        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//            ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
//
//            FBSDKSettings.setAutoInitEnabled(true)
//            FBSDKApplicationDelegate.initializeSDK(nil)
//
//            return true
//        }
//
//        func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//
//            let handled = ApplicationDelegate.shared.application(app, open: url, options: options)
//
//            let appId: String = SDKSettins.appID
//
//            if url.scheme != nil && url.scheme!.hasPrefix("fb\(appId)") && url.host == "authorize" {
//                return SDKApplicationDelegate.shared.application(app, open: url, options: options)
//            }
//
//            return handled
//        }

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
        AppEvents.activateApp()
//        AppEventsLogger.activate(application)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate {

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
      return ApplicationDelegate.shared.application(
        application,
        open: url,
        sourceApplication: sourceApplication,
        annotation: annotation
      )
    }

    @available(iOS 9.0, *)
    func application(_ application: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
      return ApplicationDelegate.shared.application(application, open: url, options: options)
    }
}

// MARK: Notifications
extension AppDelegate {

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        PushNotification.shared.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        PushNotification.shared.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        PushNotification.shared.application(application, didReceiveRemoteNotification: userInfo)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        PushNotification.shared.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
    }
}

// MARK: Notifications MessagingDelegate
extension AppDelegate: MessagingDelegate {

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let token = fcmToken {
            Log.print("Firebase registration token: \(token)")
        }
    }
    
//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//        Log.print("didReceive remoteMessage: \(remoteMessage.appData)")
//    }
}

// MARK: Controll Rotate UIScreen
extension AppDelegate {

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }

    struct AppUtility {
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.orientationLock = orientation
            }
        }

        static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
            self.lockOrientation(orientation)
            UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        }
    }
}
