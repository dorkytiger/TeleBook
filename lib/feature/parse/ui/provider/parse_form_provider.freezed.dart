// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parse_form_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ParseFormState {

 ParseFormType get type; String get url; String get archivePath; String get batchArchivePath; List<String> get batchArchivePaths; String get imageFolderPath; List<String> get imagePaths; String get batchImageFolderPath; List<String> get batchImagePaths; String get pdfPath; String get batchPdfPath; List<String> get batchPdfPaths;
/// Create a copy of ParseFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParseFormStateCopyWith<ParseFormState> get copyWith => _$ParseFormStateCopyWithImpl<ParseFormState>(this as ParseFormState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParseFormState&&(identical(other.type, type) || other.type == type)&&(identical(other.url, url) || other.url == url)&&(identical(other.archivePath, archivePath) || other.archivePath == archivePath)&&(identical(other.batchArchivePath, batchArchivePath) || other.batchArchivePath == batchArchivePath)&&const DeepCollectionEquality().equals(other.batchArchivePaths, batchArchivePaths)&&(identical(other.imageFolderPath, imageFolderPath) || other.imageFolderPath == imageFolderPath)&&const DeepCollectionEquality().equals(other.imagePaths, imagePaths)&&(identical(other.batchImageFolderPath, batchImageFolderPath) || other.batchImageFolderPath == batchImageFolderPath)&&const DeepCollectionEquality().equals(other.batchImagePaths, batchImagePaths)&&(identical(other.pdfPath, pdfPath) || other.pdfPath == pdfPath)&&(identical(other.batchPdfPath, batchPdfPath) || other.batchPdfPath == batchPdfPath)&&const DeepCollectionEquality().equals(other.batchPdfPaths, batchPdfPaths));
}


@override
int get hashCode => Object.hash(runtimeType,type,url,archivePath,batchArchivePath,const DeepCollectionEquality().hash(batchArchivePaths),imageFolderPath,const DeepCollectionEquality().hash(imagePaths),batchImageFolderPath,const DeepCollectionEquality().hash(batchImagePaths),pdfPath,batchPdfPath,const DeepCollectionEquality().hash(batchPdfPaths));

@override
String toString() {
  return 'ParseFormState(type: $type, url: $url, archivePath: $archivePath, batchArchivePath: $batchArchivePath, batchArchivePaths: $batchArchivePaths, imageFolderPath: $imageFolderPath, imagePaths: $imagePaths, batchImageFolderPath: $batchImageFolderPath, batchImagePaths: $batchImagePaths, pdfPath: $pdfPath, batchPdfPath: $batchPdfPath, batchPdfPaths: $batchPdfPaths)';
}


}

