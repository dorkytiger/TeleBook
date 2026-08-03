// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BookForm)
final bookFormProvider = BookFormFamily._();

final class BookFormProvider
    extends $AsyncNotifierProvider<BookForm, BookFormState> {
  BookFormProvider._({
    required BookFormFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'bookFormProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bookFormHash();

  @override
  String toString() {
    return r'bookFormProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  BookForm create() => BookForm();

  @override
  bool operator ==(Object other) {
    return other is BookFormProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bookFormHash() => r'2407f1247c5dcb1db39c18a8efb0dee929528e93';

final class BookFormFamily extends $Family
    with
        $ClassFamilyOverride<
          BookForm,
          AsyncValue<BookFormState>,
          BookFormState,
          FutureOr<BookFormState>,
          int
        > {
  BookFormFamily._()
    : super(
        retry: null,
        name: r'bookFormProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BookFormProvider call(int bookId) =>
      BookFormProvider._(argument: bookId, from: this);

  @override
  String toString() => r'bookFormProvider';
}

abstract class _$BookForm extends $AsyncNotifier<BookFormState> {
  late final _$args = ref.$arg as int;
  int get bookId => _$args;

  FutureOr<BookFormState> build(int bookId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<BookFormState>, BookFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<BookFormState>, BookFormState>,
              AsyncValue<BookFormState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(BookFormSubmit)
final bookFormSubmitProvider = BookFormSubmitProvider._();

final class BookFormSubmitProvider
    extends $AsyncNotifierProvider<BookFormSubmit, void> {
  BookFormSubmitProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookFormSubmitProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookFormSubmitHash();

  @$internal
  @override
  BookFormSubmit create() => BookFormSubmit();
}

String _$bookFormSubmitHash() => r'fd7d09a1cb4d7435ae908d34fbb02868792da325';

abstract class _$BookFormSubmit extends $AsyncNotifier<void> {
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
