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