/// @nodoc
abstract mixin class $ParseFormStateCopyWith<$Res>  {
  factory $ParseFormStateCopyWith(ParseFormState value, $Res Function(ParseFormState) _then) = _$ParseFormStateCopyWithImpl;
@useResult
$Res call({
 ParseFormType type, String url, String archivePath, String batchArchivePath, List<String> batchArchivePaths, String imageFolderPath, List<String> imagePaths, String batchImageFolderPath, List<String> batchImagePaths, String pdfPath, String batchPdfPath, List<String> batchPdfPaths
});




}
/// @nodoc
class _$ParseFormStateCopyWithImpl<$Res>
    implements $ParseFormStateCopyWith<$Res> {
  _$ParseFormStateCopyWithImpl(this._self, this._then);

  final ParseFormState _self;
  final $Res Function(ParseFormState) _then;

/// Create a copy of ParseFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? url = null,Object? archivePath = null,Object? batchArchivePath = null,Object? batchArchivePaths = null,Object? imageFolderPath = null,Object? imagePaths = null,Object? batchImageFolderPath = null,Object? batchImagePaths = null,Object? pdfPath = null,Object? batchPdfPath = null,Object? batchPdfPaths = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ParseFormType,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,archivePath: null == archivePath ? _self.archivePath : archivePath // ignore: cast_nullable_to_non_nullable
as String,batchArchivePath: null == batchArchivePath ? _self.batchArchivePath : batchArchivePath // ignore: cast_nullable_to_non_nullable
as String,batchArchivePaths: null == batchArchivePaths ? _self.batchArchivePaths : batchArchivePaths // ignore: cast_nullable_to_non_nullable
as List<String>,imageFolderPath: null == imageFolderPath ? _self.imageFolderPath : imageFolderPath // ignore: cast_nullable_to_non_nullable
as String,imagePaths: null == imagePaths ? _self.imagePaths : imagePaths // ignore: cast_nullable_to_non_nullable
as List<String>,batchImageFolderPath: null == batchImageFolderPath ? _self.batchImageFolderPath : batchImageFolderPath // ignore: cast_nullable_to_non_nullable
as String,batchImagePaths: null == batchImagePaths ? _self.batchImagePaths : batchImagePaths // ignore: cast_nullable_to_non_nullable
as List<String>,pdfPath: null == pdfPath ? _self.pdfPath : pdfPath // ignore: cast_nullable_to_non_nullable
as String,batchPdfPath: null == batchPdfPath ? _self.batchPdfPath : batchPdfPath // ignore: cast_nullable_to_non_nullable
as String,batchPdfPaths: null == batchPdfPaths ? _self.batchPdfPaths : batchPdfPaths // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ParseFormState].
extension ParseFormStatePatterns on ParseFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParseFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParseFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParseFormState value)  $default,){
final _that = this;
switch (_that) {
case _ParseFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParseFormState value)?  $default,){
final _that = this;
switch (_that) {
case _ParseFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ParseFormType type,  String url,  String archivePath,  String batchArchivePath,  List<String> batchArchivePaths,  String imageFolderPath,  List<String> imagePaths,  String batchImageFolderPath,  List<String> batchImagePaths,  String pdfPath,  String batchPdfPath,  List<String> batchPdfPaths)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParseFormState() when $default != null:
return $default(_that.type,_that.url,_that.archivePath,_that.batchArchivePath,_that.batchArchivePaths,_that.imageFolderPath,_that.imagePaths,_that.batchImageFolderPath,_that.batchImagePaths,_that.pdfPath,_that.batchPdfPath,_that.batchPdfPaths);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ParseFormType type,  String url,  String archivePath,  String batchArchivePath,  List<String> batchArchivePaths,  String imageFolderPath,  List<String> imagePaths,  String batchImageFolderPath,  List<String> batchImagePaths,  String pdfPath,  String batchPdfPath,  List<String> batchPdfPaths)  $default,) {final _that = this;
switch (_that) {
case _ParseFormState():
return $default(_that.type,_that.url,_that.archivePath,_that.batchArchivePath,_that.batchArchivePaths,_that.imageFolderPath,_that.imagePaths,_that.batchImageFolderPath,_that.batchImagePaths,_that.pdfPath,_that.batchPdfPath,_that.batchPdfPaths);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ParseFormType type,  String url,  String archivePath,  String batchArchivePath,  List<String> batchArchivePaths,  String imageFolderPath,  List<String> imagePaths,  String batchImageFolderPath,  List<String> batchImagePaths,  String pdfPath,  String batchPdfPath,  List<String> batchPdfPaths)?  $default,) {final _that = this;
switch (_that) {
case _ParseFormState() when $default != null:
return $default(_that.type,_that.url,_that.archivePath,_that.batchArchivePath,_that.batchArchivePaths,_that.imageFolderPath,_that.imagePaths,_that.batchImageFolderPath,_that.batchImagePaths,_that.pdfPath,_that.batchPdfPath,_that.batchPdfPaths);case _:
  return null;

}
}

}

/// @nodoc


class _ParseFormState implements ParseFormState {
  const _ParseFormState({this.type = ParseFormType.web, this.url = '', this.archivePath = '', this.batchArchivePath = '', final  List<String> batchArchivePaths = const <String>[], this.imageFolderPath = '', final  List<String> imagePaths = const <String>[], this.batchImageFolderPath = '', final  List<String> batchImagePaths = const <String>[], this.pdfPath = '', this.batchPdfPath = '', final  List<String> batchPdfPaths = const <String>[]}): _batchArchivePaths = batchArchivePaths,_imagePaths = imagePaths,_batchImagePaths = batchImagePaths,_batchPdfPaths = batchPdfPaths;
  

@override@JsonKey() final  ParseFormType type;
@override@JsonKey() final  String url;
@override@JsonKey() final  String archivePath;
@override@JsonKey() final  String batchArchivePath;
 final  List<String> _batchArchivePaths;
@override@JsonKey() List<String> get batchArchivePaths {
  if (_batchArchivePaths is EqualUnmodifiableListView) return _batchArchivePaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_batchArchivePaths);
}

@override@JsonKey() final  String imageFolderPath;
 final  List<String> _imagePaths;
@override@JsonKey() List<String> get imagePaths {
  if (_imagePaths is EqualUnmodifiableListView) return _imagePaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imagePaths);
}

@override@JsonKey() final  String batchImageFolderPath;
 final  List<String> _batchImagePaths;
@override@JsonKey() List<String> get batchImagePaths {
  if (_batchImagePaths is EqualUnmodifiableListView) return _batchImagePaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_batchImagePaths);
}

@override@JsonKey() final  String pdfPath;
@override@JsonKey() final  String batchPdfPath;
 final  List<String> _batchPdfPaths;
@override@JsonKey() List<String> get batchPdfPaths {
  if (_batchPdfPaths is EqualUnmodifiableListView) return _batchPdfPaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_batchPdfPaths);
}


