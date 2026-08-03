// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parse_web_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ParseWebState {

 String get title; List<String> get urls; int get progress;
/// Create a copy of ParseWebState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParseWebStateCopyWith<ParseWebState> get copyWith => _$ParseWebStateCopyWithImpl<ParseWebState>(this as ParseWebState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParseWebState&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.urls, urls)&&(identical(other.progress, progress) || other.progress == progress));
}


@override
int get hashCode => Object.hash(runtimeType,title,const DeepCollectionEquality().hash(urls),progress);

@override
String toString() {
  return 'ParseWebState(title: $title, urls: $urls, progress: $progress)';
}


}

/// @nodoc
abstract mixin class $ParseWebStateCopyWith<$Res>  {
  factory $ParseWebStateCopyWith(ParseWebState value, $Res Function(ParseWebState) _then) = _$ParseWebStateCopyWithImpl;
@useResult
$Res call({
 String title, List<String> urls, int progress
});




}
/// @nodoc
class _$ParseWebStateCopyWithImpl<$Res>
    implements $ParseWebStateCopyWith<$Res> {
  _$ParseWebStateCopyWithImpl(this._self, this._then);

  final ParseWebState _self;
  final $Res Function(ParseWebState) _then;

/// Create a copy of ParseWebState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? urls = null,Object? progress = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,urls: null == urls ? _self.urls : urls // ignore: cast_nullable_to_non_nullable
as List<String>,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ParseWebState].
extension ParseWebStatePatterns on ParseWebState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParseWebState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParseWebState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParseWebState value)  $default,){
final _that = this;
switch (_that) {
case _ParseWebState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParseWebState value)?  $default,){
final _that = this;
switch (_that) {
case _ParseWebState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  List<String> urls,  int progress)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParseWebState() when $default != null:
return $default(_that.title,_that.urls,_that.progress);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  List<String> urls,  int progress)  $default,) {final _that = this;
switch (_that) {
case _ParseWebState():
return $default(_that.title,_that.urls,_that.progress);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  List<String> urls,  int progress)?  $default,) {final _that = this;
switch (_that) {
case _ParseWebState() when $default != null:
return $default(_that.title,_that.urls,_that.progress);case _:
  return null;

}
}

}

/// @nodoc


class _ParseWebState implements ParseWebState {
  const _ParseWebState({required this.title, required final  List<String> urls, required this.progress}): _urls = urls;
  

@override final  String title;
 final  List<String> _urls;
@override List<String> get urls {
  if (_urls is EqualUnmodifiableListView) return _urls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_urls);
}

@override final  int progress;

/// Create a copy of ParseWebState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParseWebStateCopyWith<_ParseWebState> get copyWith => __$ParseWebStateCopyWithImpl<_ParseWebState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParseWebState&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._urls, _urls)&&(identical(other.progress, progress) || other.progress == progress));
}


@override
int get hashCode => Object.hash(runtimeType,title,const DeepCollectionEquality().hash(_urls),progress);

@override
String toString() {
  return 'ParseWebState(title: $title, urls: $urls, progress: $progress)';
}


}

/// @nodoc
abstract mixin class _$ParseWebStateCopyWith<$Res> implements $ParseWebStateCopyWith<$Res> {
  factory _$ParseWebStateCopyWith(_ParseWebState value, $Res Function(_ParseWebState) _then) = __$ParseWebStateCopyWithImpl;
@override @useResult
$Res call({
 String title, List<String> urls, int progress
});




}
/// @nodoc
class __$ParseWebStateCopyWithImpl<$Res>
    implements _$ParseWebStateCopyWith<$Res> {
  __$ParseWebStateCopyWithImpl(this._self, this._then);

  final _ParseWebState _self;
  final $Res Function(_ParseWebState) _then;

/// Create a copy of ParseWebState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? urls = null,Object? progress = null,}) {
  return _then(_ParseWebState(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,urls: null == urls ? _self._urls : urls // ignore: cast_nullable_to_non_nullable
as List<String>,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
