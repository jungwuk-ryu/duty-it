// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'events_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EventsResponse {

@JsonKey(name: 'content') List<Event> get events; EventsPageInfo get pageInfo;@JsonKey(includeFromJson: false, includeToJson: false) String? get reqUrl;
/// Create a copy of EventsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventsResponseCopyWith<EventsResponse> get copyWith => _$EventsResponseCopyWithImpl<EventsResponse>(this as EventsResponse, _$identity);

  /// Serializes this EventsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventsResponse&&const DeepCollectionEquality().equals(other.events, events)&&(identical(other.pageInfo, pageInfo) || other.pageInfo == pageInfo)&&(identical(other.reqUrl, reqUrl) || other.reqUrl == reqUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(events),pageInfo,reqUrl);

@override
String toString() {
  return 'EventsResponse(events: $events, pageInfo: $pageInfo, reqUrl: $reqUrl)';
}


}

/// @nodoc
abstract mixin class $EventsResponseCopyWith<$Res>  {
  factory $EventsResponseCopyWith(EventsResponse value, $Res Function(EventsResponse) _then) = _$EventsResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'content') List<Event> events, EventsPageInfo pageInfo,@JsonKey(includeFromJson: false, includeToJson: false) String? reqUrl
});


$EventsPageInfoCopyWith<$Res> get pageInfo;

}
/// @nodoc
class _$EventsResponseCopyWithImpl<$Res>
    implements $EventsResponseCopyWith<$Res> {
  _$EventsResponseCopyWithImpl(this._self, this._then);

  final EventsResponse _self;
  final $Res Function(EventsResponse) _then;

/// Create a copy of EventsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? events = null,Object? pageInfo = null,Object? reqUrl = freezed,}) {
  return _then(_self.copyWith(
events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as List<Event>,pageInfo: null == pageInfo ? _self.pageInfo : pageInfo // ignore: cast_nullable_to_non_nullable
as EventsPageInfo,reqUrl: freezed == reqUrl ? _self.reqUrl : reqUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of EventsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventsPageInfoCopyWith<$Res> get pageInfo {
  
  return $EventsPageInfoCopyWith<$Res>(_self.pageInfo, (value) {
    return _then(_self.copyWith(pageInfo: value));
  });
}
}


/// Adds pattern-matching-related methods to [EventsResponse].
extension EventsResponsePatterns on EventsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventsResponse value)  $default,){
final _that = this;
switch (_that) {
case _EventsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _EventsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'content')  List<Event> events,  EventsPageInfo pageInfo, @JsonKey(includeFromJson: false, includeToJson: false)  String? reqUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventsResponse() when $default != null:
return $default(_that.events,_that.pageInfo,_that.reqUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'content')  List<Event> events,  EventsPageInfo pageInfo, @JsonKey(includeFromJson: false, includeToJson: false)  String? reqUrl)  $default,) {final _that = this;
switch (_that) {
case _EventsResponse():
return $default(_that.events,_that.pageInfo,_that.reqUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'content')  List<Event> events,  EventsPageInfo pageInfo, @JsonKey(includeFromJson: false, includeToJson: false)  String? reqUrl)?  $default,) {final _that = this;
switch (_that) {
case _EventsResponse() when $default != null:
return $default(_that.events,_that.pageInfo,_that.reqUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EventsResponse implements EventsResponse {
  const _EventsResponse({@JsonKey(name: 'content') required final  List<Event> events, required this.pageInfo, @JsonKey(includeFromJson: false, includeToJson: false) this.reqUrl}): _events = events;
  factory _EventsResponse.fromJson(Map<String, dynamic> json) => _$EventsResponseFromJson(json);

 final  List<Event> _events;
@override@JsonKey(name: 'content') List<Event> get events {
  if (_events is EqualUnmodifiableListView) return _events;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_events);
}

@override final  EventsPageInfo pageInfo;
@override@JsonKey(includeFromJson: false, includeToJson: false) final  String? reqUrl;

/// Create a copy of EventsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventsResponseCopyWith<_EventsResponse> get copyWith => __$EventsResponseCopyWithImpl<_EventsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventsResponse&&const DeepCollectionEquality().equals(other._events, _events)&&(identical(other.pageInfo, pageInfo) || other.pageInfo == pageInfo)&&(identical(other.reqUrl, reqUrl) || other.reqUrl == reqUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_events),pageInfo,reqUrl);

@override
String toString() {
  return 'EventsResponse(events: $events, pageInfo: $pageInfo, reqUrl: $reqUrl)';
}


}

/// @nodoc
abstract mixin class _$EventsResponseCopyWith<$Res> implements $EventsResponseCopyWith<$Res> {
  factory _$EventsResponseCopyWith(_EventsResponse value, $Res Function(_EventsResponse) _then) = __$EventsResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'content') List<Event> events, EventsPageInfo pageInfo,@JsonKey(includeFromJson: false, includeToJson: false) String? reqUrl
});


@override $EventsPageInfoCopyWith<$Res> get pageInfo;

}
/// @nodoc
class __$EventsResponseCopyWithImpl<$Res>
    implements _$EventsResponseCopyWith<$Res> {
  __$EventsResponseCopyWithImpl(this._self, this._then);

  final _EventsResponse _self;
  final $Res Function(_EventsResponse) _then;

/// Create a copy of EventsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? events = null,Object? pageInfo = null,Object? reqUrl = freezed,}) {
  return _then(_EventsResponse(
events: null == events ? _self._events : events // ignore: cast_nullable_to_non_nullable
as List<Event>,pageInfo: null == pageInfo ? _self.pageInfo : pageInfo // ignore: cast_nullable_to_non_nullable
as EventsPageInfo,reqUrl: freezed == reqUrl ? _self.reqUrl : reqUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of EventsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventsPageInfoCopyWith<$Res> get pageInfo {
  
  return $EventsPageInfoCopyWith<$Res>(_self.pageInfo, (value) {
    return _then(_self.copyWith(pageInfo: value));
  });
}
}

// dart format on
