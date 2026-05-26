// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parse_archive_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ParseArchiveState {

 String get archiveName; List<String> get tempPaths;
/// Create a copy of ParseArchiveState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParseArchiveStateCopyWith<ParseArchiveState> get copyWith => _$ParseArchiveStateCopyWithImpl<ParseArchiveState>(this as ParseArchiveState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParseArchiveState&&(identical(other.archiveName, archiveName) || other.archiveName == archiveName)&&const DeepCollectionEquality().equals(other.tempPaths, tempPaths));
}


@override
int get hashCode => Object.hash(runtimeType,archiveName,const DeepCollectionEquality().hash(tempPaths));

@override
String toString() {
  return 'ParseArchiveState(archiveName: $archiveName, tempPaths: $tempPaths)';
}


}

/// @nodoc
abstract mixin class $ParseArchiveStateCopyWith<$Res>  {
  factory $ParseArchiveStateCopyWith(ParseArchiveState value, $Res Function(ParseArchiveState) _then) = _$ParseArchiveStateCopyWithImpl;
@useResult
$Res call({
 String archiveName, List<String> tempPaths
});




}
/// @nodoc
class _$ParseArchiveStateCopyWithImpl<$Res>
    implements $ParseArchiveStateCopyWith<$Res> {
  _$ParseArchiveStateCopyWithImpl(this._self, this._then);

  final ParseArchiveState _self;
  final $Res Function(ParseArchiveState) _then;

/// Create a copy of ParseArchiveState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? archiveName = null,Object? tempPaths = null,}) {
  return _then(_self.copyWith(
archiveName: null == archiveName ? _self.archiveName : archiveName // ignore: cast_nullable_to_non_nullable
as String,tempPaths: null == tempPaths ? _self.tempPaths : tempPaths // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ParseArchiveState].
extension ParseArchiveStatePatterns on ParseArchiveState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParseArchiveState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParseArchiveState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParseArchiveState value)  $default,){
final _that = this;
switch (_that) {
case _ParseArchiveState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParseArchiveState value)?  $default,){
final _that = this;
switch (_that) {
case _ParseArchiveState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String archiveName,  List<String> tempPaths)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParseArchiveState() when $default != null:
return $default(_that.archiveName,_that.tempPaths);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String archiveName,  List<String> tempPaths)  $default,) {final _that = this;
switch (_that) {
case _ParseArchiveState():
return $default(_that.archiveName,_that.tempPaths);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String archiveName,  List<String> tempPaths)?  $default,) {final _that = this;
switch (_that) {
case _ParseArchiveState() when $default != null:
return $default(_that.archiveName,_that.tempPaths);case _:
  return null;

}
}

}

/// @nodoc


class _ParseArchiveState implements ParseArchiveState {
  const _ParseArchiveState({required this.archiveName, required final  List<String> tempPaths}): _tempPaths = tempPaths;
  

@override final  String archiveName;
 final  List<String> _tempPaths;
@override List<String> get tempPaths {
  if (_tempPaths is EqualUnmodifiableListView) return _tempPaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tempPaths);
}


/// Create a copy of ParseArchiveState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParseArchiveStateCopyWith<_ParseArchiveState> get copyWith => __$ParseArchiveStateCopyWithImpl<_ParseArchiveState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParseArchiveState&&(identical(other.archiveName, archiveName) || other.archiveName == archiveName)&&const DeepCollectionEquality().equals(other._tempPaths, _tempPaths));
}


@override
int get hashCode => Object.hash(runtimeType,archiveName,const DeepCollectionEquality().hash(_tempPaths));

@override
String toString() {
  return 'ParseArchiveState(archiveName: $archiveName, tempPaths: $tempPaths)';
}


}

