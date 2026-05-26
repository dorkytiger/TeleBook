// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parse_batch_archive_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ParseBatchArchiveParam {

 String? get archiveDirPath; List<String>? get archivePaths;
/// Create a copy of ParseBatchArchiveParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParseBatchArchiveParamCopyWith<ParseBatchArchiveParam> get copyWith => _$ParseBatchArchiveParamCopyWithImpl<ParseBatchArchiveParam>(this as ParseBatchArchiveParam, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParseBatchArchiveParam&&(identical(other.archiveDirPath, archiveDirPath) || other.archiveDirPath == archiveDirPath)&&const DeepCollectionEquality().equals(other.archivePaths, archivePaths));
}


@override
int get hashCode => Object.hash(runtimeType,archiveDirPath,const DeepCollectionEquality().hash(archivePaths));

@override
String toString() {
  return 'ParseBatchArchiveParam(archiveDirPath: $archiveDirPath, archivePaths: $archivePaths)';
}


}

/// @nodoc
abstract mixin class $ParseBatchArchiveParamCopyWith<$Res>  {
  factory $ParseBatchArchiveParamCopyWith(ParseBatchArchiveParam value, $Res Function(ParseBatchArchiveParam) _then) = _$ParseBatchArchiveParamCopyWithImpl;
@useResult
$Res call({
 String? archiveDirPath, List<String>? archivePaths
});




}
/// @nodoc
class _$ParseBatchArchiveParamCopyWithImpl<$Res>
    implements $ParseBatchArchiveParamCopyWith<$Res> {
  _$ParseBatchArchiveParamCopyWithImpl(this._self, this._then);

  final ParseBatchArchiveParam _self;
  final $Res Function(ParseBatchArchiveParam) _then;

/// Create a copy of ParseBatchArchiveParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? archiveDirPath = freezed,Object? archivePaths = freezed,}) {
  return _then(_self.copyWith(
archiveDirPath: freezed == archiveDirPath ? _self.archiveDirPath : archiveDirPath // ignore: cast_nullable_to_non_nullable
as String?,archivePaths: freezed == archivePaths ? _self.archivePaths : archivePaths // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ParseBatchArchiveParam].
extension ParseBatchArchiveParamPatterns on ParseBatchArchiveParam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParseBatchArchiveParam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParseBatchArchiveParam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParseBatchArchiveParam value)  $default,){
final _that = this;
switch (_that) {
case _ParseBatchArchiveParam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParseBatchArchiveParam value)?  $default,){
final _that = this;
switch (_that) {
case _ParseBatchArchiveParam() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? archiveDirPath,  List<String>? archivePaths)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParseBatchArchiveParam() when $default != null:
return $default(_that.archiveDirPath,_that.archivePaths);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? archiveDirPath,  List<String>? archivePaths)  $default,) {final _that = this;
switch (_that) {
case _ParseBatchArchiveParam():
return $default(_that.archiveDirPath,_that.archivePaths);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? archiveDirPath,  List<String>? archivePaths)?  $default,) {final _that = this;
switch (_that) {
case _ParseBatchArchiveParam() when $default != null:
return $default(_that.archiveDirPath,_that.archivePaths);case _:
  return null;

}
}

}

/// @nodoc


class _ParseBatchArchiveParam implements ParseBatchArchiveParam {
  const _ParseBatchArchiveParam({this.archiveDirPath, final  List<String>? archivePaths}): _archivePaths = archivePaths;
  

@override final  String? archiveDirPath;
 final  List<String>? _archivePaths;
@override List<String>? get archivePaths {
  final value = _archivePaths;
  if (value == null) return null;
  if (_archivePaths is EqualUnmodifiableListView) return _archivePaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of ParseBatchArchiveParam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParseBatchArchiveParamCopyWith<_ParseBatchArchiveParam> get copyWith => __$ParseBatchArchiveParamCopyWithImpl<_ParseBatchArchiveParam>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParseBatchArchiveParam&&(identical(other.archiveDirPath, archiveDirPath) || other.archiveDirPath == archiveDirPath)&&const DeepCollectionEquality().equals(other._archivePaths, _archivePaths));
}


@override
int get hashCode => Object.hash(runtimeType,archiveDirPath,const DeepCollectionEquality().hash(_archivePaths));

@override
String toString() {
  return 'ParseBatchArchiveParam(archiveDirPath: $archiveDirPath, archivePaths: $archivePaths)';
}


}

