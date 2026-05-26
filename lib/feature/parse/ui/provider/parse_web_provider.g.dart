// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parse_web_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ParseWeb)
final parseWebProvider = ParseWebFamily._();

final class ParseWebProvider
    extends $NotifierProvider<ParseWeb, ParseWebState> {
  ParseWebProvider._({
    required ParseWebFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'parseWebProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$parseWebHash();

  @override
  String toString() {
    return r'parseWebProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ParseWeb create() => ParseWeb();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ParseWebState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ParseWebState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ParseWebProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$parseWebHash() => r'676e20c1d434b2780a7a4e71d5c43ac9f6929b28';

final class ParseWebFamily extends $Family
    with
        $ClassFamilyOverride<
          ParseWeb,
          ParseWebState,
          ParseWebState,
          ParseWebState,
          String
        > {
  ParseWebFamily._()
    : super(
        retry: null,
        name: r'parseWebProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ParseWebProvider call(String url) =>
      ParseWebProvider._(argument: url, from: this);

  @override
  String toString() => r'parseWebProvider';
}

abstract class _$ParseWeb extends $Notifier<ParseWebState> {
  late final _$args = ref.$arg as String;
  String get url => _$args;

  ParseWebState build(String url);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ParseWebState, ParseWebState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ParseWebState, ParseWebState>,
              ParseWebState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
