// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BookList)
final bookListProvider = BookListProvider._();

final class BookListProvider
    extends $AsyncNotifierProvider<BookList, BookListState> {
  BookListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookListHash();

  @$internal
  @override
  BookList create() => BookList();
}

String _$bookListHash() => r'8cc7188f30e463cd9d76918cd02c58d4cbbd98e0';

abstract class _$BookList extends $AsyncNotifier<BookListState> {
  FutureOr<BookListState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<BookListState>, BookListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<BookListState>, BookListState>,
              AsyncValue<BookListState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
