import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    let controller:FlutterViewController = self.window.rootViewController as! FlutterViewController
    let shareChannel = FlutterMethodChannel.init(name: "channel:Chenli", binaryMessenger: controller)
    shareChannel .setMethodCallHandler { (call, result) in
        if ("ChenliShareFile" == call.method) {
            //这里调用
//            print("这里使用flutter里面传递的参数：%@",call.arguments);
            let alert = UIActivityViewController.init(activityItems: [call.arguments ?? " "], applicationActivities: nil)
            controller .present(alert, animated: true, completion: nil)
            //这里iOS传递参数给flutter
//            result("😂😂，flutter七夕还是单身吗？")
        }
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
