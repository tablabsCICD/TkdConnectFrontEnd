import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
GMSServices.provideAPIKey("AIzaSyAm332fBuy8QoCC6ZFv7pizIqdmaT-jz30AIzaSyAm332fBuy8QoCC6ZFv7pizIqdmaT-jz30")

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
