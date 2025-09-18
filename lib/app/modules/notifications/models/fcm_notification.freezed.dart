// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fcm_notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FcmNotification {

 String get id; String get title; String get body;//required Map data,
 DateTime get timestamp; bool get read;
/// Create a copy of FcmNotification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FcmNotificationCopyWith<FcmNotification> get copyWith => _$FcmNotificationCopyWithImpl<FcmNotification>(this as FcmNotification, _$identity);

  /// Serializes this FcmNotification to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FcmNotification&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.read, read) || other.read == read));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,body,timestamp,read);

@override
String toString() {
  return 'FcmNotification(id: $id, title: $title, body: $body, timestamp: $timestamp, read: $read)';
}


}

/// @nodoc
abstract mixin class $FcmNotificationCopyWith<$Res>  {
  factory $FcmNotificationCopyWith(FcmNotification value, $Res Function(FcmNotification) _then) = _$FcmNotificationCopyWithImpl;
@useResult
$Res call({
 String id, String title, String body, DateTime timestamp, bool read
});




}
/// @nodoc
class _$FcmNotificationCopyWithImpl<$Res>
    implements $FcmNotificationCopyWith<$Res> {
  _$FcmNotificationCopyWithImpl(this._self, this._then);

  final FcmNotification _self;
  final $Res Function(FcmNotification) _then;

/// Create a copy of FcmNotification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? body = null,Object? timestamp = null,Object? read = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,read: null == read ? _self.read : read // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [FcmNotification].
extension FcmNotificationPatterns on FcmNotification {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FcmNotification value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FcmNotification() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FcmNotification value)  $default,){
final _that = this;
switch (_that) {
case _FcmNotification():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FcmNotification value)?  $default,){
final _that = this;
switch (_that) {
case _FcmNotification() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String body,  DateTime timestamp,  bool read)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FcmNotification() when $default != null:
return $default(_that.id,_that.title,_that.body,_that.timestamp,_that.read);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String body,  DateTime timestamp,  bool read)  $default,) {final _that = this;
switch (_that) {
case _FcmNotification():
return $default(_that.id,_that.title,_that.body,_that.timestamp,_that.read);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String body,  DateTime timestamp,  bool read)?  $default,) {final _that = this;
switch (_that) {
case _FcmNotification() when $default != null:
return $default(_that.id,_that.title,_that.body,_that.timestamp,_that.read);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FcmNotification implements FcmNotification {
  const _FcmNotification({required this.id, required this.title, required this.body, required this.timestamp, this.read = false});
  factory _FcmNotification.fromJson(Map<String, dynamic> json) => _$FcmNotificationFromJson(json);

@override final  String id;
@override final  String title;
@override final  String body;
//required Map data,
@override final  DateTime timestamp;
@override@JsonKey() final  bool read;

/// Create a copy of FcmNotification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FcmNotificationCopyWith<_FcmNotification> get copyWith => __$FcmNotificationCopyWithImpl<_FcmNotification>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FcmNotificationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FcmNotification&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.read, read) || other.read == read));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,body,timestamp,read);

@override
String toString() {
  return 'FcmNotification(id: $id, title: $title, body: $body, timestamp: $timestamp, read: $read)';
}


}

/// @nodoc
abstract mixin class _$FcmNotificationCopyWith<$Res> implements $FcmNotificationCopyWith<$Res> {
  factory _$FcmNotificationCopyWith(_FcmNotification value, $Res Function(_FcmNotification) _then) = __$FcmNotificationCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String body, DateTime timestamp, bool read
});




}
/// @nodoc
class __$FcmNotificationCopyWithImpl<$Res>
    implements _$FcmNotificationCopyWith<$Res> {
  __$FcmNotificationCopyWithImpl(this._self, this._then);

  final _FcmNotification _self;
  final $Res Function(_FcmNotification) _then;

/// Create a copy of FcmNotification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? body = null,Object? timestamp = null,Object? read = null,}) {
  return _then(_FcmNotification(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,read: null == read ? _self.read : read // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
