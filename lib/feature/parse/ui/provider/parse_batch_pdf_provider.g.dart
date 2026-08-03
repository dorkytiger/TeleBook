// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parse_batch_pdf_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ParseBatchPdf)
final parseBatchPdfProvider = ParseBatchPdfFamily._();

final class ParseBatchPdfProvider
    extends $AsyncNotifierProvider<ParseBatchPdf, ParseBatchPdfState> {
  ParseBatchPdfProvider._({
    required ParseBatchPdfFamily super.from,
    required ParseBatchPdfParam super.argument,
  }) : super(
         retry: null,
         name: r'parseBatchPdfProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$parseBatchPdfHash();

  @override
  String toString() {
    return r'parseBatchPdfProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ParseBatchPdf create() => ParseBatchPdf();

  @override
  bool operator ==(Object other) {
    return other is ParseBatchPdfProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$parseBatchPdfHash() => r'4528c3d2c95825540661e8230b492c74f4184a00';

final class ParseBatchPdfFamily extends $Family
    with
        $ClassFamilyOverride<
          ParseBatchPdf,
          AsyncValue<ParseBatchPdfState>,
          ParseBatchPdfState,
          FutureOr<ParseBatchPdfState>,
          ParseBatchPdfParam
        > {
  ParseBatchPdfFamily._()
    : super(
        retry: null,
        name: r'parseBatchPdfProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ParseBatchPdfProvider call(ParseBatchPdfParam param) =>
      ParseBatchPdfProvider._(argument: param, from: this);

  @override
  String toString() => r'parseBatchPdfProvider';
}

abstract class _$ParseBatchPdf extends $AsyncNotifier<ParseBatchPdfState> {
  late final _$args = ref.$arg as ParseBatchPdfParam;
  ParseBatchPdfParam get param => _$args;

  FutureOr<ParseBatchPdfState> build(ParseBatchPdfParam param);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<ParseBatchPdfState>, ParseBatchPdfState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ParseBatchPdfState>, ParseBatchPdfState>,
              AsyncValue<ParseBatchPdfState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(ParseBatchPdfSaveBook)
final parseBatchPdfSaveBookProvider = ParseBatchPdfSaveBookProvider._();

final class ParseBatchPdfSaveBookProvider
    extends $AsyncNotifierProvider<ParseBatchPdfSaveBook, void> {
  ParseBatchPdfSaveBookProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'parseBatchPdfSaveBookProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$parseBatchPdfSaveBookHash();

  @$internal
  @override
  ParseBatchPdfSaveBook create() => ParseBatchPdfSaveBook();
}

String _$parseBatchPdfSaveBookHash() =>
    r'4934b2ba4dd24931ffcef41c591f0331bcc18294';

abstract class _$ParseBatchPdfSaveBook extends $AsyncNotifier<void> {
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
