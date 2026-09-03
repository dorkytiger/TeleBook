// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_single_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ExportSingle)
final exportSingleProvider = ExportSingleFamily._();

final class ExportSingleProvider
    extends $NotifierProvider<ExportSingle, ExportSingleState> {
  ExportSingleProvider._({
    required ExportSingleFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'exportSingleProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$exportSingleHash();

  @override
  String toString() {
    return r'exportSingleProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ExportSingle create() => ExportSingle();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExportSingleState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExportSingleState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ExportSingleProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$exportSingleHash() => r'61bc10ec613b9eed5951296d4b2fcbefc006e0d3';

final class ExportSingleFamily extends $Family
    with
        $ClassFamilyOverride<
          ExportSingle,
          ExportSingleState,
          ExportSingleState,
          ExportSingleState,
          int
        > {
  ExportSingleFamily._()
    : super(
        retry: null,
        name: r'exportSingleProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ExportSingleProvider call(int bookId) =>
      ExportSingleProvider._(argument: bookId, from: this);

  @override
  String toString() => r'exportSingleProvider';
}

abstract class _$ExportSingle extends $Notifier<ExportSingleState> {
  late final _$args = ref.$arg as int;
  int get bookId => _$args;

  ExportSingleState build(int bookId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ExportSingleState, ExportSingleState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ExportSingleState, ExportSingleState>,
              ExportSingleState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
