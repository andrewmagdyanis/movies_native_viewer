import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let deviceChannel = FlutterMethodChannel(name: "test.flutter.methodchannel/iOS",
                                                 binaryMessenger: controller.binaryMessenger)
        prepareMethodHandler(deviceChannel: deviceChannel)

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func prepareMethodHandler(deviceChannel: FlutterMethodChannel) {
        deviceChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if call.method == "getDeviceModel" {
                self.receiveDeviceModel(result: result)
            }
            else {
                result(FlutterMethodNotImplemented)
                return
            }
        })
    }

    private func receiveDeviceModel(result: FlutterResult) {
        let deviceModel = UIDevice.current.model
        result(deviceModel)
    }
}