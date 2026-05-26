// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parse_batch_pdf_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ParseBatchPdfProgress {

 int get completeCount; int get totalCount; String get currentFileName; int get currentFileProgress; int get currentFileTotal;
/// Create a copy of ParseBatchPdfProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParseBatchPdfProgressCopyWith<ParseBatchPdfProgress> get copyWith => _$ParseBatchPdfProgressCopyWithImpl<ParseBatchPdfProgress>(this as ParseBatchPdfProgress, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParseBatchPdfProgress&&(identical(other.completeCount, completeCount) || other.completeCount == completeCount)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.currentFileName, currentFileName) || other.currentFileName == currentFileName)&&(identical(other.currentFileProgress, currentFileProgress) || other.currentFileProgress == currentFileProgress)&&(identical(other.currentFileTotal, currentFileTotal) || other.currentFileTotal == currentFileTotal));
}


@override
int get hashCode => Object.hash(runtimeType,completeCount,totalCount,currentFileName,currentFileProgress,currentFileTotal);

@override
String toString() {
  return 'ParseBatchPdfProgress(completeCount: $completeCount, totalCount: $totalCount, currentFileName: $currentFileName, currentFileProgress: $currentFileProgress, currentFileTotal: $currentFileTotal)';
}


}

/// @nodoc
abstract mixin class $ParseBatchPdfProgressCopyWith<$Res>  {
  factory $ParseBatchPdfProgressCopyWith(ParseBatchPdfProgress value, $Res Function(ParseBatchPdfProgress) _then) = _$ParseBatchPdfProgressCopyWithImpl;
@useResult
$Res call({
 int completeCount, int totalCount, String currentFileName, int currentFileProgress, int currentFileTotal
});




}
/// @nodoc
class _$ParseBatchPdfProgressCopyWithImpl<$Res>
    implements $ParseBatchPdfProgressCopyWith<$Res> {
  _$ParseBatchPdfProgressCopyWithImpl(this._self, this._then);

  final ParseBatchPdfProgress _self;
  final $Res Function(ParseBatchPdfProgress) _then;

/// Create a copy of ParseBatchPdfProgress
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


/// Adds pattern-matching-related methods to [ParseBatchPdfProgress].
extension ParseBatchPdfProgressPatterns on ParseBatchPdfProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParseBatchPdfProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParseBatchPdfProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParseBatchPdfProgress value)  $default,){
final _that = this;
switch (_that) {
case _ParseBatchPdfProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParseBatchPdfProgress value)?  $default,){
final _that = this;
switch (_that) {
case _ParseBatchPdfProgress() when $default != null:
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
case _ParseBatchPdfProgress() when $default != null:
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
case _ParseBatchPdfProgress():
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
case _ParseBatchPdfProgress() when $default != null:
return $default(_that.completeCount,_that.totalCount,_that.currentFileName,_that.currentFileProgress,_that.currentFileTotal);case _:
  return null;

}
}

}

/// @nodoc


class _ParseBatchPdfProgress implements ParseBatchPdfProgress {
  const _ParseBatchPdfProgress({required this.completeCount, required this.totalCount, required this.currentFileName, required this.currentFileProgress, required this.currentFileTotal});
  

@override final  int completeCount;
@override final  int totalCount;
@override final  String currentFileName;
@override final  int currentFileProgress;
@override final  int currentFileTotal;

/// Create a copy of ParseBatchPdfProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParseBatchPdfProgressCopyWith<_ParseBatchPdfProgress> get copyWith => __$ParseBatchPdfProgressCopyWithImpl<_ParseBatchPdfProgress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParseBatchPdfProgress&&(identical(other.completeCount, completeCount) || other.completeCount == completeCount)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.currentFileName, currentFileName) || other.currentFileName == currentFileName)&&(identical(other.currentFileProgress, currentFileProgress) || other.currentFileProgress == currentFileProgress)&&(identical(other.currentFileTotal, currentFileTotal) || other.currentFileTotal == currentFileTotal));
}


@override
int get hashCode => Object.hash(runtimeType,completeCount,totalCount,currentFileName,currentFileProgress,currentFileTotal);

