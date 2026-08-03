// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parse_batch_image_folder.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ParseBatchImageFolderState {

 List<ParseBatchArchiveVo> get parseBatchFolderList; int get completeCount; int get totalCount; String get currentFileName; int get currentFileProgress; int get currentFileTotal; bool get isParsing;
/// Create a copy of ParseBatchImageFolderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParseBatchImageFolderStateCopyWith<ParseBatchImageFolderState> get copyWith => _$ParseBatchImageFolderStateCopyWithImpl<ParseBatchImageFolderState>(this as ParseBatchImageFolderState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParseBatchImageFolderState&&const DeepCollectionEquality().equals(other.parseBatchFolderList, parseBatchFolderList)&&(identical(other.completeCount, completeCount) || other.completeCount == completeCount)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.currentFileName, currentFileName) || other.currentFileName == currentFileName)&&(identical(other.currentFileProgress, currentFileProgress) || other.currentFileProgress == currentFileProgress)&&(identical(other.currentFileTotal, currentFileTotal) || other.currentFileTotal == currentFileTotal)&&(identical(other.isParsing, isParsing) || other.isParsing == isParsing));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(parseBatchFolderList),completeCount,totalCount,currentFileName,currentFileProgress,currentFileTotal,isParsing);

@override
String toString() {
  return 'ParseBatchImageFolderState(parseBatchFolderList: $parseBatchFolderList, completeCount: $completeCount, totalCount: $totalCount, currentFileName: $currentFileName, currentFileProgress: $currentFileProgress, currentFileTotal: $currentFileTotal, isParsing: $isParsing)';
}


}

/// @nodoc
abstract mixin class $ParseBatchImageFolderStateCopyWith<$Res>  {
  factory $ParseBatchImageFolderStateCopyWith(ParseBatchImageFolderState value, $Res Function(ParseBatchImageFolderState) _then) = _$ParseBatchImageFolderStateCopyWithImpl;
@useResult
$Res call({
 List<ParseBatchArchiveVo> parseBatchFolderList, int completeCount, int totalCount, String currentFileName, int currentFileProgress, int currentFileTotal, bool isParsing
});




}
/// @nodoc
class _$ParseBatchImageFolderStateCopyWithImpl<$Res>
    implements $ParseBatchImageFolderStateCopyWith<$Res> {
  _$ParseBatchImageFolderStateCopyWithImpl(this._self, this._then);

  final ParseBatchImageFolderState _self;
  final $Res Function(ParseBatchImageFolderState) _then;

/// Create a copy of ParseBatchImageFolderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? parseBatchFolderList = null,Object? completeCount = null,Object? totalCount = null,Object? currentFileName = null,Object? currentFileProgress = null,Object? currentFileTotal = null,Object? isParsing = null,}) {
  return _then(_self.copyWith(
parseBatchFolderList: null == parseBatchFolderList ? _self.parseBatchFolderList : parseBatchFolderList // ignore: cast_nullable_to_non_nullable
as List<ParseBatchArchiveVo>,completeCount: null == completeCount ? _self.completeCount : completeCount // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,currentFileName: null == currentFileName ? _self.currentFileName : currentFileName // ignore: cast_nullable_to_non_nullable
as String,currentFileProgress: null == currentFileProgress ? _self.currentFileProgress : currentFileProgress // ignore: cast_nullable_to_non_nullable
as int,currentFileTotal: null == currentFileTotal ? _self.currentFileTotal : currentFileTotal // ignore: cast_nullable_to_non_nullable
as int,isParsing: null == isParsing ? _self.isParsing : isParsing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ParseBatchImageFolderState].
extension ParseBatchImageFolderStatePatterns on ParseBatchImageFolderState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParseBatchImageFolderState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParseBatchImageFolderState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParseBatchImageFolderState value)  $default,){
final _that = this;
switch (_that) {
case _ParseBatchImageFolderState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParseBatchImageFolderState value)?  $default,){
final _that = this;
switch (_that) {
case _ParseBatchImageFolderState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ParseBatchArchiveVo> parseBatchFolderList,  int completeCount,  int totalCount,  String currentFileName,  int currentFileProgress,  int currentFileTotal,  bool isParsing)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParseBatchImageFolderState() when $default != null:
return $default(_that.parseBatchFolderList,_that.completeCount,_that.totalCount,_that.currentFileName,_that.currentFileProgress,_that.currentFileTotal,_that.isParsing);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ParseBatchArchiveVo> parseBatchFolderList,  int completeCount,  int totalCount,  String currentFileName,  int currentFileProgress,  int currentFileTotal,  bool isParsing)  $default,) {final _that = this;
switch (_that) {
case _ParseBatchImageFolderState():
return $default(_that.parseBatchFolderList,_that.completeCount,_that.totalCount,_that.currentFileName,_that.currentFileProgress,_that.currentFileTotal,_that.isParsing);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ParseBatchArchiveVo> parseBatchFolderList,  int completeCount,  int totalCount,  String currentFileName,  int currentFileProgress,  int currentFileTotal,  bool isParsing)?  $default,) {final _that = this;
switch (_that) {
case _ParseBatchImageFolderState() when $default != null:
return $default(_that.parseBatchFolderList,_that.completeCount,_that.totalCount,_that.currentFileName,_that.currentFileProgress,_that.currentFileTotal,_that.isParsing);case _:
  return null;

}
}

}