/// @nodoc
abstract mixin class _$ParseArchiveStateCopyWith<$Res> implements $ParseArchiveStateCopyWith<$Res> {
  factory _$ParseArchiveStateCopyWith(_ParseArchiveState value, $Res Function(_ParseArchiveState) _then) = __$ParseArchiveStateCopyWithImpl;
@override @useResult
$Res call({
 String archiveName, List<String> tempPaths
});




}
/// @nodoc
class __$ParseArchiveStateCopyWithImpl<$Res>
    implements _$ParseArchiveStateCopyWith<$Res> {
  __$ParseArchiveStateCopyWithImpl(this._self, this._then);

  final _ParseArchiveState _self;
  final $Res Function(_ParseArchiveState) _then;

/// Create a copy of ParseArchiveState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? archiveName = null,Object? tempPaths = null,}) {
  return _then(_ParseArchiveState(
archiveName: null == archiveName ? _self.archiveName : archiveName // ignore: cast_nullable_to_non_nullable
as String,tempPaths: null == tempPaths ? _self._tempPaths : tempPaths // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
mixin _$ParseArchiveSaveBookParam {

 String get archiveName; List<String> get tempPaths;
/// Create a copy of ParseArchiveSaveBookParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParseArchiveSaveBookParamCopyWith<ParseArchiveSaveBookParam> get copyWith => _$ParseArchiveSaveBookParamCopyWithImpl<ParseArchiveSaveBookParam>(this as ParseArchiveSaveBookParam, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParseArchiveSaveBookParam&&(identical(other.archiveName, archiveName) || other.archiveName == archiveName)&&const DeepCollectionEquality().equals(other.tempPaths, tempPaths));
}


@override
int get hashCode => Object.hash(runtimeType,archiveName,const DeepCollectionEquality().hash(tempPaths));

@override
String toString() {
  return 'ParseArchiveSaveBookParam(archiveName: $archiveName, tempPaths: $tempPaths)';
}


}

/// @nodoc
abstract mixin class $ParseArchiveSaveBookParamCopyWith<$Res>  {
  factory $ParseArchiveSaveBookParamCopyWith(ParseArchiveSaveBookParam value, $Res Function(ParseArchiveSaveBookParam) _then) = _$ParseArchiveSaveBookParamCopyWithImpl;
@useResult
$Res call({
 String archiveName, List<String> tempPaths
});




}
/// @nodoc
class _$ParseArchiveSaveBookParamCopyWithImpl<$Res>
    implements $ParseArchiveSaveBookParamCopyWith<$Res> {
  _$ParseArchiveSaveBookParamCopyWithImpl(this._self, this._then);

  final ParseArchiveSaveBookParam _self;
  final $Res Function(ParseArchiveSaveBookParam) _then;

/// Create a copy of ParseArchiveSaveBookParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? archiveName = null,Object? tempPaths = null,}) {
  return _then(_self.copyWith(
archiveName: null == archiveName ? _self.archiveName : archiveName // ignore: cast_nullable_to_non_nullable
as String,tempPaths: null == tempPaths ? _self.tempPaths : tempPaths // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ParseArchiveSaveBookParam].
extension ParseArchiveSaveBookParamPatterns on ParseArchiveSaveBookParam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParseArchiveSaveBookParam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParseArchiveSaveBookParam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParseArchiveSaveBookParam value)  $default,){
final _that = this;
switch (_that) {
case _ParseArchiveSaveBookParam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParseArchiveSaveBookParam value)?  $default,){
final _that = this;
switch (_that) {
case _ParseArchiveSaveBookParam() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String archiveName,  List<String> tempPaths)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParseArchiveSaveBookParam() when $default != null:
return $default(_that.archiveName,_that.tempPaths);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String archiveName,  List<String> tempPaths)  $default,) {final _that = this;
switch (_that) {
case _ParseArchiveSaveBookParam():
return $default(_that.archiveName,_that.tempPaths);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String archiveName,  List<String> tempPaths)?  $default,) {final _that = this;
switch (_that) {
case _ParseArchiveSaveBookParam() when $default != null:
return $default(_that.archiveName,_that.tempPaths);case _:
  return null;

}
}

}

/// @nodoc


class _ParseArchiveSaveBookParam implements ParseArchiveSaveBookParam {
  const _ParseArchiveSaveBookParam({required this.archiveName, required final  List<String> tempPaths}): _tempPaths = tempPaths;
  

@override final  String archiveName;
 final  List<String> _tempPaths;
@override List<String> get tempPaths {
  if (_tempPaths is EqualUnmodifiableListView) return _tempPaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tempPaths);
}


/// Create a copy of ParseArchiveSaveBookParam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParseArchiveSaveBookParamCopyWith<_ParseArchiveSaveBookParam> get copyWith => __$ParseArchiveSaveBookParamCopyWithImpl<_ParseArchiveSaveBookParam>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParseArchiveSaveBookParam&&(identical(other.archiveName, archiveName) || other.archiveName == archiveName)&&const DeepCollectionEquality().equals(other._tempPaths, _tempPaths));
}


@override
int get hashCode => Object.hash(runtimeType,archiveName,const DeepCollectionEquality().hash(_tempPaths));

@override
String toString() {
  return 'ParseArchiveSaveBookParam(archiveName: $archiveName, tempPaths: $tempPaths)';
}


}

