// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'export_single_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExportSingleState {

 BookTableData get book; ExportFormat get format; TextEditingController get fileNameCrl; bool get isExporting; bool get isDone; TextEditingController get outputPathCrl; String? get errorMsg;
/// Create a copy of ExportSingleState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExportSingleStateCopyWith<ExportSingleState> get copyWith => _$ExportSingleStateCopyWithImpl<ExportSingleState>(this as ExportSingleState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportSingleState&&const DeepCollectionEquality().equals(other.book, book)&&(identical(other.format, format) || other.format == format)&&(identical(other.fileNameCrl, fileNameCrl) || other.fileNameCrl == fileNameCrl)&&(identical(other.isExporting, isExporting) || other.isExporting == isExporting)&&(identical(other.isDone, isDone) || other.isDone == isDone)&&(identical(other.outputPathCrl, outputPathCrl) || other.outputPathCrl == outputPathCrl)&&(identical(other.errorMsg, errorMsg) || other.errorMsg == errorMsg));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(book),format,fileNameCrl,isExporting,isDone,outputPathCrl,errorMsg);

@override
String toString() {
  return 'ExportSingleState(book: $book, format: $format, fileNameCrl: $fileNameCrl, isExporting: $isExporting, isDone: $isDone, outputPathCrl: $outputPathCrl, errorMsg: $errorMsg)';
}


}

/// @nodoc
abstract mixin class $ExportSingleStateCopyWith<$Res>  {
  factory $ExportSingleStateCopyWith(ExportSingleState value, $Res Function(ExportSingleState) _then) = _$ExportSingleStateCopyWithImpl;
@useResult
$Res call({
 BookTableData book, ExportFormat format, TextEditingController fileNameCrl, bool isExporting, bool isDone, TextEditingController outputPathCrl, String? errorMsg
});




}
/// @nodoc
class _$ExportSingleStateCopyWithImpl<$Res>
    implements $ExportSingleStateCopyWith<$Res> {
  _$ExportSingleStateCopyWithImpl(this._self, this._then);

  final ExportSingleState _self;
  final $Res Function(ExportSingleState) _then;

/// Create a copy of ExportSingleState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? book = freezed,Object? format = null,Object? fileNameCrl = null,Object? isExporting = null,Object? isDone = null,Object? outputPathCrl = null,Object? errorMsg = freezed,}) {
  return _then(_self.copyWith(
book: freezed == book ? _self.book : book // ignore: cast_nullable_to_non_nullable
as BookTableData,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as ExportFormat,fileNameCrl: null == fileNameCrl ? _self.fileNameCrl : fileNameCrl // ignore: cast_nullable_to_non_nullable
as TextEditingController,isExporting: null == isExporting ? _self.isExporting : isExporting // ignore: cast_nullable_to_non_nullable
as bool,isDone: null == isDone ? _self.isDone : isDone // ignore: cast_nullable_to_non_nullable
as bool,outputPathCrl: null == outputPathCrl ? _self.outputPathCrl : outputPathCrl // ignore: cast_nullable_to_non_nullable
as TextEditingController,errorMsg: freezed == errorMsg ? _self.errorMsg : errorMsg // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExportSingleState].
extension ExportSingleStatePatterns on ExportSingleState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExportSingleState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExportSingleState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExportSingleState value)  $default,){
final _that = this;
switch (_that) {
case _ExportSingleState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExportSingleState value)?  $default,){
final _that = this;
switch (_that) {
case _ExportSingleState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BookTableData book,  ExportFormat format,  TextEditingController fileNameCrl,  bool isExporting,  bool isDone,  TextEditingController outputPathCrl,  String? errorMsg)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExportSingleState() when $default != null:
return $default(_that.book,_that.format,_that.fileNameCrl,_that.isExporting,_that.isDone,_that.outputPathCrl,_that.errorMsg);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BookTableData book,  ExportFormat format,  TextEditingController fileNameCrl,  bool isExporting,  bool isDone,  TextEditingController outputPathCrl,  String? errorMsg)  $default,) {final _that = this;
switch (_that) {
case _ExportSingleState():
return $default(_that.book,_that.format,_that.fileNameCrl,_that.isExporting,_that.isDone,_that.outputPathCrl,_that.errorMsg);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BookTableData book,  ExportFormat format,  TextEditingController fileNameCrl,  bool isExporting,  bool isDone,  TextEditingController outputPathCrl,  String? errorMsg)?  $default,) {final _that = this;
switch (_that) {
case _ExportSingleState() when $default != null:
return $default(_that.book,_that.format,_that.fileNameCrl,_that.isExporting,_that.isDone,_that.outputPathCrl,_that.errorMsg);case _:
  return null;

}
}

}