/// @nodoc


class _ParseBatchImageFolderState extends ParseBatchImageFolderState {
  const _ParseBatchImageFolderState({final  List<ParseBatchArchiveVo> parseBatchFolderList = const [], this.completeCount = 0, this.totalCount = 0, this.currentFileName = '', this.currentFileProgress = 0, this.currentFileTotal = 0, this.isParsing = false}): _parseBatchFolderList = parseBatchFolderList,super._();
  

 final  List<ParseBatchArchiveVo> _parseBatchFolderList;
@override@JsonKey() List<ParseBatchArchiveVo> get parseBatchFolderList {
  if (_parseBatchFolderList is EqualUnmodifiableListView) return _parseBatchFolderList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_parseBatchFolderList);
}

@override@JsonKey() final  int completeCount;
@override@JsonKey() final  int totalCount;
@override@JsonKey() final  String currentFileName;
@override@JsonKey() final  int currentFileProgress;
@override@JsonKey() final  int currentFileTotal;
@override@JsonKey() final  bool isParsing;

/// Create a copy of ParseBatchImageFolderState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParseBatchImageFolderStateCopyWith<_ParseBatchImageFolderState> get copyWith => __$ParseBatchImageFolderStateCopyWithImpl<_ParseBatchImageFolderState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParseBatchImageFolderState&&const DeepCollectionEquality().equals(other._parseBatchFolderList, _parseBatchFolderList)&&(identical(other.completeCount, completeCount) || other.completeCount == completeCount)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.currentFileName, currentFileName) || other.currentFileName == currentFileName)&&(identical(other.currentFileProgress, currentFileProgress) || other.currentFileProgress == currentFileProgress)&&(identical(other.currentFileTotal, currentFileTotal) || other.currentFileTotal == currentFileTotal)&&(identical(other.isParsing, isParsing) || other.isParsing == isParsing));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_parseBatchFolderList),completeCount,totalCount,currentFileName,currentFileProgress,currentFileTotal,isParsing);

@override
String toString() {
  return 'ParseBatchImageFolderState(parseBatchFolderList: $parseBatchFolderList, completeCount: $completeCount, totalCount: $totalCount, currentFileName: $currentFileName, currentFileProgress: $currentFileProgress, currentFileTotal: $currentFileTotal, isParsing: $isParsing)';
}


}