/// @nodoc
abstract mixin class _$ParseArchiveSaveBookParamCopyWith<$Res> implements $ParseArchiveSaveBookParamCopyWith<$Res> {
  factory _$ParseArchiveSaveBookParamCopyWith(_ParseArchiveSaveBookParam value, $Res Function(_ParseArchiveSaveBookParam) _then) = __$ParseArchiveSaveBookParamCopyWithImpl;
@override @useResult
$Res call({
 String archiveName, List<String> tempPaths
});




}
/// @nodoc
class __$ParseArchiveSaveBookParamCopyWithImpl<$Res>
    implements _$ParseArchiveSaveBookParamCopyWith<$Res> {
  __$ParseArchiveSaveBookParamCopyWithImpl(this._self, this._then);

  final _ParseArchiveSaveBookParam _self;
  final $Res Function(_ParseArchiveSaveBookParam) _then;

/// Create a copy of ParseArchiveSaveBookParam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? archiveName = null,Object? tempPaths = null,}) {
  return _then(_ParseArchiveSaveBookParam(
archiveName: null == archiveName ? _self.archiveName : archiveName // ignore: cast_nullable_to_non_nullable
as String,tempPaths: null == tempPaths ? _self._tempPaths : tempPaths // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
mixin _$ParseArchiveSaveBookProgress {

 int get current; int get total;
/// Create a copy of ParseArchiveSaveBookProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParseArchiveSaveBookProgressCopyWith<ParseArchiveSaveBookProgress> get copyWith => _$ParseArchiveSaveBookProgressCopyWithImpl<ParseArchiveSaveBookProgress>(this as ParseArchiveSaveBookProgress, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParseArchiveSaveBookProgress&&(identical(other.current, current) || other.current == current)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,current,total);

@override
String toString() {
  return 'ParseArchiveSaveBookProgress(current: $current, total: $total)';
}


}

/// @nodoc
abstract mixin class $ParseArchiveSaveBookProgressCopyWith<$Res>  {
  factory $ParseArchiveSaveBookProgressCopyWith(ParseArchiveSaveBookProgress value, $Res Function(ParseArchiveSaveBookProgress) _then) = _$ParseArchiveSaveBookProgressCopyWithImpl;
@useResult
$Res call({
 int current, int total
});




}
/// @nodoc
class _$ParseArchiveSaveBookProgressCopyWithImpl<$Res>
    implements $ParseArchiveSaveBookProgressCopyWith<$Res> {
  _$ParseArchiveSaveBookProgressCopyWithImpl(this._self, this._then);

  final ParseArchiveSaveBookProgress _self;
  final $Res Function(ParseArchiveSaveBookProgress) _then;

/// Create a copy of ParseArchiveSaveBookProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? current = null,Object? total = null,}) {
  return _then(_self.copyWith(
current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ParseArchiveSaveBookProgress].
extension ParseArchiveSaveBookProgressPatterns on ParseArchiveSaveBookProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParseArchiveSaveBookProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParseArchiveSaveBookProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParseArchiveSaveBookProgress value)  $default,){
final _that = this;
switch (_that) {
case _ParseArchiveSaveBookProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParseArchiveSaveBookProgress value)?  $default,){
final _that = this;
switch (_that) {
case _ParseArchiveSaveBookProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int current,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParseArchiveSaveBookProgress() when $default != null:
return $default(_that.current,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int current,  int total)  $default,) {final _that = this;
switch (_that) {
case _ParseArchiveSaveBookProgress():
return $default(_that.current,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int current,  int total)?  $default,) {final _that = this;
switch (_that) {
case _ParseArchiveSaveBookProgress() when $default != null:
return $default(_that.current,_that.total);case _:
  return null;

}
}

}

/// @nodoc


class _ParseArchiveSaveBookProgress implements ParseArchiveSaveBookProgress {
  const _ParseArchiveSaveBookProgress({this.current = 0, this.total = 0});
  

@override@JsonKey() final  int current;
@override@JsonKey() final  int total;

/// Create a copy of ParseArchiveSaveBookProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParseArchiveSaveBookProgressCopyWith<_ParseArchiveSaveBookProgress> get copyWith => __$ParseArchiveSaveBookProgressCopyWithImpl<_ParseArchiveSaveBookProgress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParseArchiveSaveBookProgress&&(identical(other.current, current) || other.current == current)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,current,total);

@override
String toString() {
  return 'ParseArchiveSaveBookProgress(current: $current, total: $total)';
}


}

/// @nodoc
abstract mixin class _$ParseArchiveSaveBookProgressCopyWith<$Res> implements $ParseArchiveSaveBookProgressCopyWith<$Res> {
  factory _$ParseArchiveSaveBookProgressCopyWith(_ParseArchiveSaveBookProgress value, $Res Function(_ParseArchiveSaveBookProgress) _then) = __$ParseArchiveSaveBookProgressCopyWithImpl;
@override @useResult
$Res call({
 int current, int total
});




}
/// @nodoc
class __$ParseArchiveSaveBookProgressCopyWithImpl<$Res>
    implements _$ParseArchiveSaveBookProgressCopyWith<$Res> {
  __$ParseArchiveSaveBookProgressCopyWithImpl(this._self, this._then);

  final _ParseArchiveSaveBookProgress _self;
  final $Res Function(_ParseArchiveSaveBookProgress) _then;

/// Create a copy of ParseArchiveSaveBookProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? current = null,Object? total = null,}) {
  return _then(_ParseArchiveSaveBookProgress(
current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
