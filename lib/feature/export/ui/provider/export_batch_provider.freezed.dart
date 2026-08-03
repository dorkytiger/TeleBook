// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'export_batch_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExportBatchState {

 ExportFormat get format; bool get isExporting; bool get isDone; int get progress; List<ExportItem> get items; TextEditingController get outputPathController; String? get errorMessage;
/// Create a copy of ExportBatchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExportBatchStateCopyWith<ExportBatchState> get copyWith => _$ExportBatchStateCopyWithImpl<ExportBatchState>(this as ExportBatchState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportBatchState&&(identical(other.format, format) || other.format == format)&&(identical(other.isExporting, isExporting) || other.isExporting == isExporting)&&(identical(other.isDone, isDone) || other.isDone == isDone)&&(identical(other.progress, progress) || other.progress == progress)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.outputPathController, outputPathController) || other.outputPathController == outputPathController)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,format,isExporting,isDone,progress,const DeepCollectionEquality().hash(items),outputPathController,errorMessage);

@override
String toString() {
  return 'ExportBatchState(format: $format, isExporting: $isExporting, isDone: $isDone, progress: $progress, items: $items, outputPathController: $outputPathController, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $ExportBatchStateCopyWith<$Res>  {
  factory $ExportBatchStateCopyWith(ExportBatchState value, $Res Function(ExportBatchState) _then) = _$ExportBatchStateCopyWithImpl;
@useResult
$Res call({
 ExportFormat format, bool isExporting, bool isDone, int progress, List<ExportItem> items, TextEditingController outputPathController, String? errorMessage
});




}
/// @nodoc
class _$ExportBatchStateCopyWithImpl<$Res>
    implements $ExportBatchStateCopyWith<$Res> {
  _$ExportBatchStateCopyWithImpl(this._self, this._then);

  final ExportBatchState _self;
  final $Res Function(ExportBatchState) _then;

/// Create a copy of ExportBatchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? format = null,Object? isExporting = null,Object? isDone = null,Object? progress = null,Object? items = null,Object? outputPathController = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as ExportFormat,isExporting: null == isExporting ? _self.isExporting : isExporting // ignore: cast_nullable_to_non_nullable
as bool,isDone: null == isDone ? _self.isDone : isDone // ignore: cast_nullable_to_non_nullable
as bool,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ExportItem>,outputPathController: null == outputPathController ? _self.outputPathController : outputPathController // ignore: cast_nullable_to_non_nullable
as TextEditingController,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExportBatchState].
extension ExportBatchStatePatterns on ExportBatchState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExportBatchState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExportBatchState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExportBatchState value)  $default,){
final _that = this;
switch (_that) {
case _ExportBatchState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExportBatchState value)?  $default,){
final _that = this;
switch (_that) {
case _ExportBatchState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ExportFormat format,  bool isExporting,  bool isDone,  int progress,  List<ExportItem> items,  TextEditingController outputPathController,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExportBatchState() when $default != null:
return $default(_that.format,_that.isExporting,_that.isDone,_that.progress,_that.items,_that.outputPathController,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ExportFormat format,  bool isExporting,  bool isDone,  int progress,  List<ExportItem> items,  TextEditingController outputPathController,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _ExportBatchState():
return $default(_that.format,_that.isExporting,_that.isDone,_that.progress,_that.items,_that.outputPathController,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ExportFormat format,  bool isExporting,  bool isDone,  int progress,  List<ExportItem> items,  TextEditingController outputPathController,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _ExportBatchState() when $default != null:
return $default(_that.format,_that.isExporting,_that.isDone,_that.progress,_that.items,_that.outputPathController,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _ExportBatchState implements ExportBatchState {
  const _ExportBatchState({required this.format, required this.isExporting, required this.isDone, required this.progress, required final  List<ExportItem> items, required this.outputPathController, this.errorMessage}): _items = items;
  

@override final  ExportFormat format;
@override final  bool isExporting;
@override final  bool isDone;
@override final  int progress;
 final  List<ExportItem> _items;
@override List<ExportItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  TextEditingController outputPathController;
@override final  String? errorMessage;

/// Create a copy of ExportBatchState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExportBatchStateCopyWith<_ExportBatchState> get copyWith => __$ExportBatchStateCopyWithImpl<_ExportBatchState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExportBatchState&&(identical(other.format, format) || other.format == format)&&(identical(other.isExporting, isExporting) || other.isExporting == isExporting)&&(identical(other.isDone, isDone) || other.isDone == isDone)&&(identical(other.progress, progress) || other.progress == progress)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.outputPathController, outputPathController) || other.outputPathController == outputPathController)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,format,isExporting,isDone,progress,const DeepCollectionEquality().hash(_items),outputPathController,errorMessage);

@override
String toString() {
  return 'ExportBatchState(format: $format, isExporting: $isExporting, isDone: $isDone, progress: $progress, items: $items, outputPathController: $outputPathController, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$ExportBatchStateCopyWith<$Res> implements $ExportBatchStateCopyWith<$Res> {
  factory _$ExportBatchStateCopyWith(_ExportBatchState value, $Res Function(_ExportBatchState) _then) = __$ExportBatchStateCopyWithImpl;
@override @useResult
$Res call({
 ExportFormat format, bool isExporting, bool isDone, int progress, List<ExportItem> items, TextEditingController outputPathController, String? errorMessage
});




}
/// @nodoc
class __$ExportBatchStateCopyWithImpl<$Res>
    implements _$ExportBatchStateCopyWith<$Res> {
  __$ExportBatchStateCopyWithImpl(this._self, this._then);

  final _ExportBatchState _self;
  final $Res Function(_ExportBatchState) _then;

/// Create a copy of ExportBatchState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? format = null,Object? isExporting = null,Object? isDone = null,Object? progress = null,Object? items = null,Object? outputPathController = null,Object? errorMessage = freezed,}) {
  return _then(_ExportBatchState(
format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as ExportFormat,isExporting: null == isExporting ? _self.isExporting : isExporting // ignore: cast_nullable_to_non_nullable
as bool,isDone: null == isDone ? _self.isDone : isDone // ignore: cast_nullable_to_non_nullable
as bool,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ExportItem>,outputPathController: null == outputPathController ? _self.outputPathController : outputPathController // ignore: cast_nullable_to_non_nullable
as TextEditingController,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
