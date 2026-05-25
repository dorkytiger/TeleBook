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

@ProviderFor(CollectionController)
final collectionControllerProvider = CollectionControllerProvider._();

final class CollectionControllerProvider
    extends $AsyncNotifierProvider<CollectionController, void> {
  CollectionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'collectionControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$collectionControllerHash();

  @$internal
  @override
  CollectionController create() => CollectionController();
}

String _$collectionControllerHash() =>
    r'9258092689b48ab819099d458d6e7e15f4d970fe';

abstract class _$CollectionController extends $AsyncNotifier<void> {
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
