import 'package:get/get.dart';
import 'package:tele_book/app/service/download_service.dart';

class DownloadTaskController extends GetxController {
  final groupId = Get.arguments as String;
  final downloadService = Get.find<DownloadService>();
}