/// @nodoc


class _ExportSingleState implements ExportSingleState {
  const _ExportSingleState({required this.book, required this.format, required this.fileNameCrl, required this.isExporting, required this.isDone, required this.outputPathCrl, this.errorMsg});
  

@override final  BookTableData book;
@override final  ExportFormat format;
@override final  TextEditingController fileNameCrl;
@override final  bool isExporting;
@override final  bool isDone;
@override final  TextEditingController outputPathCrl;
@override final  String? errorMsg;

/// Create a copy of ExportSingleState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExportSingleStateCopyWith<_ExportSingleState> get copyWith => __$ExportSingleStateCopyWithImpl<_ExportSingleState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExportSingleState&&const DeepCollectionEquality().equals(other.book, book)&&(identical(other.format, format) || other.format == format)&&(identical(other.fileNameCrl, fileNameCrl) || other.fileNameCrl == fileNameCrl)&&(identical(other.isExporting, isExporting) || other.isExporting == isExporting)&&(identical(other.isDone, isDone) || other.isDone == isDone)&&(identical(other.outputPathCrl, outputPathCrl) || other.outputPathCrl == outputPathCrl)&&(identical(other.errorMsg, errorMsg) || other.errorMsg == errorMsg));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(book),format,fileNameCrl,isExporting,isDone,outputPathCrl,errorMsg);

@override
String toString() {
  return 'ExportSingleState(book: $book, format: $format, fileNameCrl: $fileNameCrl, isExporting: $isExporting, isDone: $isDone, outputPathCrl: $outputPathCrl, errorMsg: $errorMsg)';
}


}

/// @nodoc
abstract mixin class _$ExportSingleStateCopyWith<$Res> implements $ExportSingleStateCopyWith<$Res> {
  factory _$ExportSingleStateCopyWith(_ExportSingleState value, $Res Function(_ExportSingleState) _then) = __$ExportSingleStateCopyWithImpl;
@override @useResult
$Res call({
 BookTableData book, ExportFormat format, TextEditingController fileNameCrl, bool isExporting, bool isDone, TextEditingController outputPathCrl, String? errorMsg
});




}
/// @nodoc
class __$ExportSingleStateCopyWithImpl<$Res>
    implements _$ExportSingleStateCopyWith<$Res> {
  __$ExportSingleStateCopyWithImpl(this._self, this._then);

  final _ExportSingleState _self;
  final $Res Function(_ExportSingleState) _then;

/// Create a copy of ExportSingleState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? book = freezed,Object? format = null,Object? fileNameCrl = null,Object? isExporting = null,Object? isDone = null,Object? outputPathCrl = null,Object? errorMsg = freezed,}) {
  return _then(_ExportSingleState(
book: freezed == book ? _self.book : book // ignore: cast_nullable_to_non_nullable
as BookTableData,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as ExportFormat,fileNameCrl: null == fileNameCrl ? _self.fileNameCrl : fileNameCrl // ignore: cast_nullable_to_non_nullable
as TextEditingController,isExporting: null == isExporting ? _self.isExporting : isExporting // ignore: cast_nullable_to_non_nullable
as bool,isDone: null == isDone ? _self.isDone : isDone // ignore: cast_nullable_to_non_nullable
as bool,outputPathCrl: null == outputPathCrl ? _self.outputPathCrl : outputPathCrl // ignore: cast_nullable_to_non_nullable
as TextEditingController,errorMsg: freezed == errorMsg ? _self.errorMsg : errorMsg // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
