// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parse_image_folder_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ParseImageFolderParam {

 String? get folderPath; List<String>? get imagePathsInput;
/// Create a copy of ParseImageFolderParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParseImageFolderParamCopyWith<ParseImageFolderParam> get copyWith => _$ParseImageFolderParamCopyWithImpl<ParseImageFolderParam>(this as ParseImageFolderParam, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParseImageFolderParam&&(identical(other.folderPath, folderPath) || other.folderPath == folderPath)&&const DeepCollectionEquality().equals(other.imagePathsInput, imagePathsInput));
}


@override
int get hashCode => Object.hash(runtimeType,folderPath,const DeepCollectionEquality().hash(imagePathsInput));

@override
String toString() {
  return 'ParseImageFolderParam(folderPath: $folderPath, imagePathsInput: $imagePathsInput)';
}


}

/// @nodoc
abstract mixin class $ParseImageFolderParamCopyWith<$Res>  {
  factory $ParseImageFolderParamCopyWith(ParseImageFolderParam value, $Res Function(ParseImageFolderParam) _then) = _$ParseImageFolderParamCopyWithImpl;
@useResult
$Res call({
 String? folderPath, List<String>? imagePathsInput
});




}
/// @nodoc
class _$ParseImageFolderParamCopyWithImpl<$Res>
    implements $ParseImageFolderParamCopyWith<$Res> {
  _$ParseImageFolderParamCopyWithImpl(this._self, this._then);

  final ParseImageFolderParam _self;
  final $Res Function(ParseImageFolderParam) _then;

/// Create a copy of ParseImageFolderParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? folderPath = freezed,Object? imagePathsInput = freezed,}) {
  return _then(_self.copyWith(
folderPath: freezed == folderPath ? _self.folderPath : folderPath // ignore: cast_nullable_to_non_nullable
as String?,imagePathsInput: freezed == imagePathsInput ? _self.imagePathsInput : imagePathsInput // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ParseImageFolderParam].
extension ParseImageFolderParamPatterns on ParseImageFolderParam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParseImageFolderParam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParseImageFolderParam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParseImageFolderParam value)  $default,){
final _that = this;
switch (_that) {
case _ParseImageFolderParam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParseImageFolderParam value)?  $default,){
final _that = this;
switch (_that) {
case _ParseImageFolderParam() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? folderPath,  List<String>? imagePathsInput)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParseImageFolderParam() when $default != null:
return $default(_that.folderPath,_that.imagePathsInput);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? folderPath,  List<String>? imagePathsInput)  $default,) {final _that = this;
switch (_that) {
case _ParseImageFolderParam():
return $default(_that.folderPath,_that.imagePathsInput);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? folderPath,  List<String>? imagePathsInput)?  $default,) {final _that = this;
switch (_that) {
case _ParseImageFolderParam() when $default != null:
return $default(_that.folderPath,_that.imagePathsInput);case _:
  return null;

}
}

}

/// @nodoc


class _ParseImageFolderParam implements ParseImageFolderParam {
  const _ParseImageFolderParam({this.folderPath, final  List<String>? imagePathsInput}): _imagePathsInput = imagePathsInput;
  

@override final  String? folderPath;
 final  List<String>? _imagePathsInput;
@override List<String>? get imagePathsInput {
  final value = _imagePathsInput;
  if (value == null) return null;
  if (_imagePathsInput is EqualUnmodifiableListView) return _imagePathsInput;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of ParseImageFolderParam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParseImageFolderParamCopyWith<_ParseImageFolderParam> get copyWith => __$ParseImageFolderParamCopyWithImpl<_ParseImageFolderParam>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParseImageFolderParam&&(identical(other.folderPath, folderPath) || other.folderPath == folderPath)&&const DeepCollectionEquality().equals(other._imagePathsInput, _imagePathsInput));
}


@override
int get hashCode => Object.hash(runtimeType,folderPath,const DeepCollectionEquality().hash(_imagePathsInput));

@override
String toString() {
  return 'ParseImageFolderParam(folderPath: $folderPath, imagePathsInput: $imagePathsInput)';
}


}

