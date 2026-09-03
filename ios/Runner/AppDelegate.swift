import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    // 注册 iOS 后台下载桥（URLSession background session）
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "SyncBackgroundDownloader") {
      SyncBackgroundDownloader.shared.register(messenger: registrar.messenger())
    }
  }

  /// App 被系统回收后，后台下载完成/失败会唤醒本方法：
  /// 交给 SyncBackgroundDownloader 统一处理并回调 completion。
  override func application(
    _ application: UIApplication,
    handleEventsForBackgroundURLSession identifier: String,
    completionHandler: @escaping () -> Void
  ) {
    SyncBackgroundDownloader.shared.handleBackgroundSession(
      identifier: identifier,
      completion: completionHandler
    )
  }
}
