// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parse_archive_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ParseArchive)
final parseArchiveProvider = ParseArchiveFamily._();

final class ParseArchiveProvider
    extends $AsyncNotifierProvider<ParseArchive, ParseArchiveState> {
  ParseArchiveProvider._({
    required ParseArchiveFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'parseArchiveProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$parseArchiveHash();

  @override
  String toString() {
    return r'parseArchiveProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ParseArchive create() => ParseArchive();

  @override
  bool operator ==(Object other) {
    return other is ParseArchiveProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$parseArchiveHash() => r'550d2a3343eafbb33bc33f18bb234ffd12ead4d7';

final class ParseArchiveFamily extends $Family
    with
        $ClassFamilyOverride<
          ParseArchive,
          AsyncValue<ParseArchiveState>,
          ParseArchiveState,
          FutureOr<ParseArchiveState>,
          String
        > {
  ParseArchiveFamily._()
    : super(
        retry: null,
        name: r'parseArchiveProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ParseArchiveProvider call(String archivePath) =>
      ParseArchiveProvider._(argument: archivePath, from: this);

  @override
  String toString() => r'parseArchiveProvider';
}

abstract class _$ParseArchive extends $AsyncNotifier<ParseArchiveState> {
  late final _$args = ref.$arg as String;
  String get archivePath => _$args;

  FutureOr<ParseArchiveState> build(String archivePath);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<ParseArchiveState>, ParseArchiveState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ParseArchiveState>, ParseArchiveState>,
              AsyncValue<ParseArchiveState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(ParseArchiveSaveBook)
final parseArchiveSaveBookProvider = ParseArchiveSaveBookProvider._();

final class ParseArchiveSaveBookProvider
    extends $AsyncNotifierProvider<ParseArchiveSaveBook, void> {
  ParseArchiveSaveBookProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'parseArchiveSaveBookProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$parseArchiveSaveBookHash();

  @$internal
  @override
  ParseArchiveSaveBook create() => ParseArchiveSaveBook();
}

String _$parseArchiveSaveBookHash() =>
    r'731cd951752090666be1330594b8248c21d50f2f';

abstract class _$ParseArchiveSaveBook extends $AsyncNotifier<void> {
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
