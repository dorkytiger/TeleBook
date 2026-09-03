import Flutter
import UIKit

/// iOS 后台传输器（原生 URLSession background session）。
///
/// - 下载：整批文件交给本类，原生内部维护**队列**（最多并发 N 个），
///   完成一个 delegate 里自动创建下一个 → App 锁屏/挂起甚至被杀后，
///   系统与原生会持续推进整批，不再依赖 Dart 逐张 await。
/// - 上传：整文件直传（uploadTask fromFile → /files/upload/direct）。
///
/// 完成/失败通过 MethodChannel 回传 Flutter（onDownloaded / onUploaded）。
class SyncBackgroundDownloader: NSObject, URLSessionDownloadDelegate {
    static let shared = SyncBackgroundDownloader()

    static let sessionIdentifier = "telebook.background.file.transfer"

    private struct PendingDownload {
        let urlStr: String
        let headers: [String: String]
        let destPath: String
        let hash: String
        let uuid: String
        let relPath: String
    }

    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: SyncBackgroundDownloader.sessionIdentifier)
        config.isDiscretionary = false
        config.sessionSendsLaunchEvents = true
        config.timeoutIntervalForRequest = 300
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()

    private var channel: FlutterMethodChannel?

    // 下载队列与并发
    private var queue: [PendingDownload] = []
    private var activeDownloads = 0
    private let maxConcurrent = 2

    /// 进行中下载任务：taskIdentifier -> meta
    private var meta: [Int: (hash: String, uuid: String, relPath: String, destPath: String)] = [:]
    /// 进行中的直传任务：taskIdentifier -> hash
    private var uploadMeta: [Int: String] = [:]

    private var backgroundCompletion: (() -> Void)?

    private override init() {
        super.init()
    }

    func register(messenger: FlutterBinaryMessenger) {
        channel = FlutterMethodChannel(name: "telebook/ios_bg_transfer", binaryMessenger: messenger)
        channel?.setMethodCallHandler { [weak self] call, result in
            guard let self = self else {
                result(FlutterError(code: "dead", message: "downloader deallocated", details: nil))
                return
            }
            switch call.method {
            case "enqueueDownload":
                guard let args = call.arguments as? [String: Any],
                      let urlStr = args["url"] as? String,
                      let destPath = args["destPath"] as? String,
                      let hash = args["hash"] as? String,
                      let uuid = args["uuid"] as? String,
                      let relPath = args["relPath"] as? String,
                      URL(string: urlStr) != nil
                else {
                    result(FlutterError(code: "bad_args", message: "invalid enqueue args", details: nil))
                    return
                }
                let headers = (args["headers"] as? [String: String]) ?? [:]
                self.enqueueDownload(urlStr: urlStr, headers: headers, destPath: destPath,
                                     hash: hash, uuid: uuid, relPath: relPath)
                result(true)
            case "enqueueDownloadBatch":
                guard let args = call.arguments as? [String: Any],
                      let items = args["items"] as? [[String: Any]]
                else {
                    result(FlutterError(code: "bad_args", message: "invalid batch args", details: nil))
                    return
                }
                var count = 0
                for it in items {
                    guard let urlStr = it["url"] as? String,
                          let destPath = it["destPath"] as? String,
                          let hash = it["hash"] as? String,
                          let uuid = it["uuid"] as? String,
                          let relPath = it["relPath"] as? String,
                          URL(string: urlStr) != nil
                    else { continue }
                    let headers = (it["headers"] as? [String: String]) ?? [:]
                    self.enqueueDownload(urlStr: urlStr, headers: headers, destPath: destPath,
                                         hash: hash, uuid: uuid, relPath: relPath)
                    count += 1
                }
                result(count > 0)
            case "enqueueUpload":
                guard let args = call.arguments as? [String: Any],
                      let urlStr = args["url"] as? String,
                      let filePath = args["filePath"] as? String,
                      let hash = args["hash"] as? String,
                      let remoteURL = URL(string: urlStr)
                else {
                    result(FlutterError(code: "bad_args", message: "invalid enqueue args", details: nil))
                    return
                }
                let headers = (args["headers"] as? [String: String]) ?? [:]
                guard FileManager.default.fileExists(atPath: filePath) else {
                    result(FlutterError(code: "no_file", message: "upload file missing", details: nil))
                    return
                }
                var request = URLRequest(url: remoteURL)
                request.httpMethod = "POST"
                for (k, v) in headers {
                    request.setValue(v, forHTTPHeaderField: k)
                }
                let task = self.session.uploadTask(with: request, fromFile: URL(fileURLWithPath: filePath))
                self.uploadMeta[task.taskIdentifier] = hash
                task.resume()
                result(true)
            case "cancelAll":
                self.session.getAllTasks { tasks in
                    tasks.forEach { $0.cancel() }
                }
                self.queue.removeAll()
                result(nil)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }

    // MARK: - 下载队列

    private func enqueueDownload(urlStr: String, headers: [String: String], destPath: String,
                                 hash: String, uuid: String, relPath: String) {
        queue.append(PendingDownload(urlStr: urlStr, headers: headers, destPath: destPath,
                                     hash: hash, uuid: uuid, relPath: relPath))
        pump()
    }

    /// 把落盘元数据编码进 URL query（服务端忽略多余参数）。
    /// App 被杀后系统仍会完成已创建的任务；重拉时 delegate 里内存 meta 已丢，
    /// 用 originalRequest 里的参数恢复目标路径，继续落盘并回传。
    private func augmented(_ url: String, _ uuid: String, _ rel: String, _ dest: String) -> String {
        func enc(_ s: String) -> String {
            s.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? s
        }
        return url + "&_uuid=" + enc(uuid) + "&_rel=" + enc(rel) + "&_dest=" + enc(dest)
    }

    private func metaFrom(request: URLRequest?) -> (hash: String, uuid: String, relPath: String, destPath: String)? {
        guard let url = request?.url,
              let comps = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let items = comps.queryItems
        else { return nil }
        func val(_ n: String) -> String? { items.first(where: { $0.name == n })?.value }
        guard let h = val("hash"), let u = val("_uuid"), let r = val("_rel"), let d = val("_dest") else { return nil }
        return (h, u, r, d)
    }

    /// 空闲时从队首创建下载任务（delegate 完成/失败后会自动继续，直到队列清空）。
    private func pump() {
        while activeDownloads < maxConcurrent && !queue.isEmpty {
            let item = queue.removeFirst()
            let urlStr = augmented(item.urlStr, item.uuid, item.relPath, item.destPath)
            var request = URLRequest(url: URL(string: urlStr)!)
            request.httpMethod = "GET"
            for (k, v) in item.headers {
                request.setValue(v, forHTTPHeaderField: k)
            }
            let task = session.downloadTask(with: request)
            meta[task.taskIdentifier] = (item.hash, item.uuid, item.relPath, item.destPath)
            activeDownloads += 1
            task.resume()
        }
    }

    /// 由 AppDelegate 在 handleEventsForBackgroundURLSession 里调用。
    func handleBackgroundSession(identifier: String, completion: @escaping () -> Void) {
        guard identifier == SyncBackgroundDownloader.sessionIdentifier else {
            completion()
            return
        }
        backgroundCompletion = completion
    }

    private func notify(_ ok: Bool, hash: String, uuid: String, relPath: String, destPath: String, error: String?) {
        channel?.invokeMethod("onDownloaded", arguments: [
            "ok": ok,
            "hash": hash,
            "uuid": uuid,
            "relPath": relPath,
            "destPath": destPath,
            "error": error,
        ])
    }

    // MARK: - URLSessionDownloadDelegate

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        // 优先内存 meta；被杀后重拉时内存丢失 → 从请求参数恢复
        var m = meta[downloadTask.taskIdentifier]
        if m == nil {
            m = metaFrom(request: downloadTask.originalRequest)
        }
        guard let m = m else { return }
        do {
            let dest = URL(fileURLWithPath: m.destPath)
            try FileManager.default.createDirectory(at: dest.deletingLastPathComponent(),
                                                    withIntermediateDirectories: true)
            if FileManager.default.fileExists(atPath: m.destPath) {
                try FileManager.default.removeItem(at: dest)
            }
            try FileManager.default.moveItem(at: location, to: dest)
            DispatchQueue.main.async {
                self.meta.removeValue(forKey: downloadTask.taskIdentifier)
                self.activeDownloads -= 1
                self.notify(true, hash: m.hash, uuid: m.uuid, relPath: m.relPath,
                            destPath: m.destPath, error: nil)
                self.pump()
            }
        } catch {
            DispatchQueue.main.async {
                self.meta.removeValue(forKey: downloadTask.taskIdentifier)
                self.activeDownloads -= 1
                self.notify(false, hash: m.hash, uuid: m.uuid, relPath: m.relPath,
                            destPath: m.destPath, error: error.localizedDescription)
                self.pump()
            }
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        // 直传任务
        if let hash = uploadMeta.removeValue(forKey: task.taskIdentifier) {
            DispatchQueue.main.async {
                self.channel?.invokeMethod("onUploaded", arguments: [
                    "ok": error == nil,
                    "hash": hash,
                    "error": error?.localizedDescription,
                ])
            }
            return
        }
        // 下载失败（成功路径在 didFinishDownloadingTo 里已处理并移除 meta；
        // didCompleteWithError 在成功时也会以 error=nil 回调 → 必须 error 非空才算失败）
        guard let error = error else { return }
        var m = meta[task.taskIdentifier]
        if m == nil {
            m = metaFrom(request: task.originalRequest)
        }
        if let m = m {
            DispatchQueue.main.async {
                self.meta.removeValue(forKey: task.taskIdentifier)
                self.activeDownloads -= 1
                self.notify(false, hash: m.hash, uuid: m.uuid, relPath: m.relPath,
                            destPath: m.destPath, error: error.localizedDescription)
                self.pump()
            }
        }
    }

    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            // 被系统重新拉起后：把剩余队列继续派发
            self.pump()
            self.backgroundCompletion?()
            self.backgroundCompletion = nil
        }
    }
}
