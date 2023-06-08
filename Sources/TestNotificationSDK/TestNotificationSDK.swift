//
//  TestNotificationSDK
//
//  Created by Esat Gözcü on 2023/06/07.
//

import UserNotifications
import UIKit

public protocol TestNotificationSDKProtocol {
    func getToken(token: String)
}

public struct TestNotificationSDK {
    private(set) var deviceToken : Data?{
        didSet{
            tokenDelegate?.getToken(token: getSubscriptionToken())
        }
    }
    private(set) var failToRegisterWithError : Error?
    public var tokenDelegate : TestNotificationSDKProtocol?
    public init() {}
    
    public func requestAuthorizationSettings(_ grantedResult: @escaping((Bool)->())) {
        //UNUserNotificationCenter handles all notification-related activities in the app, including push notifications.
        UNUserNotificationCenter.current()
        //You invoke requestAuthorization(options:completionHandler:) to request authorization to show notifications. The passed options indicate the types of notifications you want your app to use — here you’re requesting alert, sound and badge.
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                //The completion handler receives a Bool that indicates whether authorization was successful.
                grantedResult(granted)
            }
    }
    public func getAuthorizationSettings(_ settingResult: @escaping((Bool)->())){
        //Check notification settings
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            settingResult(settings.authorizationStatus == .authorized)
        }
    }
    public func registerPushNotificationService(){
        DispatchQueue.main.async {
            //To kick off registration with the Apple Push Notification service
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    public func checkPushNotificationService(_ result: @escaping((Bool, Error?)->())){
        if let error = failToRegisterWithError{
            result(false, error)
        }
        result(true, nil)
    }
    private func getSubscriptionToken() -> String{
        //It’s provided by APNs and uniquely identifies this app on this particular device.
        let tokenParts = deviceToken?.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts?.joined()
        return token ?? ""
    }
    public mutating func didRegisterForRemoteNotificationsWithDeviceToken(deviceToken: Data){
        self.deviceToken = deviceToken
    }
    public mutating func didFailToRegisterForRemoteNotificationsWithError(error: Error){
        self.failToRegisterWithError = error
    }
}
