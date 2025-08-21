// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Event {

 int get id; String get title; DateTime? get startAt; DateTime? get endAt; DateTime? get recruitmentStartAt; DateTime? get recruitmentEndAt; String get uri; String get thumbnail; EventType get eventType; Host get host; dynamic get isBookmarked;
/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventCopyWith<Event> get copyWith => _$EventCopyWithImpl<Event>(this as Event, _$identity);

  /// Serializes this Event to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Event&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.startAt, startAt) || other.startAt == startAt)&&(identical(other.endAt, endAt) || other.endAt == endAt)&&(identical(other.recruitmentStartAt, recruitmentStartAt) || other.recruitmentStartAt == recruitmentStartAt)&&(identical(other.recruitmentEndAt, recruitmentEndAt) || other.recruitmentEndAt == recruitmentEndAt)&&(identical(other.uri, uri) || other.uri == uri)&&(identical(other.thumbnail, thumbnail) || other.thumbnail == thumbnail)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.host, host) || other.host == host)&&const DeepCollectionEquality().equals(other.isBookmarked, isBookmarked));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,startAt,endAt,recruitmentStartAt,recruitmentEndAt,uri,thumbnail,eventType,host,const DeepCollectionEquality().hash(isBookmarked));

@override
String toString() {
  return 'Event(id: $id, title: $title, startAt: $startAt, endAt: $endAt, recruitmentStartAt: $recruitmentStartAt, recruitmentEndAt: $recruitmentEndAt, uri: $uri, thumbnail: $thumbnail, eventType: $eventType, host: $host, isBookmarked: $isBookmarked)';
}


}

/// @nodoc
abstract mixin class $EventCopyWith<$Res>  {
  factory $EventCopyWith(Event value, $Res Function(Event) _then) = _$EventCopyWithImpl;
@useResult
$Res call({
 int id, String title, DateTime? startAt, DateTime? endAt, DateTime? recruitmentStartAt, DateTime? recruitmentEndAt, String uri, String thumbnail, EventType eventType, Host host, dynamic isBookmarked
});


$HostCopyWith<$Res> get host;

}
/// @nodoc
class _$EventCopyWithImpl<$Res>
    implements $EventCopyWith<$Res> {
  _$EventCopyWithImpl(this._self, this._then);

  final Event _self;
  final $Res Function(Event) _then;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? startAt = freezed,Object? endAt = freezed,Object? recruitmentStartAt = freezed,Object? recruitmentEndAt = freezed,Object? uri = null,Object? thumbnail = null,Object? eventType = null,Object? host = null,Object? isBookmarked = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startAt: freezed == startAt ? _self.startAt : startAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endAt: freezed == endAt ? _self.endAt : endAt // ignore: cast_nullable_to_non_nullable
as DateTime?,recruitmentStartAt: freezed == recruitmentStartAt ? _self.recruitmentStartAt : recruitmentStartAt // ignore: cast_nullable_to_non_nullable
as DateTime?,recruitmentEndAt: freezed == recruitmentEndAt ? _self.recruitmentEndAt : recruitmentEndAt // ignore: cast_nullable_to_non_nullable
as DateTime?,uri: null == uri ? _self.uri : uri // ignore: cast_nullable_to_non_nullable
as String,thumbnail: null == thumbnail ? _self.thumbnail : thumbnail // ignore: cast_nullable_to_non_nullable
as String,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as EventType,host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as Host,isBookmarked: freezed == isBookmarked ? _self.isBookmarked : isBookmarked // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}
/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HostCopyWith<$Res> get host {
  
  return $HostCopyWith<$Res>(_self.host, (value) {
    return _then(_self.copyWith(host: value));
  });
}
}


