// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 客户端同步引擎：连接配置 / 设备注册 / 手动全量同步（书籍元数据 + 图片文件）。

@ProviderFor(SyncService)
final syncServiceProvider = SyncServiceProvider._();

/// 客户端同步引擎：连接配置 / 设备注册 / 手动全量同步（书籍元数据 + 图片文件）。
final class SyncServiceProvider extends $NotifierProvider<SyncService, void> {
  /// 客户端同步引擎：连接配置 / 设备注册 / 手动全量同步（书籍元数据 + 图片文件）。
  SyncServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncServiceHash();

  @$internal
  @override
  SyncService create() => SyncService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$syncServiceHash() => r'd35a2b07b04fe1c9d6ebbf0b6205aea4a790d7d4';

/// 客户端同步引擎：连接配置 / 设备注册 / 手动全量同步（书籍元数据 + 图片文件）。

abstract class _$SyncService extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