@override
String toString() {
  return 'ParseBatchPdfProgress(completeCount: $completeCount, totalCount: $totalCount, currentFileName: $currentFileName, currentFileProgress: $currentFileProgress, currentFileTotal: $currentFileTotal)';
}


}

/// @nodoc
abstract mixin class _$ParseBatchPdfProgressCopyWith<$Res> implements $ParseBatchPdfProgressCopyWith<$Res> {
  factory _$ParseBatchPdfProgressCopyWith(_ParseBatchPdfProgress value, $Res Function(_ParseBatchPdfProgress) _then) = __$ParseBatchPdfProgressCopyWithImpl;
@override @useResult
$Res call({
 int completeCount, int totalCount, String currentFileName, int currentFileProgress, int currentFileTotal
});




}
/// @nodoc
class __$ParseBatchPdfProgressCopyWithImpl<$Res>
    implements _$ParseBatchPdfProgressCopyWith<$Res> {
  __$ParseBatchPdfProgressCopyWithImpl(this._self, this._then);

  final _ParseBatchPdfProgress _self;
  final $Res Function(_ParseBatchPdfProgress) _then;

/// Create a copy of ParseBatchPdfProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? completeCount = null,Object? totalCount = null,Object? currentFileName = null,Object? currentFileProgress = null,Object? currentFileTotal = null,}) {
  return _then(_ParseBatchPdfProgress(
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
mixin _$ParseBatchPdfState {

 List<ParseBatchArchiveVo> get parseBatchList;
/// Create a copy of ParseBatchPdfState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParseBatchPdfStateCopyWith<ParseBatchPdfState> get copyWith => _$ParseBatchPdfStateCopyWithImpl<ParseBatchPdfState>(this as ParseBatchPdfState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParseBatchPdfState&&const DeepCollectionEquality().equals(other.parseBatchList, parseBatchList));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(parseBatchList));

@override
String toString() {
  return 'ParseBatchPdfState(parseBatchList: $parseBatchList)';
}


}

/// @nodoc
abstract mixin class $ParseBatchPdfStateCopyWith<$Res>  {
  factory $ParseBatchPdfStateCopyWith(ParseBatchPdfState value, $Res Function(ParseBatchPdfState) _then) = _$ParseBatchPdfStateCopyWithImpl;
@useResult
$Res call({
 List<ParseBatchArchiveVo> parseBatchList
});




}
/// @nodoc
class _$ParseBatchPdfStateCopyWithImpl<$Res>
    implements $ParseBatchPdfStateCopyWith<$Res> {
  _$ParseBatchPdfStateCopyWithImpl(this._self, this._then);

  final ParseBatchPdfState _self;
  final $Res Function(ParseBatchPdfState) _then;

/// Create a copy of ParseBatchPdfState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? parseBatchList = null,}) {
  return _then(_self.copyWith(
parseBatchList: null == parseBatchList ? _self.parseBatchList : parseBatchList // ignore: cast_nullable_to_non_nullable
as List<ParseBatchArchiveVo>,
  ));
}

}


/// Adds pattern-matching-related methods to [ParseBatchPdfState].
extension ParseBatchPdfStatePatterns on ParseBatchPdfState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParseBatchPdfState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParseBatchPdfState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParseBatchPdfState value)  $default,){
final _that = this;
switch (_that) {
case _ParseBatchPdfState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParseBatchPdfState value)?  $default,){
final _that = this;
switch (_that) {
case _ParseBatchPdfState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ParseBatchArchiveVo> parseBatchList)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParseBatchPdfState() when $default != null:
return $default(_that.parseBatchList);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ParseBatchArchiveVo> parseBatchList)  $default,) {final _that = this;
switch (_that) {
case _ParseBatchPdfState():
return $default(_that.parseBatchList);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ParseBatchArchiveVo> parseBatchList)?  $default,) {final _that = this;
switch (_that) {
case _ParseBatchPdfState() when $default != null:
return $default(_that.parseBatchList);case _:
  return null;

}
}

}

/// @nodoc