/// @nodoc
abstract mixin class _$ParseBatchArchiveParamCopyWith<$Res> implements $ParseBatchArchiveParamCopyWith<$Res> {
  factory _$ParseBatchArchiveParamCopyWith(_ParseBatchArchiveParam value, $Res Function(_ParseBatchArchiveParam) _then) = __$ParseBatchArchiveParamCopyWithImpl;
@override @useResult
$Res call({
 String? archiveDirPath, List<String>? archivePaths
});




}
/// @nodoc
class __$ParseBatchArchiveParamCopyWithImpl<$Res>
    implements _$ParseBatchArchiveParamCopyWith<$Res> {
  __$ParseBatchArchiveParamCopyWithImpl(this._self, this._then);

  final _ParseBatchArchiveParam _self;
  final $Res Function(_ParseBatchArchiveParam) _then;

/// Create a copy of ParseBatchArchiveParam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? archiveDirPath = freezed,Object? archivePaths = freezed,}) {
  return _then(_ParseBatchArchiveParam(
archiveDirPath: freezed == archiveDirPath ? _self.archiveDirPath : archiveDirPath // ignore: cast_nullable_to_non_nullable
as String?,archivePaths: freezed == archivePaths ? _self._archivePaths : archivePaths // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

/// @nodoc
mixin _$ParseBatchArchiveState {

 List<ParseBatchArchiveVo> get parseBatchArchiveList;
/// Create a copy of ParseBatchArchiveState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParseBatchArchiveStateCopyWith<ParseBatchArchiveState> get copyWith => _$ParseBatchArchiveStateCopyWithImpl<ParseBatchArchiveState>(this as ParseBatchArchiveState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParseBatchArchiveState&&const DeepCollectionEquality().equals(other.parseBatchArchiveList, parseBatchArchiveList));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(parseBatchArchiveList));

@override
String toString() {
  return 'ParseBatchArchiveState(parseBatchArchiveList: $parseBatchArchiveList)';
}


}

/// @nodoc
abstract mixin class $ParseBatchArchiveStateCopyWith<$Res>  {
  factory $ParseBatchArchiveStateCopyWith(ParseBatchArchiveState value, $Res Function(ParseBatchArchiveState) _then) = _$ParseBatchArchiveStateCopyWithImpl;
@useResult
$Res call({
 List<ParseBatchArchiveVo> parseBatchArchiveList
});




}
/// @nodoc
class _$ParseBatchArchiveStateCopyWithImpl<$Res>
    implements $ParseBatchArchiveStateCopyWith<$Res> {
  _$ParseBatchArchiveStateCopyWithImpl(this._self, this._then);

  final ParseBatchArchiveState _self;
  final $Res Function(ParseBatchArchiveState) _then;

/// Create a copy of ParseBatchArchiveState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? parseBatchArchiveList = null,}) {
  return _then(_self.copyWith(
parseBatchArchiveList: null == parseBatchArchiveList ? _self.parseBatchArchiveList : parseBatchArchiveList // ignore: cast_nullable_to_non_nullable
as List<ParseBatchArchiveVo>,
  ));
}

}


/// Adds pattern-matching-related methods to [ParseBatchArchiveState].
extension ParseBatchArchiveStatePatterns on ParseBatchArchiveState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParseBatchArchiveState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParseBatchArchiveState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParseBatchArchiveState value)  $default,){
final _that = this;
switch (_that) {
case _ParseBatchArchiveState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParseBatchArchiveState value)?  $default,){
final _that = this;
switch (_that) {
case _ParseBatchArchiveState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ParseBatchArchiveVo> parseBatchArchiveList)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParseBatchArchiveState() when $default != null:
return $default(_that.parseBatchArchiveList);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ParseBatchArchiveVo> parseBatchArchiveList)  $default,) {final _that = this;
switch (_that) {
case _ParseBatchArchiveState():
return $default(_that.parseBatchArchiveList);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ParseBatchArchiveVo> parseBatchArchiveList)?  $default,) {final _that = this;
switch (_that) {
case _ParseBatchArchiveState() when $default != null:
return $default(_that.parseBatchArchiveList);case _:
  return null;

}
}

}

/// @nodoc


class _ParseBatchArchiveState implements ParseBatchArchiveState {
  const _ParseBatchArchiveState({required final  List<ParseBatchArchiveVo> parseBatchArchiveList}): _parseBatchArchiveList = parseBatchArchiveList;
  

 final  List<ParseBatchArchiveVo> _parseBatchArchiveList;
@override List<ParseBatchArchiveVo> get parseBatchArchiveList {
  if (_parseBatchArchiveList is EqualUnmodifiableListView) return _parseBatchArchiveList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_parseBatchArchiveList);
}


