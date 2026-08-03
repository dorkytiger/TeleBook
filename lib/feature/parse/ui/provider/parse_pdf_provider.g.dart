// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parse_pdf_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ParsePdf)
final parsePdfProvider = ParsePdfFamily._();

final class ParsePdfProvider
    extends $AsyncNotifierProvider<ParsePdf, ParsePdfState> {
  ParsePdfProvider._({
    required ParsePdfFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'parsePdfProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$parsePdfHash();

  @override
  String toString() {
    return r'parsePdfProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ParsePdf create() => ParsePdf();

  @override
  bool operator ==(Object other) {
    return other is ParsePdfProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$parsePdfHash() => r'e0b05363d6c097e4b8c3141968eb773d58e94b26';

final class ParsePdfFamily extends $Family
    with
        $ClassFamilyOverride<
          ParsePdf,
          AsyncValue<ParsePdfState>,
          ParsePdfState,
          FutureOr<ParsePdfState>,
          String
        > {
  ParsePdfFamily._()
    : super(
        retry: null,
        name: r'parsePdfProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ParsePdfProvider call(String pdfPath) =>
      ParsePdfProvider._(argument: pdfPath, from: this);

  @override
  String toString() => r'parsePdfProvider';
}

abstract class _$ParsePdf extends $AsyncNotifier<ParsePdfState> {
  late final _$args = ref.$arg as String;
  String get pdfPath => _$args;

  FutureOr<ParsePdfState> build(String pdfPath);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ParsePdfState>, ParsePdfState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ParsePdfState>, ParsePdfState>,
              AsyncValue<ParsePdfState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(ParsePdfSaveBook)
final parsePdfSaveBookProvider = ParsePdfSaveBookProvider._();

final class ParsePdfSaveBookProvider
    extends $AsyncNotifierProvider<ParsePdfSaveBook, void> {
  ParsePdfSaveBookProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'parsePdfSaveBookProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$parsePdfSaveBookHash();

  @$internal
  @override
  ParsePdfSaveBook create() => ParsePdfSaveBook();
}

String _$parsePdfSaveBookHash() => r'2bb199c158dc082cd536e8a9bc71eb25994461fc';

abstract class _$ParsePdfSaveBook extends $AsyncNotifier<void> {
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
