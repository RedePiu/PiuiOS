//
//  PushNotification.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 21/01/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit
import UserNotifications
import FirebaseMessaging
import ObjectMapper

class PushNotification: NSObject {

    static var delegate: BaseDelegate?
    static var appleDeviceToken: String = ""

    /**
     Returns the default singleton instance.
     **/
    public class var shared: PushNotification {
        struct Static {
            //Singleton instance.
            static let pushManager = PushNotification()
        }

        /** @return Returns the default singleton instance. */
        return Static.pushManager
    }

    let gcmMessageIDKey = "gcm.message_id"

    func showDeviceToken() -> String {

//        let token = Messaging.messaging().fcmToken
//        Log.print("FCM token: \(token ?? "")")
//        return token ?? ""
        return PushNotification.appleDeviceToken
    }
}

// MARK: Methods UIApplication
extension PushNotification {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {

        UNUserNotificationCenter.current().delegate = self
        self.requestNotificationAuthorization(application: application)
        self.clearApplicationIconBadgeNumber()
        application.registerForRemoteNotifications()
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Log.print("Failed to register: \(error)", typePrint: .alert)
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken

        PushNotification.appleDeviceToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        Log.print("Device Token iPhone: \(deviceToken)", typePrint: .alert)
        Log.print("Device Token iPhone String: \(PushNotification.appleDeviceToken)", typePrint: .alert)
        Log.print("APNS Token FCM: \(Messaging.messaging().fcmToken ?? "sem token")", typePrint: .alert)
        
        PushNotification.delegate?.onReceiveData(fromClass: PushNotification.self, param: Param.Contact.PUSH_TOKEN_REGISTERED, result: true, object: nil)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {

        if let messageID = userInfo[gcmMessageIDKey] {
            Log.print("Message ID: \(messageID)")
        }

        Log.print(userInfo)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        Log.print(userInfo)
        if let messageID = userInfo[gcmMessageIDKey] {
            Log.print("Message ID: \(messageID)")
        }
        
        //userInfo["data"] -- Campo do jorge vai vir aqui
        let bodyStr = userInfo["data"] as? String ?? ""
        let pushResponse = PushResponse(JSONString: bodyStr)
        self.handlePushResponse(pushResponse: pushResponse)

        completionHandler(UIBackgroundFetchResult.newData)
    }
}

// MARK: UNUserNotificationCenterDelegate
extension PushNotification : UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        let userInfo = notification.request.content.userInfo

        Log.print(userInfo.debugDescription)

        if let messageID = userInfo[gcmMessageIDKey] {
            Log.print("Message ID: \(messageID)")
        }
        
        //userInfo["data"] -- Campo do jorge vai vir aqui
        let bodyStr = userInfo["data"] as? String ?? ""
        let pushResponse = PushResponse(JSONString: bodyStr)
        self.handlePushResponse(pushResponse: pushResponse)

        //completionHandler([])
        // Apresentar Push notification mesmo se o app estiver em uso.
        completionHandler([.alert, .badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        let userInfo = response.notification.request.content.userInfo

        if let messageID = userInfo[gcmMessageIDKey] {
            Log.print("Message ID: \(messageID)")
        }

        //userInfo["data"] -- Campo do jorge vai vir aqui
        let bodyStr = userInfo["data"] as? String ?? ""
        let pushResponse = PushResponse(JSONString: bodyStr)
        self.handlePushResponse(pushResponse: pushResponse)

//        let bodyStr = response.notification.request.content.body.removeAllBars()
//        if !bodyStr.isEmpty && bodyStr[0] == "{" {
//            let pushResponse = PushResponse(JSONString: bodyStr)
//
//            PushNotification.showLocalNotification(title: response.notification.request.content.title, message: pushResponse?.message ?? "")
//            return
//        }

        completionHandler()
    }
    
    private func handlePushResponse(pushResponse: PushResponse?) {
        if pushResponse != nil {
            pushResponse!.userId = UserRN.getLoggedUserId()
            
            if NotificationRN.needAppOpened(pushResponse: pushResponse!) {
                NotificationRN.doAppOpenedAction(pushResponse: pushResponse!)
            } else {
                NotificationRN().insertNotification(notification: pushResponse!)
            }
        }
    }
}

// MARK: Custom Methods
extension PushNotification {

    private func requestNotificationAuthorization(application: UIApplication) {

        // Ativando para mostrar notificações em quando o app estiver aberto também.
        if #available(iOS 10.0, *) {

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })

        } else {
            // Fallback on earlier versions
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
    }

    private func clearApplicationIconBadgeNumber() {
        UIApplication.shared.applicationIconBadgeNumber = 0
        Log.print(" Badge New: \(UIApplication.shared.applicationIconBadgeNumber)", typePrint: .alert)
    }
}

// MARK: Notification Local
extension PushNotification {

    // Criar notificação local
    static func showLocalNotification(title: String, message: String, timeInterval: Double = 1) {

        let content = UNMutableNotificationContent()
        content.body = message
        content.title = title
        content.sound = UNNotificationSound.default()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // Schedule the request.
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let err = error {
                Log.print("Notification error: \(err)", typePrint: .warning)
            }
        }
    }
}
