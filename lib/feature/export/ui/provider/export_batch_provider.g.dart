// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_batch_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ExportBatch)
final exportBatchProvider = ExportBatchFamily._();

final class ExportBatchProvider
    extends $NotifierProvider<ExportBatch, ExportBatchState> {
  ExportBatchProvider._({
    required ExportBatchFamily super.from,
    required List<int> super.argument,
  }) : super(
         retry: null,
         name: r'exportBatchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$exportBatchHash();

  @override
  String toString() {
    return r'exportBatchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ExportBatch create() => ExportBatch();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExportBatchState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExportBatchState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ExportBatchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$exportBatchHash() => r'381ce8622ce76a44b9560027cece6f59244c8dfc';

final class ExportBatchFamily extends $Family
    with
        $ClassFamilyOverride<
          ExportBatch,
          ExportBatchState,
          ExportBatchState,
          ExportBatchState,
          List<int>
        > {
  ExportBatchFamily._()
    : super(
        retry: null,
        name: r'exportBatchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ExportBatchProvider call(List<int> bookIds) =>
      ExportBatchProvider._(argument: bookIds, from: this);

  @override
  String toString() => r'exportBatchProvider';
}

abstract class _$ExportBatch extends $Notifier<ExportBatchState> {
  late final _$args = ref.$arg as List<int>;
  List<int> get bookIds => _$args;

  ExportBatchState build(List<int> bookIds);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ExportBatchState, ExportBatchState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ExportBatchState, ExportBatchState>,
              ExportBatchState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
