// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cursor_page_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CursorPageInfo {

 bool get hasNext; String? get nextCursor; int get pageSize;
/// Create a copy of CursorPageInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CursorPageInfoCopyWith<CursorPageInfo> get copyWith => _$CursorPageInfoCopyWithImpl<CursorPageInfo>(this as CursorPageInfo, _$identity);

  /// Serializes this CursorPageInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CursorPageInfo&&(identical(other.hasNext, hasNext) || other.hasNext == hasNext)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hasNext,nextCursor,pageSize);

@override
String toString() {
  return 'CursorPageInfo(hasNext: $hasNext, nextCursor: $nextCursor, pageSize: $pageSize)';
}


}

/// @nodoc
abstract mixin class $CursorPageInfoCopyWith<$Res>  {
  factory $CursorPageInfoCopyWith(CursorPageInfo value, $Res Function(CursorPageInfo) _then) = _$CursorPageInfoCopyWithImpl;
@useResult
$Res call({
 bool hasNext, String? nextCursor, int pageSize
});




}
/// @nodoc
class _$CursorPageInfoCopyWithImpl<$Res>
    implements $CursorPageInfoCopyWith<$Res> {
  _$CursorPageInfoCopyWithImpl(this._self, this._then);

  final CursorPageInfo _self;
  final $Res Function(CursorPageInfo) _then;

/// Create a copy of CursorPageInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hasNext = null,Object? nextCursor = freezed,Object? pageSize = null,}) {
  return _then(_self.copyWith(
hasNext: null == hasNext ? _self.hasNext : hasNext // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CursorPageInfo].
extension CursorPageInfoPatterns on CursorPageInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CursorPageInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CursorPageInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CursorPageInfo value)  $default,){
final _that = this;
switch (_that) {
case _CursorPageInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CursorPageInfo value)?  $default,){
final _that = this;
switch (_that) {
case _CursorPageInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool hasNext,  String? nextCursor,  int pageSize)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CursorPageInfo() when $default != null:
return $default(_that.hasNext,_that.nextCursor,_that.pageSize);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool hasNext,  String? nextCursor,  int pageSize)  $default,) {final _that = this;
switch (_that) {
case _CursorPageInfo():
return $default(_that.hasNext,_that.nextCursor,_that.pageSize);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool hasNext,  String? nextCursor,  int pageSize)?  $default,) {final _that = this;
switch (_that) {
case _CursorPageInfo() when $default != null:
return $default(_that.hasNext,_that.nextCursor,_that.pageSize);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CursorPageInfo implements CursorPageInfo {
  const _CursorPageInfo({required this.hasNext, required this.nextCursor, required this.pageSize});
  factory _CursorPageInfo.fromJson(Map<String, dynamic> json) => _$CursorPageInfoFromJson(json);

@override final  bool hasNext;
@override final  String? nextCursor;
@override final  int pageSize;

/// Create a copy of CursorPageInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CursorPageInfoCopyWith<_CursorPageInfo> get copyWith => __$CursorPageInfoCopyWithImpl<_CursorPageInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CursorPageInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CursorPageInfo&&(identical(other.hasNext, hasNext) || other.hasNext == hasNext)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hasNext,nextCursor,pageSize);

@override
String toString() {
  return 'CursorPageInfo(hasNext: $hasNext, nextCursor: $nextCursor, pageSize: $pageSize)';
}


}

/// @nodoc
abstract mixin class _$CursorPageInfoCopyWith<$Res> implements $CursorPageInfoCopyWith<$Res> {
  factory _$CursorPageInfoCopyWith(_CursorPageInfo value, $Res Function(_CursorPageInfo) _then) = __$CursorPageInfoCopyWithImpl;
@override @useResult
$Res call({
 bool hasNext, String? nextCursor, int pageSize
});




}
/// @nodoc
class __$CursorPageInfoCopyWithImpl<$Res>
    implements _$CursorPageInfoCopyWith<$Res> {
  __$CursorPageInfoCopyWithImpl(this._self, this._then);

  final _CursorPageInfo _self;
  final $Res Function(_CursorPageInfo) _then;

/// Create a copy of CursorPageInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hasNext = null,Object? nextCursor = freezed,Object? pageSize = null,}) {
  return _then(_CursorPageInfo(
hasNext: null == hasNext ? _self.hasNext : hasNext // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
