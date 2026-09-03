// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_info_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PackageInfoService)
final packageInfoServiceProvider = PackageInfoServiceProvider._();

final class PackageInfoServiceProvider
    extends $AsyncNotifierProvider<PackageInfoService, PackageInfo> {
  PackageInfoServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'packageInfoServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$packageInfoServiceHash();

  @$internal
  @override
  PackageInfoService create() => PackageInfoService();
}

String _$packageInfoServiceHash() =>
    r'7bd52ce5390a29053c12b3c024344431ca0c08ae';

abstract class _$PackageInfoService extends $AsyncNotifier<PackageInfo> {
  FutureOr<PackageInfo> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PackageInfo>, PackageInfo>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PackageInfo>, PackageInfo>,
              AsyncValue<PackageInfo>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