/// @nodoc
abstract mixin class _$ParseImageFolderParamCopyWith<$Res> implements $ParseImageFolderParamCopyWith<$Res> {
  factory _$ParseImageFolderParamCopyWith(_ParseImageFolderParam value, $Res Function(_ParseImageFolderParam) _then) = __$ParseImageFolderParamCopyWithImpl;
@override @useResult
$Res call({
 String? folderPath, List<String>? imagePathsInput
});




}
/// @nodoc
class __$ParseImageFolderParamCopyWithImpl<$Res>
    implements _$ParseImageFolderParamCopyWith<$Res> {
  __$ParseImageFolderParamCopyWithImpl(this._self, this._then);

  final _ParseImageFolderParam _self;
  final $Res Function(_ParseImageFolderParam) _then;

/// Create a copy of ParseImageFolderParam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? folderPath = freezed,Object? imagePathsInput = freezed,}) {
  return _then(_ParseImageFolderParam(
folderPath: freezed == folderPath ? _self.folderPath : folderPath // ignore: cast_nullable_to_non_nullable
as String?,imagePathsInput: freezed == imagePathsInput ? _self._imagePathsInput : imagePathsInput // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

/// @nodoc
mixin _$ParseImageFolderState {

 String get folderName; List<String> get imagePaths;
/// Create a copy of ParseImageFolderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParseImageFolderStateCopyWith<ParseImageFolderState> get copyWith => _$ParseImageFolderStateCopyWithImpl<ParseImageFolderState>(this as ParseImageFolderState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParseImageFolderState&&(identical(other.folderName, folderName) || other.folderName == folderName)&&const DeepCollectionEquality().equals(other.imagePaths, imagePaths));
}


@override
int get hashCode => Object.hash(runtimeType,folderName,const DeepCollectionEquality().hash(imagePaths));

@override
String toString() {
  return 'ParseImageFolderState(folderName: $folderName, imagePaths: $imagePaths)';
}


}

/// @nodoc
abstract mixin class $ParseImageFolderStateCopyWith<$Res>  {
  factory $ParseImageFolderStateCopyWith(ParseImageFolderState value, $Res Function(ParseImageFolderState) _then) = _$ParseImageFolderStateCopyWithImpl;
@useResult
$Res call({
 String folderName, List<String> imagePaths
});




}
/// @nodoc
class _$ParseImageFolderStateCopyWithImpl<$Res>
    implements $ParseImageFolderStateCopyWith<$Res> {
  _$ParseImageFolderStateCopyWithImpl(this._self, this._then);

  final ParseImageFolderState _self;
  final $Res Function(ParseImageFolderState) _then;

/// Create a copy of ParseImageFolderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? folderName = null,Object? imagePaths = null,}) {
  return _then(_self.copyWith(
folderName: null == folderName ? _self.folderName : folderName // ignore: cast_nullable_to_non_nullable
as String,imagePaths: null == imagePaths ? _self.imagePaths : imagePaths // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ParseImageFolderState].
extension ParseImageFolderStatePatterns on ParseImageFolderState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParseImageFolderState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParseImageFolderState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParseImageFolderState value)  $default,){
final _that = this;
switch (_that) {
case _ParseImageFolderState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParseImageFolderState value)?  $default,){
final _that = this;
switch (_that) {
case _ParseImageFolderState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String folderName,  List<String> imagePaths)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParseImageFolderState() when $default != null:
return $default(_that.folderName,_that.imagePaths);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String folderName,  List<String> imagePaths)  $default,) {final _that = this;
switch (_that) {
case _ParseImageFolderState():
return $default(_that.folderName,_that.imagePaths);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String folderName,  List<String> imagePaths)?  $default,) {final _that = this;
switch (_that) {
case _ParseImageFolderState() when $default != null:
return $default(_that.folderName,_that.imagePaths);case _:
  return null;

}
}

}

/// @nodoc


class _ParseImageFolderState implements ParseImageFolderState {
  const _ParseImageFolderState({required this.folderName, required final  List<String> imagePaths}): _imagePaths = imagePaths;
  

@override final  String folderName;
 final  List<String> _imagePaths;
@override List<String> get imagePaths {
  if (_imagePaths is EqualUnmodifiableListView) return _imagePaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imagePaths);
}


/// Create a copy of ParseImageFolderState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParseImageFolderStateCopyWith<_ParseImageFolderState> get copyWith => __$ParseImageFolderStateCopyWithImpl<_ParseImageFolderState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParseImageFolderState&&(identical(other.folderName, folderName) || other.folderName == folderName)&&const DeepCollectionEquality().equals(other._imagePaths, _imagePaths));
}


