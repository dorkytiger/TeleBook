import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:tele_book/app/widget/cross_platform_webview.dart';

class HtmlUtil {
  static Future<String> extractTitleFromWebView(
    CrossPlatformWebViewController controller,
  ) async {
    final js = r"""
    (function(){
      try {
        var h1 = document.querySelector('h1');
        return h1 ? h1.innerText : '';
      } catch(e) { return ''; }
    })();
  """;
    final resObj = await controller.runJavaScriptReturningResult(js);

    // 将返回的 Object 安全地转为字符串
    if (resObj is String) {
      return resObj.trim();
    } else {
      return resObj.toString();
    }
  }

  static Future<List<String>> extractImagesFromWebView(
    CrossPlatformWebViewController controller,
  ) async {
    final js = r"""
    (function(){
      try {
        var imgs = Array.from(document.images).map(i=>i.src || i.getAttribute('data-src') || '').filter(Boolean);
        var bgs = Array.from(document.querySelectorAll('*')).map(el=>{
          var bg = getComputedStyle(el).backgroundImage || '';
          if(bg && bg!='none') return bg.replace(/url\((['"])?(.*?)\1\)/g,'$2');
          return '';
        }).filter(Boolean);
        var result = Array.from(new Set(imgs.concat(bgs)));
        console.log('Extracted ' + result.length + ' images');
        return JSON.stringify(result);
      } catch(e) { 
        console.error('Error extracting images: ' + e.message);
        return JSON.stringify([]); 
      }
    })();
  """;
    final resObj = await controller.runJavaScriptReturningResult(js);

    // 将返回的 Object 安全地转为字符串
    String resString;
    if (resObj is String) {
      resString = resObj;
    } else if (resObj is List || resObj is Map) {
      // 直接编码为 JSON 字符串
      resString = jsonEncode(resObj);
    } else {
      resString = resObj.toString();
    }

    // 尝试解析为 List\<String\>，兼容已转义或二次转义的 JSON 字符串
    try {
      final decoded = jsonDecode(resString);
      if (decoded is String) {
        final decoded2 = jsonDecode(decoded);
        return (decoded2 as List).cast<String>();
      } else if (decoded is List) {
        return decoded.cast<String>();
      } else {
        return <String>[];
      }
    } catch (_) {
      // 兜底：返回空列表而不是抛异常
      return <String>[];
    }
  }

  static Future<String> downloadImageToFile(String url, String saveDir) async {
    final filePath =
        '$saveDir/${DateTime.now().microsecondsSinceEpoch}_${url.split('/').last}.jpg';
    final dio = Dio();
    await dio.download(url, filePath);
    return filePath;
  }
}
