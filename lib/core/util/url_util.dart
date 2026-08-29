/// URL 规范化工具。
///
/// 用户输入的网址常常省略协议前缀（如 `example.com/a.jpg`），
/// 直接 `Uri.parse` 会得到相对 URI，导致 webview 加载失败
/// （`Missing scheme in uri`）。
library;

/// 规范化用户输入的网址：
/// - 去除首尾空白；
/// - 无 scheme 时自动补全 `https://`；
/// - 空输入或非法 URL 返回 `null`。
Uri? normalizeWebUrl(String input) {
  final trimmed = input.trim();
  if (trimmed.isEmpty) return null;

  final withScheme = trimmed.contains('://') ? trimmed : 'https://$trimmed';
  final uri = Uri.tryParse(withScheme);
  if (uri == null || !uri.hasScheme || uri.host.isEmpty) return null;
  return uri;
}