@override
int get hashCode => Object.hash(runtimeType,folderName,const DeepCollectionEquality().hash(_imagePaths));

@override
String toString() {
  return 'ParseImageFolderState(folderName: $folderName, imagePaths: $imagePaths)';
}


}

/// @nodoc
abstract mixin class _$ParseImageFolderStateCopyWith<$Res> implements $ParseImageFolderStateCopyWith<$Res> {
  factory _$ParseImageFolderStateCopyWith(_ParseImageFolderState value, $Res Function(_ParseImageFolderState) _then) = __$ParseImageFolderStateCopyWithImpl;
@override @useResult
$Res call({
 String folderName, List<String> imagePaths
});




}
/// @nodoc
class __$ParseImageFolderStateCopyWithImpl<$Res>
    implements _$ParseImageFolderStateCopyWith<$Res> {
  __$ParseImageFolderStateCopyWithImpl(this._self, this._then);

  final _ParseImageFolderState _self;
  final $Res Function(_ParseImageFolderState) _then;

/// Create a copy of ParseImageFolderState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? folderName = null,Object? imagePaths = null,}) {
  return _then(_ParseImageFolderState(
folderName: null == folderName ? _self.folderName : folderName // ignore: cast_nullable_to_non_nullable
as String,imagePaths: null == imagePaths ? _self._imagePaths : imagePaths // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
mixin _$ParseImageFolderSaveBookParam {

 String get folderName; List<String> get imagePaths;
/// Create a copy of ParseImageFolderSaveBookParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParseImageFolderSaveBookParamCopyWith<ParseImageFolderSaveBookParam> get copyWith => _$ParseImageFolderSaveBookParamCopyWithImpl<ParseImageFolderSaveBookParam>(this as ParseImageFolderSaveBookParam, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParseImageFolderSaveBookParam&&(identical(other.folderName, folderName) || other.folderName == folderName)&&const DeepCollectionEquality().equals(other.imagePaths, imagePaths));
}


@override
int get hashCode => Object.hash(runtimeType,folderName,const DeepCollectionEquality().hash(imagePaths));

@override
String toString() {
  return 'ParseImageFolderSaveBookParam(folderName: $folderName, imagePaths: $imagePaths)';
}


}

/// @nodoc
abstract mixin class $ParseImageFolderSaveBookParamCopyWith<$Res>  {
  factory $ParseImageFolderSaveBookParamCopyWith(ParseImageFolderSaveBookParam value, $Res Function(ParseImageFolderSaveBookParam) _then) = _$ParseImageFolderSaveBookParamCopyWithImpl;
@useResult
$Res call({
 String folderName, List<String> imagePaths
});




}
/// @nodoc
class _$ParseImageFolderSaveBookParamCopyWithImpl<$Res>
    implements $ParseImageFolderSaveBookParamCopyWith<$Res> {
  _$ParseImageFolderSaveBookParamCopyWithImpl(this._self, this._then);

  final ParseImageFolderSaveBookParam _self;
  final $Res Function(ParseImageFolderSaveBookParam) _then;

/// Create a copy of ParseImageFolderSaveBookParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? folderName = null,Object? imagePaths = null,}) {
  return _then(_self.copyWith(
folderName: null == folderName ? _self.folderName : folderName // ignore: cast_nullable_to_non_nullable
as String,imagePaths: null == imagePaths ? _self.imagePaths : imagePaths // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ParseImageFolderSaveBookParam].
extension ParseImageFolderSaveBookParamPatterns on ParseImageFolderSaveBookParam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParseImageFolderSaveBookParam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParseImageFolderSaveBookParam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParseImageFolderSaveBookParam value)  $default,){
final _that = this;
switch (_that) {
case _ParseImageFolderSaveBookParam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParseImageFolderSaveBookParam value)?  $default,){
final _that = this;
switch (_that) {
case _ParseImageFolderSaveBookParam() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String folderName,  List<String> imagePaths)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParseImageFolderSaveBookParam() when $default != null:
return $default(_that.folderName,_that.imagePaths);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String folderName,  List<String> imagePaths)  $default,) {final _that = this;
switch (_that) {
case _ParseImageFolderSaveBookParam():
return $default(_that.folderName,_that.imagePaths);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String folderName,  List<String> imagePaths)?  $default,) {final _that = this;
switch (_that) {
case _ParseImageFolderSaveBookParam() when $default != null:
return $default(_that.folderName,_that.imagePaths);case _:
  return null;

}
}

}

/// @nodoc


class _ParseImageFolderSaveBookParam implements ParseImageFolderSaveBookParam {
  const _ParseImageFolderSaveBookParam({required this.folderName, required final  List<String> imagePaths}): _imagePaths = imagePaths;
  

@override final  String folderName;
 final  List<String> _imagePaths;
@override List<String> get imagePaths {
  if (_imagePaths is EqualUnmodifiableListView) return _imagePaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imagePaths);
}


/// Create a copy of ParseImageFolderSaveBookParam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParseImageFolderSaveBookParamCopyWith<_ParseImageFolderSaveBookParam> get copyWith => __$ParseImageFolderSaveBookParamCopyWithImpl<_ParseImageFolderSaveBookParam>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParseImageFolderSaveBookParam&&(identical(other.folderName, folderName) || other.folderName == folderName)&&const DeepCollectionEquality().equals(other._imagePaths, _imagePaths));
}


