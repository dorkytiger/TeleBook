// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parse_batch_archive_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ParseBatchArchive)
final parseBatchArchiveProvider = ParseBatchArchiveFamily._();

final class ParseBatchArchiveProvider
    extends $AsyncNotifierProvider<ParseBatchArchive, ParseBatchArchiveState> {
  ParseBatchArchiveProvider._({
    required ParseBatchArchiveFamily super.from,
    required ParseBatchArchiveParam super.argument,
  }) : super(
         retry: null,
         name: r'parseBatchArchiveProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$parseBatchArchiveHash();

  @override
  String toString() {
    return r'parseBatchArchiveProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ParseBatchArchive create() => ParseBatchArchive();

  @override
  bool operator ==(Object other) {
    return other is ParseBatchArchiveProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$parseBatchArchiveHash() => r'4c2d0a3ec18de530d0397b1453fe0bbdaf5e5639';

final class ParseBatchArchiveFamily extends $Family
    with
        $ClassFamilyOverride<
          ParseBatchArchive,
          AsyncValue<ParseBatchArchiveState>,
          ParseBatchArchiveState,
          FutureOr<ParseBatchArchiveState>,
          ParseBatchArchiveParam
        > {
  ParseBatchArchiveFamily._()
    : super(
        retry: null,
        name: r'parseBatchArchiveProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ParseBatchArchiveProvider call(ParseBatchArchiveParam param) =>
      ParseBatchArchiveProvider._(argument: param, from: this);

  @override
  String toString() => r'parseBatchArchiveProvider';
}

abstract class _$ParseBatchArchive
    extends $AsyncNotifier<ParseBatchArchiveState> {
  late final _$args = ref.$arg as ParseBatchArchiveParam;
  ParseBatchArchiveParam get param => _$args;

  FutureOr<ParseBatchArchiveState> build(ParseBatchArchiveParam param);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<ParseBatchArchiveState>, ParseBatchArchiveState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<ParseBatchArchiveState>,
                ParseBatchArchiveState
              >,
              AsyncValue<ParseBatchArchiveState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(ParseBatchArchiveSaveBook)
final parseBatchArchiveSaveBookProvider = ParseBatchArchiveSaveBookProvider._();

final class ParseBatchArchiveSaveBookProvider
    extends $AsyncNotifierProvider<ParseBatchArchiveSaveBook, void> {
  ParseBatchArchiveSaveBookProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'parseBatchArchiveSaveBookProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$parseBatchArchiveSaveBookHash();

  @$internal
  @override
  ParseBatchArchiveSaveBook create() => ParseBatchArchiveSaveBook();
}

String _$parseBatchArchiveSaveBookHash() =>
    r'990b49c199855638b06aa45a0256fa98ba4a739f';

abstract class _$ParseBatchArchiveSaveBook extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