/// @nodoc
abstract mixin class _$ParseBatchImageFolderStateCopyWith<$Res> implements $ParseBatchImageFolderStateCopyWith<$Res> {
  factory _$ParseBatchImageFolderStateCopyWith(_ParseBatchImageFolderState value, $Res Function(_ParseBatchImageFolderState) _then) = __$ParseBatchImageFolderStateCopyWithImpl;
@override @useResult
$Res call({
 List<ParseBatchArchiveVo> parseBatchFolderList, int completeCount, int totalCount, String currentFileName, int currentFileProgress, int currentFileTotal, bool isParsing
});




}
/// @nodoc
class __$ParseBatchImageFolderStateCopyWithImpl<$Res>
    implements _$ParseBatchImageFolderStateCopyWith<$Res> {
  __$ParseBatchImageFolderStateCopyWithImpl(this._self, this._then);

  final _ParseBatchImageFolderState _self;
  final $Res Function(_ParseBatchImageFolderState) _then;

/// Create a copy of ParseBatchImageFolderState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? parseBatchFolderList = null,Object? completeCount = null,Object? totalCount = null,Object? currentFileName = null,Object? currentFileProgress = null,Object? currentFileTotal = null,Object? isParsing = null,}) {
  return _then(_ParseBatchImageFolderState(
parseBatchFolderList: null == parseBatchFolderList ? _self._parseBatchFolderList : parseBatchFolderList // ignore: cast_nullable_to_non_nullable
as List<ParseBatchArchiveVo>,completeCount: null == completeCount ? _self.completeCount : completeCount // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,currentFileName: null == currentFileName ? _self.currentFileName : currentFileName // ignore: cast_nullable_to_non_nullable
as String,currentFileProgress: null == currentFileProgress ? _self.currentFileProgress : currentFileProgress // ignore: cast_nullable_to_non_nullable
as int,currentFileTotal: null == currentFileTotal ? _self.currentFileTotal : currentFileTotal // ignore: cast_nullable_to_non_nullable
as int,isParsing: null == isParsing ? _self.isParsing : isParsing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$SaveBatchAsBookState {

 int get saveAsBookCount; int get totalCount; SaveStep get step; int get stepCurrent; int get stepTotal; int get bookIndex; AsyncValue<void> get submitState;
/// Create a copy of SaveBatchAsBookState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaveBatchAsBookStateCopyWith<SaveBatchAsBookState> get copyWith => _$SaveBatchAsBookStateCopyWithImpl<SaveBatchAsBookState>(this as SaveBatchAsBookState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaveBatchAsBookState&&(identical(other.saveAsBookCount, saveAsBookCount) || other.saveAsBookCount == saveAsBookCount)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.step, step) || other.step == step)&&(identical(other.stepCurrent, stepCurrent) || other.stepCurrent == stepCurrent)&&(identical(other.stepTotal, stepTotal) || other.stepTotal == stepTotal)&&(identical(other.bookIndex, bookIndex) || other.bookIndex == bookIndex)&&(identical(other.submitState, submitState) || other.submitState == submitState));
}


@override
int get hashCode => Object.hash(runtimeType,saveAsBookCount,totalCount,step,stepCurrent,stepTotal,bookIndex,submitState);

@override
String toString() {
  return 'SaveBatchAsBookState(saveAsBookCount: $saveAsBookCount, totalCount: $totalCount, step: $step, stepCurrent: $stepCurrent, stepTotal: $stepTotal, bookIndex: $bookIndex, submitState: $submitState)';
}


}

/// @nodoc
abstract mixin class $SaveBatchAsBookStateCopyWith<$Res>  {
  factory $SaveBatchAsBookStateCopyWith(SaveBatchAsBookState value, $Res Function(SaveBatchAsBookState) _then) = _$SaveBatchAsBookStateCopyWithImpl;
@useResult
$Res call({
 int saveAsBookCount, int totalCount, SaveStep step, int stepCurrent, int stepTotal, int bookIndex, AsyncValue<void> submitState
});




}
/// @nodoc
class _$SaveBatchAsBookStateCopyWithImpl<$Res>
    implements $SaveBatchAsBookStateCopyWith<$Res> {
  _$SaveBatchAsBookStateCopyWithImpl(this._self, this._then);

  final SaveBatchAsBookState _self;
  final $Res Function(SaveBatchAsBookState) _then;

/// Create a copy of SaveBatchAsBookState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? saveAsBookCount = null,Object? totalCount = null,Object? step = null,Object? stepCurrent = null,Object? stepTotal = null,Object? bookIndex = null,Object? submitState = null,}) {
  return _then(_self.copyWith(
saveAsBookCount: null == saveAsBookCount ? _self.saveAsBookCount : saveAsBookCount // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as SaveStep,stepCurrent: null == stepCurrent ? _self.stepCurrent : stepCurrent // ignore: cast_nullable_to_non_nullable
as int,stepTotal: null == stepTotal ? _self.stepTotal : stepTotal // ignore: cast_nullable_to_non_nullable
as int,bookIndex: null == bookIndex ? _self.bookIndex : bookIndex // ignore: cast_nullable_to_non_nullable
as int,submitState: null == submitState ? _self.submitState : submitState // ignore: cast_nullable_to_non_nullable
as AsyncValue<void>,
  ));
}

}


/// Adds pattern-matching-related methods to [SaveBatchAsBookState].
extension SaveBatchAsBookStatePatterns on SaveBatchAsBookState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SaveBatchAsBookState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SaveBatchAsBookState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SaveBatchAsBookState value)  $default,){
final _that = this;
switch (_that) {
case _SaveBatchAsBookState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SaveBatchAsBookState value)?  $default,){
final _that = this;
switch (_that) {
case _SaveBatchAsBookState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int saveAsBookCount,  int totalCount,  SaveStep step,  int stepCurrent,  int stepTotal,  int bookIndex,  AsyncValue<void> submitState)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaveBatchAsBookState() when $default != null:
return $default(_that.saveAsBookCount,_that.totalCount,_that.step,_that.stepCurrent,_that.stepTotal,_that.bookIndex,_that.submitState);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int saveAsBookCount,  int totalCount,  SaveStep step,  int stepCurrent,  int stepTotal,  int bookIndex,  AsyncValue<void> submitState)  $default,) {final _that = this;
switch (_that) {
case _SaveBatchAsBookState():
return $default(_that.saveAsBookCount,_that.totalCount,_that.step,_that.stepCurrent,_that.stepTotal,_that.bookIndex,_that.submitState);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int saveAsBookCount,  int totalCount,  SaveStep step,  int stepCurrent,  int stepTotal,  int bookIndex,  AsyncValue<void> submitState)?  $default,) {final _that = this;
switch (_that) {
case _SaveBatchAsBookState() when $default != null:
return $default(_that.saveAsBookCount,_that.totalCount,_that.step,_that.stepCurrent,_that.stepTotal,_that.bookIndex,_that.submitState);case _:
  return null;

}
}

}

