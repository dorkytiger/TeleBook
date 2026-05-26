// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parse_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ParseForm)
final parseFormProvider = ParseFormProvider._();

final class ParseFormProvider
    extends $NotifierProvider<ParseForm, ParseFormState> {
  ParseFormProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'parseFormProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$parseFormHash();

  @$internal
  @override
  ParseForm create() => ParseForm();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ParseFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ParseFormState>(value),
    );
  }
}

String _$parseFormHash() => r'ee119b4fdf6d809a4cffeca8d5ce46ca9e2b17ff';

abstract class _$ParseForm extends $Notifier<ParseFormState> {
  ParseFormState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ParseFormState, ParseFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ParseFormState, ParseFormState>,
              ParseFormState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
