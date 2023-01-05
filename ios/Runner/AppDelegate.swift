import UIKit
import Flutter
import workmanager
// import AppTrackingTransparency

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    WorkmanagerPlugin.registerTask(withIdentifier: "task-identifier")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//    if @aviailable(iOS 14, *) {
//      ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
//        // Tracking authorization completed. Start loading ads here.
//      })
//    } else {
//      // Fallback on earlier versions
//    }
      
  }
}
