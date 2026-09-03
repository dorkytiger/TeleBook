// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(VersionService)
final versionServiceProvider = VersionServiceProvider._();

final class VersionServiceProvider
    extends $AsyncNotifierProvider<VersionService, UpdateInfo?> {
  VersionServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'versionServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$versionServiceHash();

  @$internal
  @override
  VersionService create() => VersionService();
}

String _$versionServiceHash() => r'3dad0c94897650b59f18c50545b45fde8fe74533';

abstract class _$VersionService extends $AsyncNotifier<UpdateInfo?> {
  FutureOr<UpdateInfo?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<UpdateInfo?>, UpdateInfo?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UpdateInfo?>, UpdateInfo?>,
              AsyncValue<UpdateInfo?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
