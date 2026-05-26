// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_page_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BookPage)
final bookPageProvider = BookPageFamily._();

final class BookPageProvider
    extends $NotifierProvider<BookPage, BookPageState> {
  BookPageProvider._({
    required BookPageFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'bookPageProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bookPageHash();

  @override
  String toString() {
    return r'bookPageProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  BookPage create() => BookPage();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookPageState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookPageState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BookPageProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bookPageHash() => r'a1503c3304f4c51ee417945992ed4de071a27061';

final class BookPageFamily extends $Family
    with
        $ClassFamilyOverride<
          BookPage,
          BookPageState,
          BookPageState,
          BookPageState,
          int
        > {
  BookPageFamily._()
    : super(
        retry: null,
        name: r'bookPageProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BookPageProvider call(int bookId) =>
      BookPageProvider._(argument: bookId, from: this);

  @override
  String toString() => r'bookPageProvider';
}

abstract class _$BookPage extends $Notifier<BookPageState> {
  late final _$args = ref.$arg as int;
  int get bookId => _$args;

  BookPageState build(int bookId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<BookPageState, BookPageState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BookPageState, BookPageState>,
              BookPageState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