@override
int get hashCode => Object.hash(runtimeType,folderName,const DeepCollectionEquality().hash(_imagePaths));

@override
String toString() {
  return 'ParseImageFolderSaveBookParam(folderName: $folderName, imagePaths: $imagePaths)';
}


}

/// @nodoc
abstract mixin class _$ParseImageFolderSaveBookParamCopyWith<$Res> implements $ParseImageFolderSaveBookParamCopyWith<$Res> {
  factory _$ParseImageFolderSaveBookParamCopyWith(_ParseImageFolderSaveBookParam value, $Res Function(_ParseImageFolderSaveBookParam) _then) = __$ParseImageFolderSaveBookParamCopyWithImpl;
@override @useResult
$Res call({
 String folderName, List<String> imagePaths
});




}
/// @nodoc
class __$ParseImageFolderSaveBookParamCopyWithImpl<$Res>
    implements _$ParseImageFolderSaveBookParamCopyWith<$Res> {
  __$ParseImageFolderSaveBookParamCopyWithImpl(this._self, this._then);

  final _ParseImageFolderSaveBookParam _self;
  final $Res Function(_ParseImageFolderSaveBookParam) _then;

/// Create a copy of ParseImageFolderSaveBookParam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? folderName = null,Object? imagePaths = null,}) {
  return _then(_ParseImageFolderSaveBookParam(
folderName: null == folderName ? _self.folderName : folderName // ignore: cast_nullable_to_non_nullable
as String,imagePaths: null == imagePaths ? _self._imagePaths : imagePaths // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
mixin _$ParseImageFolderSaveBookProgress {

 SaveStep get step; int get current; int get total;
/// Create a copy of ParseImageFolderSaveBookProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParseImageFolderSaveBookProgressCopyWith<ParseImageFolderSaveBookProgress> get copyWith => _$ParseImageFolderSaveBookProgressCopyWithImpl<ParseImageFolderSaveBookProgress>(this as ParseImageFolderSaveBookProgress, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParseImageFolderSaveBookProgress&&(identical(other.step, step) || other.step == step)&&(identical(other.current, current) || other.current == current)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,step,current,total);

@override
String toString() {
  return 'ParseImageFolderSaveBookProgress(step: $step, current: $current, total: $total)';
}


}

/// @nodoc
abstract mixin class $ParseImageFolderSaveBookProgressCopyWith<$Res>  {
  factory $ParseImageFolderSaveBookProgressCopyWith(ParseImageFolderSaveBookProgress value, $Res Function(ParseImageFolderSaveBookProgress) _then) = _$ParseImageFolderSaveBookProgressCopyWithImpl;
@useResult
$Res call({
 SaveStep step, int current, int total
});




}
/// @nodoc
class _$ParseImageFolderSaveBookProgressCopyWithImpl<$Res>
    implements $ParseImageFolderSaveBookProgressCopyWith<$Res> {
  _$ParseImageFolderSaveBookProgressCopyWithImpl(this._self, this._then);

  final ParseImageFolderSaveBookProgress _self;
  final $Res Function(ParseImageFolderSaveBookProgress) _then;

/// Create a copy of ParseImageFolderSaveBookProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? step = null,Object? current = null,Object? total = null,}) {
  return _then(_self.copyWith(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as SaveStep,current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ParseImageFolderSaveBookProgress].
extension ParseImageFolderSaveBookProgressPatterns on ParseImageFolderSaveBookProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParseImageFolderSaveBookProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParseImageFolderSaveBookProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParseImageFolderSaveBookProgress value)  $default,){
final _that = this;
switch (_that) {
case _ParseImageFolderSaveBookProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParseImageFolderSaveBookProgress value)?  $default,){
final _that = this;
switch (_that) {
case _ParseImageFolderSaveBookProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SaveStep step,  int current,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParseImageFolderSaveBookProgress() when $default != null:
return $default(_that.step,_that.current,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SaveStep step,  int current,  int total)  $default,) {final _that = this;
switch (_that) {
case _ParseImageFolderSaveBookProgress():
return $default(_that.step,_that.current,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SaveStep step,  int current,  int total)?  $default,) {final _that = this;
switch (_that) {
case _ParseImageFolderSaveBookProgress() when $default != null:
return $default(_that.step,_that.current,_that.total);case _:
  return null;

}
}

}

/// @nodoc


class _ParseImageFolderSaveBookProgress extends ParseImageFolderSaveBookProgress {
  const _ParseImageFolderSaveBookProgress({this.step = SaveStep.generateCover, this.current = 0, this.total = 0}): super._();
  

@override@JsonKey() final  SaveStep step;
@override@JsonKey() final  int current;
@override@JsonKey() final  int total;

/// Create a copy of ParseImageFolderSaveBookProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParseImageFolderSaveBookProgressCopyWith<_ParseImageFolderSaveBookProgress> get copyWith => __$ParseImageFolderSaveBookProgressCopyWithImpl<_ParseImageFolderSaveBookProgress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParseImageFolderSaveBookProgress&&(identical(other.step, step) || other.step == step)&&(identical(other.current, current) || other.current == current)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,step,current,total);

@override
String toString() {
  return 'ParseImageFolderSaveBookProgress(step: $step, current: $current, total: $total)';
}


}

/// @nodoc
abstract mixin class _$ParseImageFolderSaveBookProgressCopyWith<$Res> implements $ParseImageFolderSaveBookProgressCopyWith<$Res> {
  factory _$ParseImageFolderSaveBookProgressCopyWith(_ParseImageFolderSaveBookProgress value, $Res Function(_ParseImageFolderSaveBookProgress) _then) = __$ParseImageFolderSaveBookProgressCopyWithImpl;
@override @useResult
$Res call({
 SaveStep step, int current, int total
});




}
/// @nodoc
class __$ParseImageFolderSaveBookProgressCopyWithImpl<$Res>
    implements _$ParseImageFolderSaveBookProgressCopyWith<$Res> {
  __$ParseImageFolderSaveBookProgressCopyWithImpl(this._self, this._then);

  final _ParseImageFolderSaveBookProgress _self;
  final $Res Function(_ParseImageFolderSaveBookProgress) _then;

/// Create a copy of ParseImageFolderSaveBookProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? step = null,Object? current = null,Object? total = null,}) {
  return _then(_ParseImageFolderSaveBookProgress(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as SaveStep,current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
