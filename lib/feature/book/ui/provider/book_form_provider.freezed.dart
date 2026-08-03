// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book_form_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BookFormState {

 String get title; List<BookFormPath> get imagePaths;
/// Create a copy of BookFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookFormStateCopyWith<BookFormState> get copyWith => _$BookFormStateCopyWithImpl<BookFormState>(this as BookFormState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookFormState&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.imagePaths, imagePaths));
}


@override
int get hashCode => Object.hash(runtimeType,title,const DeepCollectionEquality().hash(imagePaths));

@override
String toString() {
  return 'BookFormState(title: $title, imagePaths: $imagePaths)';
}


}

/// @nodoc
abstract mixin class $BookFormStateCopyWith<$Res>  {
  factory $BookFormStateCopyWith(BookFormState value, $Res Function(BookFormState) _then) = _$BookFormStateCopyWithImpl;
@useResult
$Res call({
 String title, List<BookFormPath> imagePaths
});




}
/// @nodoc
class _$BookFormStateCopyWithImpl<$Res>
    implements $BookFormStateCopyWith<$Res> {
  _$BookFormStateCopyWithImpl(this._self, this._then);

  final BookFormState _self;
  final $Res Function(BookFormState) _then;

/// Create a copy of BookFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? imagePaths = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,imagePaths: null == imagePaths ? _self.imagePaths : imagePaths // ignore: cast_nullable_to_non_nullable
as List<BookFormPath>,
  ));
}

}


/// Adds pattern-matching-related methods to [BookFormState].
extension BookFormStatePatterns on BookFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookFormState value)  $default,){
final _that = this;
switch (_that) {
case _BookFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookFormState value)?  $default,){
final _that = this;
switch (_that) {
case _BookFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  List<BookFormPath> imagePaths)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookFormState() when $default != null:
return $default(_that.title,_that.imagePaths);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  List<BookFormPath> imagePaths)  $default,) {final _that = this;
switch (_that) {
case _BookFormState():
return $default(_that.title,_that.imagePaths);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  List<BookFormPath> imagePaths)?  $default,) {final _that = this;
switch (_that) {
case _BookFormState() when $default != null:
return $default(_that.title,_that.imagePaths);case _:
  return null;

}
}

}

/// @nodoc


class _BookFormState implements BookFormState {
  const _BookFormState({required this.title, required final  List<BookFormPath> imagePaths}): _imagePaths = imagePaths;
  

@override final  String title;
 final  List<BookFormPath> _imagePaths;
@override List<BookFormPath> get imagePaths {
  if (_imagePaths is EqualUnmodifiableListView) return _imagePaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imagePaths);
}


/// Create a copy of BookFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookFormStateCopyWith<_BookFormState> get copyWith => __$BookFormStateCopyWithImpl<_BookFormState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookFormState&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._imagePaths, _imagePaths));
}


@override
int get hashCode => Object.hash(runtimeType,title,const DeepCollectionEquality().hash(_imagePaths));

@override
String toString() {
  return 'BookFormState(title: $title, imagePaths: $imagePaths)';
}


}

/// @nodoc
abstract mixin class _$BookFormStateCopyWith<$Res> implements $BookFormStateCopyWith<$Res> {
  factory _$BookFormStateCopyWith(_BookFormState value, $Res Function(_BookFormState) _then) = __$BookFormStateCopyWithImpl;
@override @useResult
$Res call({
 String title, List<BookFormPath> imagePaths
});




}
/// @nodoc
class __$BookFormStateCopyWithImpl<$Res>
    implements _$BookFormStateCopyWith<$Res> {
  __$BookFormStateCopyWithImpl(this._self, this._then);

  final _BookFormState _self;
  final $Res Function(_BookFormState) _then;

/// Create a copy of BookFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? imagePaths = null,}) {
  return _then(_BookFormState(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,imagePaths: null == imagePaths ? _self._imagePaths : imagePaths // ignore: cast_nullable_to_non_nullable
as List<BookFormPath>,
  ));
}


}