/// Create a copy of ParseFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParseFormStateCopyWith<_ParseFormState> get copyWith => __$ParseFormStateCopyWithImpl<_ParseFormState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParseFormState&&(identical(other.type, type) || other.type == type)&&(identical(other.url, url) || other.url == url)&&(identical(other.archivePath, archivePath) || other.archivePath == archivePath)&&(identical(other.batchArchivePath, batchArchivePath) || other.batchArchivePath == batchArchivePath)&&const DeepCollectionEquality().equals(other._batchArchivePaths, _batchArchivePaths)&&(identical(other.imageFolderPath, imageFolderPath) || other.imageFolderPath == imageFolderPath)&&const DeepCollectionEquality().equals(other._imagePaths, _imagePaths)&&(identical(other.batchImageFolderPath, batchImageFolderPath) || other.batchImageFolderPath == batchImageFolderPath)&&const DeepCollectionEquality().equals(other._batchImagePaths, _batchImagePaths)&&(identical(other.pdfPath, pdfPath) || other.pdfPath == pdfPath)&&(identical(other.batchPdfPath, batchPdfPath) || other.batchPdfPath == batchPdfPath)&&const DeepCollectionEquality().equals(other._batchPdfPaths, _batchPdfPaths));
}


@override
int get hashCode => Object.hash(runtimeType,type,url,archivePath,batchArchivePath,const DeepCollectionEquality().hash(_batchArchivePaths),imageFolderPath,const DeepCollectionEquality().hash(_imagePaths),batchImageFolderPath,const DeepCollectionEquality().hash(_batchImagePaths),pdfPath,batchPdfPath,const DeepCollectionEquality().hash(_batchPdfPaths));

@override
String toString() {
  return 'ParseFormState(type: $type, url: $url, archivePath: $archivePath, batchArchivePath: $batchArchivePath, batchArchivePaths: $batchArchivePaths, imageFolderPath: $imageFolderPath, imagePaths: $imagePaths, batchImageFolderPath: $batchImageFolderPath, batchImagePaths: $batchImagePaths, pdfPath: $pdfPath, batchPdfPath: $batchPdfPath, batchPdfPaths: $batchPdfPaths)';
}


}

/// @nodoc
abstract mixin class _$ParseFormStateCopyWith<$Res> implements $ParseFormStateCopyWith<$Res> {
  factory _$ParseFormStateCopyWith(_ParseFormState value, $Res Function(_ParseFormState) _then) = __$ParseFormStateCopyWithImpl;
@override @useResult
$Res call({
 ParseFormType type, String url, String archivePath, String batchArchivePath, List<String> batchArchivePaths, String imageFolderPath, List<String> imagePaths, String batchImageFolderPath, List<String> batchImagePaths, String pdfPath, String batchPdfPath, List<String> batchPdfPaths
});




}
/// @nodoc
class __$ParseFormStateCopyWithImpl<$Res>
    implements _$ParseFormStateCopyWith<$Res> {
  __$ParseFormStateCopyWithImpl(this._self, this._then);

  final _ParseFormState _self;
  final $Res Function(_ParseFormState) _then;

/// Create a copy of ParseFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? url = null,Object? archivePath = null,Object? batchArchivePath = null,Object? batchArchivePaths = null,Object? imageFolderPath = null,Object? imagePaths = null,Object? batchImageFolderPath = null,Object? batchImagePaths = null,Object? pdfPath = null,Object? batchPdfPath = null,Object? batchPdfPaths = null,}) {
  return _then(_ParseFormState(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ParseFormType,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,archivePath: null == archivePath ? _self.archivePath : archivePath // ignore: cast_nullable_to_non_nullable
as String,batchArchivePath: null == batchArchivePath ? _self.batchArchivePath : batchArchivePath // ignore: cast_nullable_to_non_nullable
as String,batchArchivePaths: null == batchArchivePaths ? _self._batchArchivePaths : batchArchivePaths // ignore: cast_nullable_to_non_nullable
as List<String>,imageFolderPath: null == imageFolderPath ? _self.imageFolderPath : imageFolderPath // ignore: cast_nullable_to_non_nullable
as String,imagePaths: null == imagePaths ? _self._imagePaths : imagePaths // ignore: cast_nullable_to_non_nullable
as List<String>,batchImageFolderPath: null == batchImageFolderPath ? _self.batchImageFolderPath : batchImageFolderPath // ignore: cast_nullable_to_non_nullable
as String,batchImagePaths: null == batchImagePaths ? _self._batchImagePaths : batchImagePaths // ignore: cast_nullable_to_non_nullable
as List<String>,pdfPath: null == pdfPath ? _self.pdfPath : pdfPath // ignore: cast_nullable_to_non_nullable
as String,batchPdfPath: null == batchPdfPath ? _self.batchPdfPath : batchPdfPath // ignore: cast_nullable_to_non_nullable
as String,batchPdfPaths: null == batchPdfPaths ? _self._batchPdfPaths : batchPdfPaths // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
