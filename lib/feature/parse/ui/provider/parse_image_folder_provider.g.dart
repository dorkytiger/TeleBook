// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parse_image_folder_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ParseImageFolder)
final parseImageFolderProvider = ParseImageFolderFamily._();

final class ParseImageFolderProvider
    extends $AsyncNotifierProvider<ParseImageFolder, ParseImageFolderState> {
  ParseImageFolderProvider._({
    required ParseImageFolderFamily super.from,
    required ParseImageFolderParam super.argument,
  }) : super(
         retry: null,
         name: r'parseImageFolderProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$parseImageFolderHash();

  @override
  String toString() {
    return r'parseImageFolderProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ParseImageFolder create() => ParseImageFolder();

  @override
  bool operator ==(Object other) {
    return other is ParseImageFolderProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$parseImageFolderHash() => r'502fcc52a19f50c2e1a179cecb9a08d68f294107';

final class ParseImageFolderFamily extends $Family
    with
        $ClassFamilyOverride<
          ParseImageFolder,
          AsyncValue<ParseImageFolderState>,
          ParseImageFolderState,
          FutureOr<ParseImageFolderState>,
          ParseImageFolderParam
        > {
  ParseImageFolderFamily._()
    : super(
        retry: null,
        name: r'parseImageFolderProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ParseImageFolderProvider call(ParseImageFolderParam param) =>
      ParseImageFolderProvider._(argument: param, from: this);

  @override
  String toString() => r'parseImageFolderProvider';
}

abstract class _$ParseImageFolder
    extends $AsyncNotifier<ParseImageFolderState> {
  late final _$args = ref.$arg as ParseImageFolderParam;
  ParseImageFolderParam get param => _$args;

  FutureOr<ParseImageFolderState> build(ParseImageFolderParam param);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<ParseImageFolderState>, ParseImageFolderState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<ParseImageFolderState>,
                ParseImageFolderState
              >,
              AsyncValue<ParseImageFolderState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(ParseImageFolderSaveBook)
final parseImageFolderSaveBookProvider = ParseImageFolderSaveBookFamily._();

final class ParseImageFolderSaveBookProvider
    extends $AsyncNotifierProvider<ParseImageFolderSaveBook, void> {
  ParseImageFolderSaveBookProvider._({
    required ParseImageFolderSaveBookFamily super.from,
    required ParseImageFolderParam super.argument,
  }) : super(
         retry: null,
         name: r'parseImageFolderSaveBookProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$parseImageFolderSaveBookHash();

  @override
  String toString() {
    return r'parseImageFolderSaveBookProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ParseImageFolderSaveBook create() => ParseImageFolderSaveBook();

  @override
  bool operator ==(Object other) {
    return other is ParseImageFolderSaveBookProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$parseImageFolderSaveBookHash() =>
    r'fc220b9ace388c644d52aa5c23ef0f8f0f2c2074';

final class ParseImageFolderSaveBookFamily extends $Family
    with
        $ClassFamilyOverride<
          ParseImageFolderSaveBook,
          AsyncValue<void>,
          void,
          FutureOr<void>,
          ParseImageFolderParam
        > {
  ParseImageFolderSaveBookFamily._()
    : super(
        retry: null,
        name: r'parseImageFolderSaveBookProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ParseImageFolderSaveBookProvider call(ParseImageFolderParam param) =>
      ParseImageFolderSaveBookProvider._(argument: param, from: this);

  @override
  String toString() => r'parseImageFolderSaveBookProvider';
}

abstract class _$ParseImageFolderSaveBook extends $AsyncNotifier<void> {
  late final _$args = ref.$arg as ParseImageFolderParam;
  ParseImageFolderParam get param => _$args;

  FutureOr<void> build(ParseImageFolderParam param);
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
    element.handleCreate(ref, () => build(_$args));
  }
}
