// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_book_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(collectionBookView)
final collectionBookViewProvider = CollectionBookViewFamily._();

final class CollectionBookViewProvider
    extends
        $FunctionalProvider<
          AsyncValue<CollectionBookState>,
          AsyncValue<CollectionBookState>,
          AsyncValue<CollectionBookState>
        >
    with $Provider<AsyncValue<CollectionBookState>> {
  CollectionBookViewProvider._({
    required CollectionBookViewFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'collectionBookViewProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$collectionBookViewHash();

  @override
  String toString() {
    return r'collectionBookViewProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<AsyncValue<CollectionBookState>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<CollectionBookState> create(Ref ref) {
    final argument = this.argument as int;
    return collectionBookView(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<CollectionBookState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<CollectionBookState>>(
        value,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CollectionBookViewProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$collectionBookViewHash() =>
    r'c03f3388df2a89f51a6a06a98d302c2dd9f4402b';

final class CollectionBookViewFamily extends $Family
    with $FunctionalFamilyOverride<AsyncValue<CollectionBookState>, int> {
  CollectionBookViewFamily._()
    : super(
        retry: null,
        name: r'collectionBookViewProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CollectionBookViewProvider call(int collectionId) =>
      CollectionBookViewProvider._(argument: collectionId, from: this);

  @override
  String toString() => r'collectionBookViewProvider';
}
