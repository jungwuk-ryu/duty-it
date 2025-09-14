// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'host.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Host {

 int get id; String get name; String get thumbnail;
/// Create a copy of Host
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HostCopyWith<Host> get copyWith => _$HostCopyWithImpl<Host>(this as Host, _$identity);

  /// Serializes this Host to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Host&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.thumbnail, thumbnail) || other.thumbnail == thumbnail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,thumbnail);

@override
String toString() {
  return 'Host(id: $id, name: $name, thumbnail: $thumbnail)';
}


}

/// @nodoc
abstract mixin class $HostCopyWith<$Res>  {
  factory $HostCopyWith(Host value, $Res Function(Host) _then) = _$HostCopyWithImpl;
@useResult
$Res call({
 int id, String name, String thumbnail
});




}
/// @nodoc
class _$HostCopyWithImpl<$Res>
    implements $HostCopyWith<$Res> {
  _$HostCopyWithImpl(this._self, this._then);

  final Host _self;
  final $Res Function(Host) _then;

/// Create a copy of Host
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? thumbnail = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,thumbnail: null == thumbnail ? _self.thumbnail : thumbnail // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Host].
extension HostPatterns on Host {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Host value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Host() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Host value)  $default,){
final _that = this;
switch (_that) {
case _Host():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Host value)?  $default,){
final _that = this;
switch (_that) {
case _Host() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String thumbnail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Host() when $default != null:
return $default(_that.id,_that.name,_that.thumbnail);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String thumbnail)  $default,) {final _that = this;
switch (_that) {
case _Host():
return $default(_that.id,_that.name,_that.thumbnail);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String thumbnail)?  $default,) {final _that = this;
switch (_that) {
case _Host() when $default != null:
return $default(_that.id,_that.name,_that.thumbnail);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Host implements Host {
  const _Host({required this.id, this.name = "?", this.thumbnail = ""});
  factory _Host.fromJson(Map<String, dynamic> json) => _$HostFromJson(json);

@override final  int id;
@override@JsonKey() final  String name;
@override@JsonKey() final  String thumbnail;

/// Create a copy of Host
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HostCopyWith<_Host> get copyWith => __$HostCopyWithImpl<_Host>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HostToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Host&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.thumbnail, thumbnail) || other.thumbnail == thumbnail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,thumbnail);

@override
String toString() {
  return 'Host(id: $id, name: $name, thumbnail: $thumbnail)';
}


}

/// @nodoc
abstract mixin class _$HostCopyWith<$Res> implements $HostCopyWith<$Res> {
  factory _$HostCopyWith(_Host value, $Res Function(_Host) _then) = __$HostCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String thumbnail
});




}
/// @nodoc
class __$HostCopyWithImpl<$Res>
    implements _$HostCopyWith<$Res> {
  __$HostCopyWithImpl(this._self, this._then);

  final _Host _self;
  final $Res Function(_Host) _then;

/// Create a copy of Host
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? thumbnail = null,}) {
  return _then(_Host(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,thumbnail: null == thumbnail ? _self.thumbnail : thumbnail // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
