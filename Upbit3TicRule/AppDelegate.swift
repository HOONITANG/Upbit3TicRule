//
//  AppDelegate.swift
//  Upbit3TicRule
//
//  Created by Taehoon Kim on 2022/03/10.
//

import UIKit
import Firebase
import FirebaseMessaging
import FirebaseAnalytics
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    /// 처음 설치 유무
    var hasAlreadyLaunched :Bool!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 알람을 받을 수 있는 코인 리스트 설정
        NotiService.shared.setNotificationCoinList()
        
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        // 2
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        
        // Remote Notification Register
        // 1
        UNUserNotificationCenter.current().delegate = self
        // 2 Auth request (alert, badge, sound)
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions) { _, _ in }
        
        // 3 원격 알림 등록
        application.registerForRemoteNotifications()
        
        // Token Manage
        Messaging.messaging().delegate = self
        IQKeyboardManager.shared.enable = true
        
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
    func applicationDidBecomeActive(_ application: UIApplication) {
        let center = UNUserNotificationCenter.current()
        center.getDeliveredNotifications { (receivedNotifications) in
            for notification in receivedNotifications {
                let content = notification.request.content
                let userInfo = notification.request.content.userInfo
                print(" userInfo \(userInfo)")
                print(content.userInfo as NSDictionary)
                
                if let market = userInfo["market"] as? String,
                   let koreaName = userInfo["korean_name"] as? String,
                   let englishName = userInfo["english_name"] as? String,
                   let notificationStatus = userInfo["notification_status"] as? String,
                   let notificationDateTimeUTC = userInfo["notification_date_time_utc"] as? String,
                   let notificationPrice = userInfo["notification_price"] as? String {
                    
                    //applicationDidBecomeActive
                    let noti = Noti(market: market, koreaName: koreaName, englishName: englishName, notificationStatus: notificationStatus, notificationDateTimeUTC: notificationDateTimeUTC, notificationPrice: notificationPrice)
                    
                    DispatchQueue.main.async {
                        NotiService.shared.setNoti(noti: noti)
                    }
                }
            }
            application.applicationIconBadgeNumber = 0 // For Clear Badge Counts
            let center = UNUserNotificationCenter.current()
            center.removeAllDeliveredNotifications() // To remove all delivered notifications
            center.removeAllPendingNotificationRequests() // To remove all pending notifications which are not delivered yet but scheduled.
        }
    }
    
}

// Remote Notification Register
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // foreGround 상태 일 때 동작하는 delegate
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
            @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        process(notification, type: "WillPresent")
        completionHandler([[.banner, .sound]])
        let center = UNUserNotificationCenter.current()
        center.removeDeliveredNotifications(withIdentifiers: [notification.request.identifier])
        UIApplication.shared.applicationIconBadgeNumber = 0;
    }
    // 알람을 눌렀을 때, 특정 액션을 취함.
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        switch UIApplication.shared.applicationState {
        case .active:
            print("Received push message from APNs on Foreground")
        case .background:
            process(response.notification, type: "didReceive")
            let center = UNUserNotificationCenter.current()
            center.removeDeliveredNotifications(withIdentifiers: [response.notification.request.identifier])
            print("Received push message from APNs on Background")
        case .inactive:
            process(response.notification, type: "didReceive")
            let center = UNUserNotificationCenter.current()
            center.removeDeliveredNotifications(withIdentifiers: [response.notification.request.identifier])
            print("Received push message from APNs back to Foreground")
        @unknown default:
            fatalError()
        }
        print("userNotificationCenter didReceive is call")
        UIApplication.shared.applicationIconBadgeNumber = 0;
        completionHandler()
    }
    
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    
    private func process(_ notification: UNNotification, type: String) {
        // 1
        let userInfo = notification.request.content.userInfo
        
        if let market = userInfo["market"] as? String,
           let koreaName = userInfo["korean_name"] as? String,
           let englishName = userInfo["english_name"] as? String,
           let notificationStatus = userInfo["notification_status"] as? String,
           let notificationDateTimeUTC = userInfo["notification_date_time_utc"] as? String,
           let notificationPrice = userInfo["notification_price"] as? String {
            
            //  market + type
            let notiItem = Noti(market: market,
                                koreaName: koreaName,
                                englishName: englishName,
                                notificationStatus: notificationStatus,
                                notificationDateTimeUTC: notificationDateTimeUTC,
                                notificationPrice: notificationPrice)
            
            NotiService.shared.setNoti(noti: notiItem)
            Analytics.logEvent("NEWS_ITEM_PROCESSED", parameters: nil)
        }
        Messaging.messaging().appDidReceiveMessage(userInfo)
        Analytics.logEvent("NOTIFICATION_PROCESSED", parameters: nil)
    }
}

// Token Manage
extension AppDelegate: MessagingDelegate {
    // When Token Upate Call
    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        
        UserDefaults.standard.set(fcmToken!, forKey: "DeviceToken")
        let tokenDict = ["token": fcmToken ?? ""]
        
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: tokenDict)
        
    }
}