/// Create a copy of ParseBatchArchiveState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParseBatchArchiveStateCopyWith<_ParseBatchArchiveState> get copyWith => __$ParseBatchArchiveStateCopyWithImpl<_ParseBatchArchiveState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParseBatchArchiveState&&const DeepCollectionEquality().equals(other._parseBatchArchiveList, _parseBatchArchiveList));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_parseBatchArchiveList));

@override
String toString() {
  return 'ParseBatchArchiveState(parseBatchArchiveList: $parseBatchArchiveList)';
}


}

/// @nodoc
abstract mixin class _$ParseBatchArchiveStateCopyWith<$Res> implements $ParseBatchArchiveStateCopyWith<$Res> {
  factory _$ParseBatchArchiveStateCopyWith(_ParseBatchArchiveState value, $Res Function(_ParseBatchArchiveState) _then) = __$ParseBatchArchiveStateCopyWithImpl;
@override @useResult
$Res call({
 List<ParseBatchArchiveVo> parseBatchArchiveList
});




}
/// @nodoc
class __$ParseBatchArchiveStateCopyWithImpl<$Res>
    implements _$ParseBatchArchiveStateCopyWith<$Res> {
  __$ParseBatchArchiveStateCopyWithImpl(this._self, this._then);

  final _ParseBatchArchiveState _self;
  final $Res Function(_ParseBatchArchiveState) _then;

/// Create a copy of ParseBatchArchiveState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? parseBatchArchiveList = null,}) {
  return _then(_ParseBatchArchiveState(
parseBatchArchiveList: null == parseBatchArchiveList ? _self._parseBatchArchiveList : parseBatchArchiveList // ignore: cast_nullable_to_non_nullable
as List<ParseBatchArchiveVo>,
  ));
}


}

/// @nodoc
mixin _$ParseBatchArchiveProgress {

 int get completeCount; int get totalCount; String get currentFileName; int get currentFileProgress; int get currentFileTotal;
/// Create a copy of ParseBatchArchiveProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParseBatchArchiveProgressCopyWith<ParseBatchArchiveProgress> get copyWith => _$ParseBatchArchiveProgressCopyWithImpl<ParseBatchArchiveProgress>(this as ParseBatchArchiveProgress, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParseBatchArchiveProgress&&(identical(other.completeCount, completeCount) || other.completeCount == completeCount)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.currentFileName, currentFileName) || other.currentFileName == currentFileName)&&(identical(other.currentFileProgress, currentFileProgress) || other.currentFileProgress == currentFileProgress)&&(identical(other.currentFileTotal, currentFileTotal) || other.currentFileTotal == currentFileTotal));
}


@override
int get hashCode => Object.hash(runtimeType,completeCount,totalCount,currentFileName,currentFileProgress,currentFileTotal);

@override
String toString() {
  return 'ParseBatchArchiveProgress(completeCount: $completeCount, totalCount: $totalCount, currentFileName: $currentFileName, currentFileProgress: $currentFileProgress, currentFileTotal: $currentFileTotal)';
}


}