/// Adds pattern-matching-related methods to [Event].
extension EventPatterns on Event {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Event value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Event() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Event value)  $default,){
final _that = this;
switch (_that) {
case _Event():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Event value)?  $default,){
final _that = this;
switch (_that) {
case _Event() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  DateTime? startAt,  DateTime? endAt,  DateTime? recruitmentStartAt,  DateTime? recruitmentEndAt,  String uri,  String thumbnail,  EventType eventType,  Host host,  dynamic isBookmarked)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Event() when $default != null:
return $default(_that.id,_that.title,_that.startAt,_that.endAt,_that.recruitmentStartAt,_that.recruitmentEndAt,_that.uri,_that.thumbnail,_that.eventType,_that.host,_that.isBookmarked);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  DateTime? startAt,  DateTime? endAt,  DateTime? recruitmentStartAt,  DateTime? recruitmentEndAt,  String uri,  String thumbnail,  EventType eventType,  Host host,  dynamic isBookmarked)  $default,) {final _that = this;
switch (_that) {
case _Event():
return $default(_that.id,_that.title,_that.startAt,_that.endAt,_that.recruitmentStartAt,_that.recruitmentEndAt,_that.uri,_that.thumbnail,_that.eventType,_that.host,_that.isBookmarked);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  DateTime? startAt,  DateTime? endAt,  DateTime? recruitmentStartAt,  DateTime? recruitmentEndAt,  String uri,  String thumbnail,  EventType eventType,  Host host,  dynamic isBookmarked)?  $default,) {final _that = this;
switch (_that) {
case _Event() when $default != null:
return $default(_that.id,_that.title,_that.startAt,_that.endAt,_that.recruitmentStartAt,_that.recruitmentEndAt,_that.uri,_that.thumbnail,_that.eventType,_that.host,_that.isBookmarked);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Event implements Event {
  const _Event({required this.id, required this.title, this.startAt, this.endAt, this.recruitmentStartAt, this.recruitmentEndAt, required this.uri, required this.thumbnail, required this.eventType, required this.host, this.isBookmarked = false});
  factory _Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

@override final  int id;
@override final  String title;
@override final  DateTime? startAt;
@override final  DateTime? endAt;
@override final  DateTime? recruitmentStartAt;
@override final  DateTime? recruitmentEndAt;
@override final  String uri;
@override final  String thumbnail;
@override final  EventType eventType;
@override final  Host host;
@override@JsonKey() final  dynamic isBookmarked;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventCopyWith<_Event> get copyWith => __$EventCopyWithImpl<_Event>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Event&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.startAt, startAt) || other.startAt == startAt)&&(identical(other.endAt, endAt) || other.endAt == endAt)&&(identical(other.recruitmentStartAt, recruitmentStartAt) || other.recruitmentStartAt == recruitmentStartAt)&&(identical(other.recruitmentEndAt, recruitmentEndAt) || other.recruitmentEndAt == recruitmentEndAt)&&(identical(other.uri, uri) || other.uri == uri)&&(identical(other.thumbnail, thumbnail) || other.thumbnail == thumbnail)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.host, host) || other.host == host)&&const DeepCollectionEquality().equals(other.isBookmarked, isBookmarked));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,startAt,endAt,recruitmentStartAt,recruitmentEndAt,uri,thumbnail,eventType,host,const DeepCollectionEquality().hash(isBookmarked));

@override
String toString() {
  return 'Event(id: $id, title: $title, startAt: $startAt, endAt: $endAt, recruitmentStartAt: $recruitmentStartAt, recruitmentEndAt: $recruitmentEndAt, uri: $uri, thumbnail: $thumbnail, eventType: $eventType, host: $host, isBookmarked: $isBookmarked)';
}


}

/// @nodoc
abstract mixin class _$EventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory _$EventCopyWith(_Event value, $Res Function(_Event) _then) = __$EventCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, DateTime? startAt, DateTime? endAt, DateTime? recruitmentStartAt, DateTime? recruitmentEndAt, String uri, String thumbnail, EventType eventType, Host host, dynamic isBookmarked
});


@override $HostCopyWith<$Res> get host;

}
/// @nodoc
class __$EventCopyWithImpl<$Res>
    implements _$EventCopyWith<$Res> {
  __$EventCopyWithImpl(this._self, this._then);

  final _Event _self;
  final $Res Function(_Event) _then;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? startAt = freezed,Object? endAt = freezed,Object? recruitmentStartAt = freezed,Object? recruitmentEndAt = freezed,Object? uri = null,Object? thumbnail = null,Object? eventType = null,Object? host = null,Object? isBookmarked = freezed,}) {
  return _then(_Event(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startAt: freezed == startAt ? _self.startAt : startAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endAt: freezed == endAt ? _self.endAt : endAt // ignore: cast_nullable_to_non_nullable
as DateTime?,recruitmentStartAt: freezed == recruitmentStartAt ? _self.recruitmentStartAt : recruitmentStartAt // ignore: cast_nullable_to_non_nullable
as DateTime?,recruitmentEndAt: freezed == recruitmentEndAt ? _self.recruitmentEndAt : recruitmentEndAt // ignore: cast_nullable_to_non_nullable
as DateTime?,uri: null == uri ? _self.uri : uri // ignore: cast_nullable_to_non_nullable
as String,thumbnail: null == thumbnail ? _self.thumbnail : thumbnail // ignore: cast_nullable_to_non_nullable
as String,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as EventType,host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as Host,isBookmarked: freezed == isBookmarked ? _self.isBookmarked : isBookmarked // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HostCopyWith<$Res> get host {
  
  return $HostCopyWith<$Res>(_self.host, (value) {
    return _then(_self.copyWith(host: value));
  });
}
}

// dart format on
