// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parse_batch_image_folder.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ParseBatchImageFolder)
final parseBatchImageFolderProvider = ParseBatchImageFolderFamily._();

final class ParseBatchImageFolderProvider
    extends
        $AsyncNotifierProvider<
          ParseBatchImageFolder,
          ParseBatchImageFolderState
        > {
  ParseBatchImageFolderProvider._({
    required ParseBatchImageFolderFamily super.from,
    required ParseBatchImageFolderParam super.argument,
  }) : super(
         retry: null,
         name: r'parseBatchImageFolderProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$parseBatchImageFolderHash();

  @override
  String toString() {
    return r'parseBatchImageFolderProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ParseBatchImageFolder create() => ParseBatchImageFolder();

  @override
  bool operator ==(Object other) {
    return other is ParseBatchImageFolderProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$parseBatchImageFolderHash() =>
    r'e1705d70a73923c87e96ca709fcfeb8903173595';

final class ParseBatchImageFolderFamily extends $Family
    with
        $ClassFamilyOverride<
          ParseBatchImageFolder,
          AsyncValue<ParseBatchImageFolderState>,
          ParseBatchImageFolderState,
          FutureOr<ParseBatchImageFolderState>,
          ParseBatchImageFolderParam
        > {
  ParseBatchImageFolderFamily._()
    : super(
        retry: null,
        name: r'parseBatchImageFolderProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ParseBatchImageFolderProvider call(ParseBatchImageFolderParam param) =>
      ParseBatchImageFolderProvider._(argument: param, from: this);

  @override
  String toString() => r'parseBatchImageFolderProvider';
}

abstract class _$ParseBatchImageFolder
    extends $AsyncNotifier<ParseBatchImageFolderState> {
  late final _$args = ref.$arg as ParseBatchImageFolderParam;
  ParseBatchImageFolderParam get param => _$args;

  FutureOr<ParseBatchImageFolderState> build(ParseBatchImageFolderParam param);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<ParseBatchImageFolderState>,
              ParseBatchImageFolderState
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<ParseBatchImageFolderState>,
                ParseBatchImageFolderState
              >,
              AsyncValue<ParseBatchImageFolderState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(SaveBatchAsBook)
final saveBatchAsBookProvider = SaveBatchAsBookFamily._();

final class SaveBatchAsBookProvider
    extends $NotifierProvider<SaveBatchAsBook, SaveBatchAsBookState> {
  SaveBatchAsBookProvider._({
    required SaveBatchAsBookFamily super.from,
    required ParseBatchImageFolderParam super.argument,
  }) : super(
         retry: null,
         name: r'saveBatchAsBookProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$saveBatchAsBookHash();

  @override
  String toString() {
    return r'saveBatchAsBookProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SaveBatchAsBook create() => SaveBatchAsBook();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SaveBatchAsBookState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SaveBatchAsBookState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SaveBatchAsBookProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$saveBatchAsBookHash() => r'aca3134e86c0e740a17d3e20b69c137043d9bb74';

final class SaveBatchAsBookFamily extends $Family
    with
        $ClassFamilyOverride<
          SaveBatchAsBook,
          SaveBatchAsBookState,
          SaveBatchAsBookState,
          SaveBatchAsBookState,
          ParseBatchImageFolderParam
        > {
  SaveBatchAsBookFamily._()
    : super(
        retry: null,
        name: r'saveBatchAsBookProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SaveBatchAsBookProvider call(ParseBatchImageFolderParam param) =>
      SaveBatchAsBookProvider._(argument: param, from: this);

  @override
  String toString() => r'saveBatchAsBookProvider';
}

abstract class _$SaveBatchAsBook extends $Notifier<SaveBatchAsBookState> {
  late final _$args = ref.$arg as ParseBatchImageFolderParam;
  ParseBatchImageFolderParam get param => _$args;

  SaveBatchAsBookState build(ParseBatchImageFolderParam param);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SaveBatchAsBookState, SaveBatchAsBookState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SaveBatchAsBookState, SaveBatchAsBookState>,
              SaveBatchAsBookState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