class _ParseBatchPdfState implements ParseBatchPdfState {
  const _ParseBatchPdfState({required final  List<ParseBatchArchiveVo> parseBatchList}): _parseBatchList = parseBatchList;
  

 final  List<ParseBatchArchiveVo> _parseBatchList;
@override List<ParseBatchArchiveVo> get parseBatchList {
  if (_parseBatchList is EqualUnmodifiableListView) return _parseBatchList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_parseBatchList);
}


/// Create a copy of ParseBatchPdfState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParseBatchPdfStateCopyWith<_ParseBatchPdfState> get copyWith => __$ParseBatchPdfStateCopyWithImpl<_ParseBatchPdfState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParseBatchPdfState&&const DeepCollectionEquality().equals(other._parseBatchList, _parseBatchList));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_parseBatchList));

@override
String toString() {
  return 'ParseBatchPdfState(parseBatchList: $parseBatchList)';
}


}

/// @nodoc
abstract mixin class _$ParseBatchPdfStateCopyWith<$Res> implements $ParseBatchPdfStateCopyWith<$Res> {
  factory _$ParseBatchPdfStateCopyWith(_ParseBatchPdfState value, $Res Function(_ParseBatchPdfState) _then) = __$ParseBatchPdfStateCopyWithImpl;
@override @useResult
$Res call({
 List<ParseBatchArchiveVo> parseBatchList
});




}
/// @nodoc
class __$ParseBatchPdfStateCopyWithImpl<$Res>
    implements _$ParseBatchPdfStateCopyWith<$Res> {
  __$ParseBatchPdfStateCopyWithImpl(this._self, this._then);

  final _ParseBatchPdfState _self;
  final $Res Function(_ParseBatchPdfState) _then;

/// Create a copy of ParseBatchPdfState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? parseBatchList = null,}) {
  return _then(_ParseBatchPdfState(
parseBatchList: null == parseBatchList ? _self._parseBatchList : parseBatchList // ignore: cast_nullable_to_non_nullable
as List<ParseBatchArchiveVo>,
  ));
}


}

/// @nodoc
mixin _$ParseBatchPdfParam {

 String? get pdfDirPath; List<String>? get pdfPaths;
/// Create a copy of ParseBatchPdfParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParseBatchPdfParamCopyWith<ParseBatchPdfParam> get copyWith => _$ParseBatchPdfParamCopyWithImpl<ParseBatchPdfParam>(this as ParseBatchPdfParam, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParseBatchPdfParam&&(identical(other.pdfDirPath, pdfDirPath) || other.pdfDirPath == pdfDirPath)&&const DeepCollectionEquality().equals(other.pdfPaths, pdfPaths));
}


@override
int get hashCode => Object.hash(runtimeType,pdfDirPath,const DeepCollectionEquality().hash(pdfPaths));

@override
String toString() {
  return 'ParseBatchPdfParam(pdfDirPath: $pdfDirPath, pdfPaths: $pdfPaths)';
}


}

/// @nodoc
abstract mixin class $ParseBatchPdfParamCopyWith<$Res>  {
  factory $ParseBatchPdfParamCopyWith(ParseBatchPdfParam value, $Res Function(ParseBatchPdfParam) _then) = _$ParseBatchPdfParamCopyWithImpl;
@useResult
$Res call({
 String? pdfDirPath, List<String>? pdfPaths
});




}
/// @nodoc
class _$ParseBatchPdfParamCopyWithImpl<$Res>
    implements $ParseBatchPdfParamCopyWith<$Res> {
  _$ParseBatchPdfParamCopyWithImpl(this._self, this._then);

  final ParseBatchPdfParam _self;
  final $Res Function(ParseBatchPdfParam) _then;

/// Create a copy of ParseBatchPdfParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pdfDirPath = freezed,Object? pdfPaths = freezed,}) {
  return _then(_self.copyWith(
pdfDirPath: freezed == pdfDirPath ? _self.pdfDirPath : pdfDirPath // ignore: cast_nullable_to_non_nullable
as String?,pdfPaths: freezed == pdfPaths ? _self.pdfPaths : pdfPaths // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ParseBatchPdfParam].
extension ParseBatchPdfParamPatterns on ParseBatchPdfParam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParseBatchPdfParam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParseBatchPdfParam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParseBatchPdfParam value)  $default,){
final _that = this;
switch (_that) {
case _ParseBatchPdfParam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParseBatchPdfParam value)?  $default,){
final _that = this;
switch (_that) {
case _ParseBatchPdfParam() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? pdfDirPath,  List<String>? pdfPaths)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParseBatchPdfParam() when $default != null:
return $default(_that.pdfDirPath,_that.pdfPaths);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? pdfDirPath,  List<String>? pdfPaths)  $default,) {final _that = this;
switch (_that) {
case _ParseBatchPdfParam():
return $default(_that.pdfDirPath,_that.pdfPaths);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? pdfDirPath,  List<String>? pdfPaths)?  $default,) {final _that = this;
switch (_that) {
case _ParseBatchPdfParam() when $default != null:
return $default(_that.pdfDirPath,_that.pdfPaths);case _:
  return null;

}
}

}