/// @nodoc


class _SaveBatchAsBookState extends SaveBatchAsBookState {
  const _SaveBatchAsBookState({this.saveAsBookCount = 0, this.totalCount = 0, this.step = SaveStep.generateCover, this.stepCurrent = 0, this.stepTotal = 0, this.bookIndex = 0, this.submitState = const AsyncData<void>(null)}): super._();
  

@override@JsonKey() final  int saveAsBookCount;
@override@JsonKey() final  int totalCount;
@override@JsonKey() final  SaveStep step;
@override@JsonKey() final  int stepCurrent;
@override@JsonKey() final  int stepTotal;
@override@JsonKey() final  int bookIndex;
@override@JsonKey() final  AsyncValue<void> submitState;

/// Create a copy of SaveBatchAsBookState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaveBatchAsBookStateCopyWith<_SaveBatchAsBookState> get copyWith => __$SaveBatchAsBookStateCopyWithImpl<_SaveBatchAsBookState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaveBatchAsBookState&&(identical(other.saveAsBookCount, saveAsBookCount) || other.saveAsBookCount == saveAsBookCount)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.step, step) || other.step == step)&&(identical(other.stepCurrent, stepCurrent) || other.stepCurrent == stepCurrent)&&(identical(other.stepTotal, stepTotal) || other.stepTotal == stepTotal)&&(identical(other.bookIndex, bookIndex) || other.bookIndex == bookIndex)&&(identical(other.submitState, submitState) || other.submitState == submitState));
}


