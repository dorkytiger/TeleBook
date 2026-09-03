// final packageInfoProvider = FutureProvider<PackageInfo>((ref) {
//   return PackageInfo.fromPlatform();
// });

import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'package_info_service.g.dart';

@Riverpod(keepAlive: true)
class PackageInfoService extends _$PackageInfoService {
  @override
  Future<PackageInfo> build() => PackageInfo.fromPlatform();
}
