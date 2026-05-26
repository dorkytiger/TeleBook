// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parse_pdf_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ParsePdfState {

 String get pdfName; List<String> get tempPaths;
/// Create a copy of ParsePdfState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParsePdfStateCopyWith<ParsePdfState> get copyWith => _$ParsePdfStateCopyWithImpl<ParsePdfState>(this as ParsePdfState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParsePdfState&&(identical(other.pdfName, pdfName) || other.pdfName == pdfName)&&const DeepCollectionEquality().equals(other.tempPaths, tempPaths));
}


@override
int get hashCode => Object.hash(runtimeType,pdfName,const DeepCollectionEquality().hash(tempPaths));

@override
String toString() {
  return 'ParsePdfState(pdfName: $pdfName, tempPaths: $tempPaths)';
}


}

/// @nodoc
abstract mixin class $ParsePdfStateCopyWith<$Res>  {
  factory $ParsePdfStateCopyWith(ParsePdfState value, $Res Function(ParsePdfState) _then) = _$ParsePdfStateCopyWithImpl;
@useResult
$Res call({
 String pdfName, List<String> tempPaths
});




}
/// @nodoc
class _$ParsePdfStateCopyWithImpl<$Res>
    implements $ParsePdfStateCopyWith<$Res> {
  _$ParsePdfStateCopyWithImpl(this._self, this._then);

  final ParsePdfState _self;
  final $Res Function(ParsePdfState) _then;

/// Create a copy of ParsePdfState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pdfName = null,Object? tempPaths = null,}) {
  return _then(_self.copyWith(
pdfName: null == pdfName ? _self.pdfName : pdfName // ignore: cast_nullable_to_non_nullable
as String,tempPaths: null == tempPaths ? _self.tempPaths : tempPaths // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ParsePdfState].
extension ParsePdfStatePatterns on ParsePdfState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParsePdfProgressState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParsePdfProgressState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParsePdfProgressState value)  $default,){
final _that = this;
switch (_that) {
case _ParsePdfProgressState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParsePdfProgressState value)?  $default,){
final _that = this;
switch (_that) {
case _ParsePdfProgressState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String pdfName,  List<String> tempPaths)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParsePdfProgressState() when $default != null:
return $default(_that.pdfName,_that.tempPaths);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String pdfName,  List<String> tempPaths)  $default,) {final _that = this;
switch (_that) {
case _ParsePdfProgressState():
return $default(_that.pdfName,_that.tempPaths);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String pdfName,  List<String> tempPaths)?  $default,) {final _that = this;
switch (_that) {
case _ParsePdfProgressState() when $default != null:
return $default(_that.pdfName,_that.tempPaths);case _:
  return null;

}
}

}

/// @nodoc


class _ParsePdfProgressState implements ParsePdfState {
  const _ParsePdfProgressState({required this.pdfName, required final  List<String> tempPaths}): _tempPaths = tempPaths;
  

@override final  String pdfName;
 final  List<String> _tempPaths;
@override List<String> get tempPaths {
  if (_tempPaths is EqualUnmodifiableListView) return _tempPaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tempPaths);
}


/// Create a copy of ParsePdfState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParsePdfProgressStateCopyWith<_ParsePdfProgressState> get copyWith => __$ParsePdfProgressStateCopyWithImpl<_ParsePdfProgressState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParsePdfProgressState&&(identical(other.pdfName, pdfName) || other.pdfName == pdfName)&&const DeepCollectionEquality().equals(other._tempPaths, _tempPaths));
}


@override
int get hashCode => Object.hash(runtimeType,pdfName,const DeepCollectionEquality().hash(_tempPaths));

@override
String toString() {
  return 'ParsePdfState(pdfName: $pdfName, tempPaths: $tempPaths)';
}


}

/// @nodoc
abstract mixin class _$ParsePdfProgressStateCopyWith<$Res> implements $ParsePdfStateCopyWith<$Res> {
  factory _$ParsePdfProgressStateCopyWith(_ParsePdfProgressState value, $Res Function(_ParsePdfProgressState) _then) = __$ParsePdfProgressStateCopyWithImpl;
@override @useResult
$Res call({
 String pdfName, List<String> tempPaths
});




}
/// @nodoc
class __$ParsePdfProgressStateCopyWithImpl<$Res>
    implements _$ParsePdfProgressStateCopyWith<$Res> {
  __$ParsePdfProgressStateCopyWithImpl(this._self, this._then);

  final _ParsePdfProgressState _self;
  final $Res Function(_ParsePdfProgressState) _then;

/// Create a copy of ParsePdfState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pdfName = null,Object? tempPaths = null,}) {
  return _then(_ParsePdfProgressState(
pdfName: null == pdfName ? _self.pdfName : pdfName // ignore: cast_nullable_to_non_nullable
as String,tempPaths: null == tempPaths ? _self._tempPaths : tempPaths // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