/// @nodoc
abstract mixin class $ParseBatchArchiveProgressCopyWith<$Res>  {
  factory $ParseBatchArchiveProgressCopyWith(ParseBatchArchiveProgress value, $Res Function(ParseBatchArchiveProgress) _then) = _$ParseBatchArchiveProgressCopyWithImpl;
@useResult
$Res call({
 int completeCount, int totalCount, String currentFileName, int currentFileProgress, int currentFileTotal
});




}
/// @nodoc
class _$ParseBatchArchiveProgressCopyWithImpl<$Res>
    implements $ParseBatchArchiveProgressCopyWith<$Res> {
  _$ParseBatchArchiveProgressCopyWithImpl(this._self, this._then);

  final ParseBatchArchiveProgress _self;
  final $Res Function(ParseBatchArchiveProgress) _then;

/// Create a copy of ParseBatchArchiveProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? completeCount = null,Object? totalCount = null,Object? currentFileName = null,Object? currentFileProgress = null,Object? currentFileTotal = null,}) {
  return _then(_self.copyWith(
completeCount: null == completeCount ? _self.completeCount : completeCount // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,currentFileName: null == currentFileName ? _self.currentFileName : currentFileName // ignore: cast_nullable_to_non_nullable
as String,currentFileProgress: null == currentFileProgress ? _self.currentFileProgress : currentFileProgress // ignore: cast_nullable_to_non_nullable
as int,currentFileTotal: null == currentFileTotal ? _self.currentFileTotal : currentFileTotal // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ParseBatchArchiveProgress].
extension ParseBatchArchiveProgressPatterns on ParseBatchArchiveProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParseBatchArchiveProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParseBatchArchiveProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParseBatchArchiveProgress value)  $default,){
final _that = this;
switch (_that) {
case _ParseBatchArchiveProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParseBatchArchiveProgress value)?  $default,){
final _that = this;
switch (_that) {
case _ParseBatchArchiveProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int completeCount,  int totalCount,  String currentFileName,  int currentFileProgress,  int currentFileTotal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParseBatchArchiveProgress() when $default != null:
return $default(_that.completeCount,_that.totalCount,_that.currentFileName,_that.currentFileProgress,_that.currentFileTotal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int completeCount,  int totalCount,  String currentFileName,  int currentFileProgress,  int currentFileTotal)  $default,) {final _that = this;
switch (_that) {
case _ParseBatchArchiveProgress():
return $default(_that.completeCount,_that.totalCount,_that.currentFileName,_that.currentFileProgress,_that.currentFileTotal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int completeCount,  int totalCount,  String currentFileName,  int currentFileProgress,  int currentFileTotal)?  $default,) {final _that = this;
switch (_that) {
case _ParseBatchArchiveProgress() when $default != null:
return $default(_that.completeCount,_that.totalCount,_that.currentFileName,_that.currentFileProgress,_that.currentFileTotal);case _:
  return null;

}
}

}

/// @nodoc


class _ParseBatchArchiveProgress extends ParseBatchArchiveProgress {
  const _ParseBatchArchiveProgress({required this.completeCount, required this.totalCount, required this.currentFileName, required this.currentFileProgress, required this.currentFileTotal}): super._();
  

@override final  int completeCount;
@override final  int totalCount;
@override final  String currentFileName;
@override final  int currentFileProgress;
@override final  int currentFileTotal;

/// Create a copy of ParseBatchArchiveProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParseBatchArchiveProgressCopyWith<_ParseBatchArchiveProgress> get copyWith => __$ParseBatchArchiveProgressCopyWithImpl<_ParseBatchArchiveProgress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParseBatchArchiveProgress&&(identical(other.completeCount, completeCount) || other.completeCount == completeCount)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.currentFileName, currentFileName) || other.currentFileName == currentFileName)&&(identical(other.currentFileProgress, currentFileProgress) || other.currentFileProgress == currentFileProgress)&&(identical(other.currentFileTotal, currentFileTotal) || other.currentFileTotal == currentFileTotal));
}


@override
int get hashCode => Object.hash(runtimeType,completeCount,totalCount,currentFileName,currentFileProgress,currentFileTotal);

@override
String toString() {
  return 'ParseBatchArchiveProgress(completeCount: $completeCount, totalCount: $totalCount, currentFileName: $currentFileName, currentFileProgress: $currentFileProgress, currentFileTotal: $currentFileTotal)';
}


}

/// @nodoc
abstract mixin class _$ParseBatchArchiveProgressCopyWith<$Res> implements $ParseBatchArchiveProgressCopyWith<$Res> {
  factory _$ParseBatchArchiveProgressCopyWith(_ParseBatchArchiveProgress value, $Res Function(_ParseBatchArchiveProgress) _then) = __$ParseBatchArchiveProgressCopyWithImpl;
@override @useResult
$Res call({
 int completeCount, int totalCount, String currentFileName, int currentFileProgress, int currentFileTotal
});




}
/// @nodoc
class __$ParseBatchArchiveProgressCopyWithImpl<$Res>
    implements _$ParseBatchArchiveProgressCopyWith<$Res> {
  __$ParseBatchArchiveProgressCopyWithImpl(this._self, this._then);

  final _ParseBatchArchiveProgress _self;
  final $Res Function(_ParseBatchArchiveProgress) _then;

/// Create a copy of ParseBatchArchiveProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? completeCount = null,Object? totalCount = null,Object? currentFileName = null,Object? currentFileProgress = null,Object? currentFileTotal = null,}) {
  return _then(_ParseBatchArchiveProgress(
completeCount: null == completeCount ? _self.completeCount : completeCount // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,currentFileName: null == currentFileName ? _self.currentFileName : currentFileName // ignore: cast_nullable_to_non_nullable
as String,currentFileProgress: null == currentFileProgress ? _self.currentFileProgress : currentFileProgress // ignore: cast_nullable_to_non_nullable
as int,currentFileTotal: null == currentFileTotal ? _self.currentFileTotal : currentFileTotal // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$ParseBatchArchiveSaveBookProgress {

 int get current; int get total;
/// Create a copy of ParseBatchArchiveSaveBookProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParseBatchArchiveSaveBookProgressCopyWith<ParseBatchArchiveSaveBookProgress> get copyWith => _$ParseBatchArchiveSaveBookProgressCopyWithImpl<ParseBatchArchiveSaveBookProgress>(this as ParseBatchArchiveSaveBookProgress, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParseBatchArchiveSaveBookProgress&&(identical(other.current, current) || other.current == current)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,current,total);

@override
String toString() {
  return 'ParseBatchArchiveSaveBookProgress(current: $current, total: $total)';
}


}

/// @nodoc
abstract mixin class $ParseBatchArchiveSaveBookProgressCopyWith<$Res>  {
  factory $ParseBatchArchiveSaveBookProgressCopyWith(ParseBatchArchiveSaveBookProgress value, $Res Function(ParseBatchArchiveSaveBookProgress) _then) = _$ParseBatchArchiveSaveBookProgressCopyWithImpl;
@useResult
$Res call({
 int current, int total
});




}
/// @nodoc
class _$ParseBatchArchiveSaveBookProgressCopyWithImpl<$Res>
    implements $ParseBatchArchiveSaveBookProgressCopyWith<$Res> {
  _$ParseBatchArchiveSaveBookProgressCopyWithImpl(this._self, this._then);

  final ParseBatchArchiveSaveBookProgress _self;
  final $Res Function(ParseBatchArchiveSaveBookProgress) _then;

/// Create a copy of ParseBatchArchiveSaveBookProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? current = null,Object? total = null,}) {
  return _then(_self.copyWith(
current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ParseBatchArchiveSaveBookProgress].
extension ParseBatchArchiveSaveBookProgressPatterns on ParseBatchArchiveSaveBookProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParseBatchArchiveSaveBookProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParseBatchArchiveSaveBookProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParseBatchArchiveSaveBookProgress value)  $default,){
final _that = this;
switch (_that) {
case _ParseBatchArchiveSaveBookProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParseBatchArchiveSaveBookProgress value)?  $default,){
final _that = this;
switch (_that) {
case _ParseBatchArchiveSaveBookProgress() when $default != null:
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
case _ParseBatchArchiveSaveBookProgress() when $default != null:
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
case _ParseBatchArchiveSaveBookProgress():
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
case _ParseBatchArchiveSaveBookProgress() when $default != null:
return $default(_that.current,_that.total);case _:
  return null;

}
}

}

/// @nodoc


class _ParseBatchArchiveSaveBookProgress implements ParseBatchArchiveSaveBookProgress {
  const _ParseBatchArchiveSaveBookProgress({this.current = 0, this.total = 0});
  

@override@JsonKey() final  int current;
@override@JsonKey() final  int total;

/// Create a copy of ParseBatchArchiveSaveBookProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParseBatchArchiveSaveBookProgressCopyWith<_ParseBatchArchiveSaveBookProgress> get copyWith => __$ParseBatchArchiveSaveBookProgressCopyWithImpl<_ParseBatchArchiveSaveBookProgress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParseBatchArchiveSaveBookProgress&&(identical(other.current, current) || other.current == current)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,current,total);

@override
String toString() {
  return 'ParseBatchArchiveSaveBookProgress(current: $current, total: $total)';
}


}

/// @nodoc
abstract mixin class _$ParseBatchArchiveSaveBookProgressCopyWith<$Res> implements $ParseBatchArchiveSaveBookProgressCopyWith<$Res> {
  factory _$ParseBatchArchiveSaveBookProgressCopyWith(_ParseBatchArchiveSaveBookProgress value, $Res Function(_ParseBatchArchiveSaveBookProgress) _then) = __$ParseBatchArchiveSaveBookProgressCopyWithImpl;
@override @useResult
$Res call({
 int current, int total
});




}
/// @nodoc
class __$ParseBatchArchiveSaveBookProgressCopyWithImpl<$Res>
    implements _$ParseBatchArchiveSaveBookProgressCopyWith<$Res> {
  __$ParseBatchArchiveSaveBookProgressCopyWithImpl(this._self, this._then);

  final _ParseBatchArchiveSaveBookProgress _self;
  final $Res Function(_ParseBatchArchiveSaveBookProgress) _then;

/// Create a copy of ParseBatchArchiveSaveBookProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? current = null,Object? total = null,}) {
  return _then(_ParseBatchArchiveSaveBookProgress(
current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
