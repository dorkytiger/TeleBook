// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ReadingDirectionSetting)
final readingDirectionSettingProvider = ReadingDirectionSettingProvider._();

final class ReadingDirectionSettingProvider
    extends $AsyncNotifierProvider<ReadingDirectionSetting, ReadingDirection> {
  ReadingDirectionSettingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'readingDirectionSettingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$readingDirectionSettingHash();

  @$internal
  @override
  ReadingDirectionSetting create() => ReadingDirectionSetting();
}

String _$readingDirectionSettingHash() =>
    r'b675dc4745b0c3fc431a6c9a1af6fa2abbab4ea5';

abstract class _$ReadingDirectionSetting
    extends $AsyncNotifier<ReadingDirection> {
  FutureOr<ReadingDirection> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<ReadingDirection>, ReadingDirection>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ReadingDirection>, ReadingDirection>,
              AsyncValue<ReadingDirection>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
