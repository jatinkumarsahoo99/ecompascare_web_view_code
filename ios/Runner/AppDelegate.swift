import UIKit
import Flutter
import Firebase
import FirebaseCore

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
        FirebaseApp.configure()
        
        // OneSignal initialization
        // OneSignal.initWithLaunchOptions(launchOptions)
        // OneSignal.setAppId("ee1713d2-e9c2-4bf2-9613-7456d1dad45e")
        
        // promptForPushNotifications will show the native iOS notification permission prompt.
        // We recommend removing the following code and instead using an In-App Message to prompt for notification permission (See step 8)
        // OneSignal.promptForPushNotifications(userResponse: { accepted in
        //   print("User accepted notifications: \(accepted)")
        // })
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