@override
int get hashCode => Object.hash(runtimeType,saveAsBookCount,totalCount,step,stepCurrent,stepTotal,bookIndex,submitState);

@override
String toString() {
  return 'SaveBatchAsBookState(saveAsBookCount: $saveAsBookCount, totalCount: $totalCount, step: $step, stepCurrent: $stepCurrent, stepTotal: $stepTotal, bookIndex: $bookIndex, submitState: $submitState)';
}


}

/// @nodoc
abstract mixin class _$SaveBatchAsBookStateCopyWith<$Res> implements $SaveBatchAsBookStateCopyWith<$Res> {
  factory _$SaveBatchAsBookStateCopyWith(_SaveBatchAsBookState value, $Res Function(_SaveBatchAsBookState) _then) = __$SaveBatchAsBookStateCopyWithImpl;
@override @useResult
$Res call({
 int saveAsBookCount, int totalCount, SaveStep step, int stepCurrent, int stepTotal, int bookIndex, AsyncValue<void> submitState
});




}
/// @nodoc
class __$SaveBatchAsBookStateCopyWithImpl<$Res>
    implements _$SaveBatchAsBookStateCopyWith<$Res> {
  __$SaveBatchAsBookStateCopyWithImpl(this._self, this._then);

  final _SaveBatchAsBookState _self;
  final $Res Function(_SaveBatchAsBookState) _then;

/// Create a copy of SaveBatchAsBookState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? saveAsBookCount = null,Object? totalCount = null,Object? step = null,Object? stepCurrent = null,Object? stepTotal = null,Object? bookIndex = null,Object? submitState = null,}) {
  return _then(_SaveBatchAsBookState(
saveAsBookCount: null == saveAsBookCount ? _self.saveAsBookCount : saveAsBookCount // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as SaveStep,stepCurrent: null == stepCurrent ? _self.stepCurrent : stepCurrent // ignore: cast_nullable_to_non_nullable
as int,stepTotal: null == stepTotal ? _self.stepTotal : stepTotal // ignore: cast_nullable_to_non_nullable
as int,bookIndex: null == bookIndex ? _self.bookIndex : bookIndex // ignore: cast_nullable_to_non_nullable
as int,submitState: null == submitState ? _self.submitState : submitState // ignore: cast_nullable_to_non_nullable
as AsyncValue<void>,
  ));
}


}

/// @nodoc
mixin _$ParseBatchImageFolderParam {

 String? get parentDirPath; List<String>? get imagePaths;
/// Create a copy of ParseBatchImageFolderParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParseBatchImageFolderParamCopyWith<ParseBatchImageFolderParam> get copyWith => _$ParseBatchImageFolderParamCopyWithImpl<ParseBatchImageFolderParam>(this as ParseBatchImageFolderParam, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParseBatchImageFolderParam&&(identical(other.parentDirPath, parentDirPath) || other.parentDirPath == parentDirPath)&&const DeepCollectionEquality().equals(other.imagePaths, imagePaths));
}


@override
int get hashCode => Object.hash(runtimeType,parentDirPath,const DeepCollectionEquality().hash(imagePaths));

@override
String toString() {
  return 'ParseBatchImageFolderParam(parentDirPath: $parentDirPath, imagePaths: $imagePaths)';
}


}

