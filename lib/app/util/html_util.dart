import 'package:html/parser.dart';

class HtmlUtil {
  static List<String> getImgUrls(String url, String body) {
    final document = parse(body);
    final imgElements = document.querySelectorAll('img');
    final baseUrl = Uri.parse(url);
    final imgUrls = imgElements.map((element) {
      final src = element.attributes['src'] ?? "";
      final uri = Uri.parse(src);
      return uri.isAbsolute ? src : baseUrl.resolveUri(uri).toString();
    }).toList();
    return imgUrls;
  }

  static String getTitle(String body) {
    final document = parse(body);
    final titleElement = document.querySelector('h1');
    return titleElement?.text ?? "";
  }
}
