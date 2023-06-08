# iOSPushManagerSDK

## Installation 

1- iOSPushManagerSDK is available through [Swift Package Manager](https://swift.org/package-manager/). Add iOSPushManagerSDK as a dependency to your `Package.swift`:

```Swift
.package(url: "https://github.com/esatgozcu/iOSPushManagerSDK", from: "main")
```

2- Click the Signing & Capabilities tab and then click the + Capability button. Add Push Notification Capability.

## Usage

#### AppDelegate example implementation

```swift

import TestNotificationSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate, TestNotificationSDKProtocol {
    
    var window: UIWindow?
    var pushSDK: TestNotificationSDK?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        pushSDK = TestNotificationSDK()
        pushSDK?.tokenDelegate = self
        pushSDK?.requestAuthorizationSettings({ result in
            guard result else { return }
            
            self.pushSDK?.registerPushNotificationService()
            self.pushSDK?.checkPushNotificationService({ result, error in
                if result{
                    print("Push Notification Service is working")
                }
                else{
                    print("Push Notification Service is not working because \(error.debugDescription)")
                }
            })
            self.pushSDK?.getAuthorizationSettings({ granted in
                print("Authorization Settings Result: \(granted)")
            })
        })
        return true
    }
    func getToken(token: String) {
        print("Device Token: \(token)")
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        pushSDK?.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken: deviceToken)
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        pushSDK?.didFailToRegisterForRemoteNotificationsWithError(error: error)
    }
}

```

## Testing

Use a text editor to create a file called test.apn, which you’ll pass to Xcode’s simctl utility. Paste in the following JSON text and save the file.

```
{
  "aps": {
    "alert": "Test Notification",
    "sound": "default",
    "link_url": ""
  }
}
```

Open the Terminal app and change to the directory where you saved test.apn

```
xcrun simctl push device_identifier bundle_identifier test.apn
```