/// @nodoc
abstract mixin class $ParseBatchImageFolderParamCopyWith<$Res>  {
  factory $ParseBatchImageFolderParamCopyWith(ParseBatchImageFolderParam value, $Res Function(ParseBatchImageFolderParam) _then) = _$ParseBatchImageFolderParamCopyWithImpl;
@useResult
$Res call({
 String? parentDirPath, List<String>? imagePaths
});




}
/// @nodoc
class _$ParseBatchImageFolderParamCopyWithImpl<$Res>
    implements $ParseBatchImageFolderParamCopyWith<$Res> {
  _$ParseBatchImageFolderParamCopyWithImpl(this._self, this._then);

  final ParseBatchImageFolderParam _self;
  final $Res Function(ParseBatchImageFolderParam) _then;

/// Create a copy of ParseBatchImageFolderParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? parentDirPath = freezed,Object? imagePaths = freezed,}) {
  return _then(_self.copyWith(
parentDirPath: freezed == parentDirPath ? _self.parentDirPath : parentDirPath // ignore: cast_nullable_to_non_nullable
as String?,imagePaths: freezed == imagePaths ? _self.imagePaths : imagePaths // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ParseBatchImageFolderParam].
extension ParseBatchImageFolderParamPatterns on ParseBatchImageFolderParam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParseBatchImageFolderParam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParseBatchImageFolderParam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParseBatchImageFolderParam value)  $default,){
final _that = this;
switch (_that) {
case _ParseBatchImageFolderParam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParseBatchImageFolderParam value)?  $default,){
final _that = this;
switch (_that) {
case _ParseBatchImageFolderParam() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? parentDirPath,  List<String>? imagePaths)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParseBatchImageFolderParam() when $default != null:
return $default(_that.parentDirPath,_that.imagePaths);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? parentDirPath,  List<String>? imagePaths)  $default,) {final _that = this;
switch (_that) {
case _ParseBatchImageFolderParam():
return $default(_that.parentDirPath,_that.imagePaths);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? parentDirPath,  List<String>? imagePaths)?  $default,) {final _that = this;
switch (_that) {
case _ParseBatchImageFolderParam() when $default != null:
return $default(_that.parentDirPath,_that.imagePaths);case _:
  return null;

}
}

}

/// @nodoc


class _ParseBatchImageFolderParam implements ParseBatchImageFolderParam {
  const _ParseBatchImageFolderParam({this.parentDirPath, final  List<String>? imagePaths}): _imagePaths = imagePaths;
  

@override final  String? parentDirPath;
 final  List<String>? _imagePaths;
@override List<String>? get imagePaths {
  final value = _imagePaths;
  if (value == null) return null;
  if (_imagePaths is EqualUnmodifiableListView) return _imagePaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of ParseBatchImageFolderParam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParseBatchImageFolderParamCopyWith<_ParseBatchImageFolderParam> get copyWith => __$ParseBatchImageFolderParamCopyWithImpl<_ParseBatchImageFolderParam>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParseBatchImageFolderParam&&(identical(other.parentDirPath, parentDirPath) || other.parentDirPath == parentDirPath)&&const DeepCollectionEquality().equals(other._imagePaths, _imagePaths));
}


@override
int get hashCode => Object.hash(runtimeType,parentDirPath,const DeepCollectionEquality().hash(_imagePaths));

@override
String toString() {
  return 'ParseBatchImageFolderParam(parentDirPath: $parentDirPath, imagePaths: $imagePaths)';
}


}

/// @nodoc
abstract mixin class _$ParseBatchImageFolderParamCopyWith<$Res> implements $ParseBatchImageFolderParamCopyWith<$Res> {
  factory _$ParseBatchImageFolderParamCopyWith(_ParseBatchImageFolderParam value, $Res Function(_ParseBatchImageFolderParam) _then) = __$ParseBatchImageFolderParamCopyWithImpl;
@override @useResult
$Res call({
 String? parentDirPath, List<String>? imagePaths
});




}
/// @nodoc
class __$ParseBatchImageFolderParamCopyWithImpl<$Res>
    implements _$ParseBatchImageFolderParamCopyWith<$Res> {
  __$ParseBatchImageFolderParamCopyWithImpl(this._self, this._then);

  final _ParseBatchImageFolderParam _self;
  final $Res Function(_ParseBatchImageFolderParam) _then;

/// Create a copy of ParseBatchImageFolderParam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? parentDirPath = freezed,Object? imagePaths = freezed,}) {
  return _then(_ParseBatchImageFolderParam(
parentDirPath: freezed == parentDirPath ? _self.parentDirPath : parentDirPath // ignore: cast_nullable_to_non_nullable
as String?,imagePaths: freezed == imagePaths ? _self._imagePaths : imagePaths // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

// dart format on
