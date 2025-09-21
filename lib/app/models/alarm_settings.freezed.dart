// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alarm_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AlarmSettings {

 bool get push; bool get bookmark; bool get calendar; bool get marketing;
/// Create a copy of AlarmSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlarmSettingsCopyWith<AlarmSettings> get copyWith => _$AlarmSettingsCopyWithImpl<AlarmSettings>(this as AlarmSettings, _$identity);

  /// Serializes this AlarmSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlarmSettings&&(identical(other.push, push) || other.push == push)&&(identical(other.bookmark, bookmark) || other.bookmark == bookmark)&&(identical(other.calendar, calendar) || other.calendar == calendar)&&(identical(other.marketing, marketing) || other.marketing == marketing));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,push,bookmark,calendar,marketing);

@override
String toString() {
  return 'AlarmSettings(push: $push, bookmark: $bookmark, calendar: $calendar, marketing: $marketing)';
}


}

/// @nodoc
abstract mixin class $AlarmSettingsCopyWith<$Res>  {
  factory $AlarmSettingsCopyWith(AlarmSettings value, $Res Function(AlarmSettings) _then) = _$AlarmSettingsCopyWithImpl;
@useResult
$Res call({
 bool push, bool bookmark, bool calendar, bool marketing
});




}
/// @nodoc
class _$AlarmSettingsCopyWithImpl<$Res>
    implements $AlarmSettingsCopyWith<$Res> {
  _$AlarmSettingsCopyWithImpl(this._self, this._then);

  final AlarmSettings _self;
  final $Res Function(AlarmSettings) _then;

/// Create a copy of AlarmSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? push = null,Object? bookmark = null,Object? calendar = null,Object? marketing = null,}) {
  return _then(_self.copyWith(
push: null == push ? _self.push : push // ignore: cast_nullable_to_non_nullable
as bool,bookmark: null == bookmark ? _self.bookmark : bookmark // ignore: cast_nullable_to_non_nullable
as bool,calendar: null == calendar ? _self.calendar : calendar // ignore: cast_nullable_to_non_nullable
as bool,marketing: null == marketing ? _self.marketing : marketing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AlarmSettings].
extension AlarmSettingsPatterns on AlarmSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlarmSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlarmSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlarmSettings value)  $default,){
final _that = this;
switch (_that) {
case _AlarmSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlarmSettings value)?  $default,){
final _that = this;
switch (_that) {
case _AlarmSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool push,  bool bookmark,  bool calendar,  bool marketing)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlarmSettings() when $default != null:
return $default(_that.push,_that.bookmark,_that.calendar,_that.marketing);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool push,  bool bookmark,  bool calendar,  bool marketing)  $default,) {final _that = this;
switch (_that) {
case _AlarmSettings():
return $default(_that.push,_that.bookmark,_that.calendar,_that.marketing);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool push,  bool bookmark,  bool calendar,  bool marketing)?  $default,) {final _that = this;
switch (_that) {
case _AlarmSettings() when $default != null:
return $default(_that.push,_that.bookmark,_that.calendar,_that.marketing);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AlarmSettings implements AlarmSettings {
  const _AlarmSettings({this.push = false, this.bookmark = false, this.calendar = false, this.marketing = false});
  factory _AlarmSettings.fromJson(Map<String, dynamic> json) => _$AlarmSettingsFromJson(json);

@override@JsonKey() final  bool push;
@override@JsonKey() final  bool bookmark;
@override@JsonKey() final  bool calendar;
@override@JsonKey() final  bool marketing;

/// Create a copy of AlarmSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlarmSettingsCopyWith<_AlarmSettings> get copyWith => __$AlarmSettingsCopyWithImpl<_AlarmSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlarmSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlarmSettings&&(identical(other.push, push) || other.push == push)&&(identical(other.bookmark, bookmark) || other.bookmark == bookmark)&&(identical(other.calendar, calendar) || other.calendar == calendar)&&(identical(other.marketing, marketing) || other.marketing == marketing));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,push,bookmark,calendar,marketing);

@override
String toString() {
  return 'AlarmSettings(push: $push, bookmark: $bookmark, calendar: $calendar, marketing: $marketing)';
}


}

/// @nodoc
abstract mixin class _$AlarmSettingsCopyWith<$Res> implements $AlarmSettingsCopyWith<$Res> {
  factory _$AlarmSettingsCopyWith(_AlarmSettings value, $Res Function(_AlarmSettings) _then) = __$AlarmSettingsCopyWithImpl;
@override @useResult
$Res call({
 bool push, bool bookmark, bool calendar, bool marketing
});




}
/// @nodoc
class __$AlarmSettingsCopyWithImpl<$Res>
    implements _$AlarmSettingsCopyWith<$Res> {
  __$AlarmSettingsCopyWithImpl(this._self, this._then);

  final _AlarmSettings _self;
  final $Res Function(_AlarmSettings) _then;

/// Create a copy of AlarmSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? push = null,Object? bookmark = null,Object? calendar = null,Object? marketing = null,}) {
  return _then(_AlarmSettings(
push: null == push ? _self.push : push // ignore: cast_nullable_to_non_nullable
as bool,bookmark: null == bookmark ? _self.bookmark : bookmark // ignore: cast_nullable_to_non_nullable
as bool,calendar: null == calendar ? _self.calendar : calendar // ignore: cast_nullable_to_non_nullable
as bool,marketing: null == marketing ? _self.marketing : marketing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
