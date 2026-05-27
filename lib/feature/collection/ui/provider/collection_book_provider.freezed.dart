// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collection_book_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CollectionBookState {

 List<BookListItemVo> get books;
/// Create a copy of CollectionBookState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CollectionBookStateCopyWith<CollectionBookState> get copyWith => _$CollectionBookStateCopyWithImpl<CollectionBookState>(this as CollectionBookState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CollectionBookState&&const DeepCollectionEquality().equals(other.books, books));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(books));

@override
String toString() {
  return 'CollectionBookState(books: $books)';
}


}

/// @nodoc
abstract mixin class $CollectionBookStateCopyWith<$Res>  {
  factory $CollectionBookStateCopyWith(CollectionBookState value, $Res Function(CollectionBookState) _then) = _$CollectionBookStateCopyWithImpl;
@useResult
$Res call({
 List<BookListItemVo> books
});




}
/// @nodoc
class _$CollectionBookStateCopyWithImpl<$Res>
    implements $CollectionBookStateCopyWith<$Res> {
  _$CollectionBookStateCopyWithImpl(this._self, this._then);

  final CollectionBookState _self;
  final $Res Function(CollectionBookState) _then;

/// Create a copy of CollectionBookState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? books = null,}) {
  return _then(_self.copyWith(
books: null == books ? _self.books : books // ignore: cast_nullable_to_non_nullable
as List<BookListItemVo>,
  ));
}

}


/// Adds pattern-matching-related methods to [CollectionBookState].
extension CollectionBookStatePatterns on CollectionBookState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CollectionBookState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CollectionBookState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CollectionBookState value)  $default,){
final _that = this;
switch (_that) {
case _CollectionBookState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CollectionBookState value)?  $default,){
final _that = this;
switch (_that) {
case _CollectionBookState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<BookListItemVo> books)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CollectionBookState() when $default != null:
return $default(_that.books);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<BookListItemVo> books)  $default,) {final _that = this;
switch (_that) {
case _CollectionBookState():
return $default(_that.books);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<BookListItemVo> books)?  $default,) {final _that = this;
switch (_that) {
case _CollectionBookState() when $default != null:
return $default(_that.books);case _:
  return null;

}
}

}

/// @nodoc


class _CollectionBookState implements CollectionBookState {
  const _CollectionBookState({final  List<BookListItemVo> books = const []}): _books = books;
  

 final  List<BookListItemVo> _books;
@override@JsonKey() List<BookListItemVo> get books {
  if (_books is EqualUnmodifiableListView) return _books;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_books);
}


/// Create a copy of CollectionBookState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CollectionBookStateCopyWith<_CollectionBookState> get copyWith => __$CollectionBookStateCopyWithImpl<_CollectionBookState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CollectionBookState&&const DeepCollectionEquality().equals(other._books, _books));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_books));

@override
String toString() {
  return 'CollectionBookState(books: $books)';
}


}

/// @nodoc
abstract mixin class _$CollectionBookStateCopyWith<$Res> implements $CollectionBookStateCopyWith<$Res> {
  factory _$CollectionBookStateCopyWith(_CollectionBookState value, $Res Function(_CollectionBookState) _then) = __$CollectionBookStateCopyWithImpl;
@override @useResult
$Res call({
 List<BookListItemVo> books
});




}
/// @nodoc
class __$CollectionBookStateCopyWithImpl<$Res>
    implements _$CollectionBookStateCopyWith<$Res> {
  __$CollectionBookStateCopyWithImpl(this._self, this._then);

  final _CollectionBookState _self;
  final $Res Function(_CollectionBookState) _then;

/// Create a copy of CollectionBookState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? books = null,}) {
  return _then(_CollectionBookState(
books: null == books ? _self._books : books // ignore: cast_nullable_to_non_nullable
as List<BookListItemVo>,
  ));
}


}

// dart format on
