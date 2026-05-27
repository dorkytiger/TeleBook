// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(collectionList)
final collectionListProvider = CollectionListProvider._();

final class CollectionListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CollectionListItemVo>>,
          AsyncValue<List<CollectionListItemVo>>,
          AsyncValue<List<CollectionListItemVo>>
        >
    with $Provider<AsyncValue<List<CollectionListItemVo>>> {
  CollectionListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'collectionListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$collectionListHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<List<CollectionListItemVo>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<List<CollectionListItemVo>> create(Ref ref) {
    return collectionList(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<CollectionListItemVo>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<AsyncValue<List<CollectionListItemVo>>>(value),
    );
  }
}

String _$collectionListHash() => r'8dee32d769cba75cfab03c365a6de455a8222e29';

@ProviderFor(CreateCollectionController)
final createCollectionControllerProvider =
    CreateCollectionControllerProvider._();

final class CreateCollectionControllerProvider
    extends $AsyncNotifierProvider<CreateCollectionController, void> {
  CreateCollectionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createCollectionControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createCollectionControllerHash();

  @$internal
  @override
  CreateCollectionController create() => CreateCollectionController();
}

String _$createCollectionControllerHash() =>
    r'4a614af941a2c48759c089990e1658f64b044933';

abstract class _$CreateCollectionController extends $AsyncNotifier<void> {
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

@ProviderFor(UpdateCollectionController)
final updateCollectionControllerProvider =
    UpdateCollectionControllerProvider._();

final class UpdateCollectionControllerProvider
    extends $AsyncNotifierProvider<UpdateCollectionController, void> {
  UpdateCollectionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateCollectionControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateCollectionControllerHash();

  @$internal
  @override
  UpdateCollectionController create() => UpdateCollectionController();
}

String _$updateCollectionControllerHash() =>
    r'13fda0c5619b384b3d7f1d9181b11f99002db90a';

abstract class _$UpdateCollectionController extends $AsyncNotifier<void> {
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

@ProviderFor(DeleteCollectionController)
final deleteCollectionControllerProvider =
    DeleteCollectionControllerProvider._();

final class DeleteCollectionControllerProvider
    extends $AsyncNotifierProvider<DeleteCollectionController, void> {
  DeleteCollectionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteCollectionControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteCollectionControllerHash();

  @$internal
  @override
  DeleteCollectionController create() => DeleteCollectionController();
}

String _$deleteCollectionControllerHash() =>
    r'ec60e3546bdc4526f1c3e5ab5540655728761406';

abstract class _$DeleteCollectionController extends $AsyncNotifier<void> {
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