/// @nodoc


class _ParseBatchPdfParam implements ParseBatchPdfParam {
  const _ParseBatchPdfParam({required this.pdfDirPath, required final  List<String>? pdfPaths}): _pdfPaths = pdfPaths;
  

@override final  String? pdfDirPath;
 final  List<String>? _pdfPaths;
@override List<String>? get pdfPaths {
  final value = _pdfPaths;
  if (value == null) return null;
  if (_pdfPaths is EqualUnmodifiableListView) return _pdfPaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of ParseBatchPdfParam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParseBatchPdfParamCopyWith<_ParseBatchPdfParam> get copyWith => __$ParseBatchPdfParamCopyWithImpl<_ParseBatchPdfParam>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParseBatchPdfParam&&(identical(other.pdfDirPath, pdfDirPath) || other.pdfDirPath == pdfDirPath)&&const DeepCollectionEquality().equals(other._pdfPaths, _pdfPaths));
}


@override
int get hashCode => Object.hash(runtimeType,pdfDirPath,const DeepCollectionEquality().hash(_pdfPaths));

@override
String toString() {
  return 'ParseBatchPdfParam(pdfDirPath: $pdfDirPath, pdfPaths: $pdfPaths)';
}


}

/// @nodoc
abstract mixin class _$ParseBatchPdfParamCopyWith<$Res> implements $ParseBatchPdfParamCopyWith<$Res> {
  factory _$ParseBatchPdfParamCopyWith(_ParseBatchPdfParam value, $Res Function(_ParseBatchPdfParam) _then) = __$ParseBatchPdfParamCopyWithImpl;
@override @useResult
$Res call({
 String? pdfDirPath, List<String>? pdfPaths
});




}
/// @nodoc
class __$ParseBatchPdfParamCopyWithImpl<$Res>
    implements _$ParseBatchPdfParamCopyWith<$Res> {
  __$ParseBatchPdfParamCopyWithImpl(this._self, this._then);

  final _ParseBatchPdfParam _self;
  final $Res Function(_ParseBatchPdfParam) _then;

/// Create a copy of ParseBatchPdfParam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pdfDirPath = freezed,Object? pdfPaths = freezed,}) {
  return _then(_ParseBatchPdfParam(
pdfDirPath: freezed == pdfDirPath ? _self.pdfDirPath : pdfDirPath // ignore: cast_nullable_to_non_nullable
as String?,pdfPaths: freezed == pdfPaths ? _self._pdfPaths : pdfPaths // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

/// @nodoc
mixin _$ParseBatchPdfSaveBookProgressState {

 int get current; int get total;
/// Create a copy of ParseBatchPdfSaveBookProgressState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParseBatchPdfSaveBookProgressStateCopyWith<ParseBatchPdfSaveBookProgressState> get copyWith => _$ParseBatchPdfSaveBookProgressStateCopyWithImpl<ParseBatchPdfSaveBookProgressState>(this as ParseBatchPdfSaveBookProgressState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParseBatchPdfSaveBookProgressState&&(identical(other.current, current) || other.current == current)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,current,total);

@override
String toString() {
  return 'ParseBatchPdfSaveBookProgressState(current: $current, total: $total)';
}


}

/// @nodoc
abstract mixin class $ParseBatchPdfSaveBookProgressStateCopyWith<$Res>  {
  factory $ParseBatchPdfSaveBookProgressStateCopyWith(ParseBatchPdfSaveBookProgressState value, $Res Function(ParseBatchPdfSaveBookProgressState) _then) = _$ParseBatchPdfSaveBookProgressStateCopyWithImpl;
@useResult
$Res call({
 int current, int total
});




}
/// @nodoc
class _$ParseBatchPdfSaveBookProgressStateCopyWithImpl<$Res>
    implements $ParseBatchPdfSaveBookProgressStateCopyWith<$Res> {
  _$ParseBatchPdfSaveBookProgressStateCopyWithImpl(this._self, this._then);

  final ParseBatchPdfSaveBookProgressState _self;
  final $Res Function(ParseBatchPdfSaveBookProgressState) _then;

/// Create a copy of ParseBatchPdfSaveBookProgressState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? current = null,Object? total = null,}) {
  return _then(_self.copyWith(
current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ParseBatchPdfSaveBookProgressState].
extension ParseBatchPdfSaveBookProgressStatePatterns on ParseBatchPdfSaveBookProgressState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParseBatchPdfSaveBookProgressState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParseBatchPdfSaveBookProgressState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParseBatchPdfSaveBookProgressState value)  $default,){
final _that = this;
switch (_that) {
case _ParseBatchPdfSaveBookProgressState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParseBatchPdfSaveBookProgressState value)?  $default,){
final _that = this;
switch (_that) {
case _ParseBatchPdfSaveBookProgressState() when $default != null:
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
case _ParseBatchPdfSaveBookProgressState() when $default != null:
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
case _ParseBatchPdfSaveBookProgressState():
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
case _ParseBatchPdfSaveBookProgressState() when $default != null:
return $default(_that.current,_that.total);case _:
  return null;

}
}

}

/// @nodoc


class _ParseBatchPdfSaveBookProgressState implements ParseBatchPdfSaveBookProgressState {
  const _ParseBatchPdfSaveBookProgressState({this.current = 0, this.total = 0});
  

@override@JsonKey() final  int current;
@override@JsonKey() final  int total;

/// Create a copy of ParseBatchPdfSaveBookProgressState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParseBatchPdfSaveBookProgressStateCopyWith<_ParseBatchPdfSaveBookProgressState> get copyWith => __$ParseBatchPdfSaveBookProgressStateCopyWithImpl<_ParseBatchPdfSaveBookProgressState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParseBatchPdfSaveBookProgressState&&(identical(other.current, current) || other.current == current)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,current,total);

@override
String toString() {
  return 'ParseBatchPdfSaveBookProgressState(current: $current, total: $total)';
}


}

/// @nodoc
abstract mixin class _$ParseBatchPdfSaveBookProgressStateCopyWith<$Res> implements $ParseBatchPdfSaveBookProgressStateCopyWith<$Res> {
  factory _$ParseBatchPdfSaveBookProgressStateCopyWith(_ParseBatchPdfSaveBookProgressState value, $Res Function(_ParseBatchPdfSaveBookProgressState) _then) = __$ParseBatchPdfSaveBookProgressStateCopyWithImpl;
@override @useResult
$Res call({
 int current, int total
});




}
/// @nodoc
class __$ParseBatchPdfSaveBookProgressStateCopyWithImpl<$Res>
    implements _$ParseBatchPdfSaveBookProgressStateCopyWith<$Res> {
  __$ParseBatchPdfSaveBookProgressStateCopyWithImpl(this._self, this._then);

  final _ParseBatchPdfSaveBookProgressState _self;
  final $Res Function(_ParseBatchPdfSaveBookProgressState) _then;

/// Create a copy of ParseBatchPdfSaveBookProgressState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? current = null,Object? total = null,}) {
  return _then(_ParseBatchPdfSaveBookProgressState(
current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