/// @nodoc
mixin _$BookFormPath {

 String get parentPath; String get subPath;
/// Create a copy of BookFormPath
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookFormPathCopyWith<BookFormPath> get copyWith => _$BookFormPathCopyWithImpl<BookFormPath>(this as BookFormPath, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookFormPath&&(identical(other.parentPath, parentPath) || other.parentPath == parentPath)&&(identical(other.subPath, subPath) || other.subPath == subPath));
}


@override
int get hashCode => Object.hash(runtimeType,parentPath,subPath);

@override
String toString() {
  return 'BookFormPath(parentPath: $parentPath, subPath: $subPath)';
}


}

/// @nodoc
abstract mixin class $BookFormPathCopyWith<$Res>  {
  factory $BookFormPathCopyWith(BookFormPath value, $Res Function(BookFormPath) _then) = _$BookFormPathCopyWithImpl;
@useResult
$Res call({
 String parentPath, String subPath
});




}
/// @nodoc
class _$BookFormPathCopyWithImpl<$Res>
    implements $BookFormPathCopyWith<$Res> {
  _$BookFormPathCopyWithImpl(this._self, this._then);

  final BookFormPath _self;
  final $Res Function(BookFormPath) _then;

/// Create a copy of BookFormPath
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? parentPath = null,Object? subPath = null,}) {
  return _then(_self.copyWith(
parentPath: null == parentPath ? _self.parentPath : parentPath // ignore: cast_nullable_to_non_nullable
as String,subPath: null == subPath ? _self.subPath : subPath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BookFormPath].
extension BookFormPathPatterns on BookFormPath {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookFormPath value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookFormPath() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookFormPath value)  $default,){
final _that = this;
switch (_that) {
case _BookFormPath():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookFormPath value)?  $default,){
final _that = this;
switch (_that) {
case _BookFormPath() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String parentPath,  String subPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookFormPath() when $default != null:
return $default(_that.parentPath,_that.subPath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String parentPath,  String subPath)  $default,) {final _that = this;
switch (_that) {
case _BookFormPath():
return $default(_that.parentPath,_that.subPath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String parentPath,  String subPath)?  $default,) {final _that = this;
switch (_that) {
case _BookFormPath() when $default != null:
return $default(_that.parentPath,_that.subPath);case _:
  return null;

}
}

}

/// @nodoc


class _BookFormPath extends BookFormPath {
  const _BookFormPath({required this.parentPath, required this.subPath}): super._();
  

@override final  String parentPath;
@override final  String subPath;

/// Create a copy of BookFormPath
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookFormPathCopyWith<_BookFormPath> get copyWith => __$BookFormPathCopyWithImpl<_BookFormPath>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookFormPath&&(identical(other.parentPath, parentPath) || other.parentPath == parentPath)&&(identical(other.subPath, subPath) || other.subPath == subPath));
}


@override
int get hashCode => Object.hash(runtimeType,parentPath,subPath);

@override
String toString() {
  return 'BookFormPath(parentPath: $parentPath, subPath: $subPath)';
}


}

/// @nodoc
abstract mixin class _$BookFormPathCopyWith<$Res> implements $BookFormPathCopyWith<$Res> {
  factory _$BookFormPathCopyWith(_BookFormPath value, $Res Function(_BookFormPath) _then) = __$BookFormPathCopyWithImpl;
@override @useResult
$Res call({
 String parentPath, String subPath
});




}
/// @nodoc
class __$BookFormPathCopyWithImpl<$Res>
    implements _$BookFormPathCopyWith<$Res> {
  __$BookFormPathCopyWithImpl(this._self, this._then);

  final _BookFormPath _self;
  final $Res Function(_BookFormPath) _then;

/// Create a copy of BookFormPath
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? parentPath = null,Object? subPath = null,}) {
  return _then(_BookFormPath(
parentPath: null == parentPath ? _self.parentPath : parentPath // ignore: cast_nullable_to_non_nullable
as String,subPath: null == subPath ? _self.subPath : subPath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
