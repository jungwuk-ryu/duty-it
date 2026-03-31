// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JobFilter {

 Set<WorkRegion> get workRegions; Set<JobEmploymentType> get employmentTypes;
/// Create a copy of JobFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobFilterCopyWith<JobFilter> get copyWith => _$JobFilterCopyWithImpl<JobFilter>(this as JobFilter, _$identity);

  /// Serializes this JobFilter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobFilter&&const DeepCollectionEquality().equals(other.workRegions, workRegions)&&const DeepCollectionEquality().equals(other.employmentTypes, employmentTypes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(workRegions),const DeepCollectionEquality().hash(employmentTypes));

@override
String toString() {
  return 'JobFilter(workRegions: $workRegions, employmentTypes: $employmentTypes)';
}


}

/// @nodoc
abstract mixin class $JobFilterCopyWith<$Res>  {
  factory $JobFilterCopyWith(JobFilter value, $Res Function(JobFilter) _then) = _$JobFilterCopyWithImpl;
@useResult
$Res call({
 Set<WorkRegion> workRegions, Set<JobEmploymentType> employmentTypes
});




}
/// @nodoc
class _$JobFilterCopyWithImpl<$Res>
    implements $JobFilterCopyWith<$Res> {
  _$JobFilterCopyWithImpl(this._self, this._then);

  final JobFilter _self;
  final $Res Function(JobFilter) _then;

/// Create a copy of JobFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workRegions = null,Object? employmentTypes = null,}) {
  return _then(_self.copyWith(
workRegions: null == workRegions ? _self.workRegions : workRegions // ignore: cast_nullable_to_non_nullable
as Set<WorkRegion>,employmentTypes: null == employmentTypes ? _self.employmentTypes : employmentTypes // ignore: cast_nullable_to_non_nullable
as Set<JobEmploymentType>,
  ));
}

}


/// Adds pattern-matching-related methods to [JobFilter].
extension JobFilterPatterns on JobFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobFilter value)  $default,){
final _that = this;
switch (_that) {
case _JobFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobFilter value)?  $default,){
final _that = this;
switch (_that) {
case _JobFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Set<WorkRegion> workRegions,  Set<JobEmploymentType> employmentTypes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobFilter() when $default != null:
return $default(_that.workRegions,_that.employmentTypes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Set<WorkRegion> workRegions,  Set<JobEmploymentType> employmentTypes)  $default,) {final _that = this;
switch (_that) {
case _JobFilter():
return $default(_that.workRegions,_that.employmentTypes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Set<WorkRegion> workRegions,  Set<JobEmploymentType> employmentTypes)?  $default,) {final _that = this;
switch (_that) {
case _JobFilter() when $default != null:
return $default(_that.workRegions,_that.employmentTypes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobFilter implements JobFilter {
  const _JobFilter({final  Set<WorkRegion> workRegions = const <WorkRegion>{}, final  Set<JobEmploymentType> employmentTypes = const <JobEmploymentType>{}}): _workRegions = workRegions,_employmentTypes = employmentTypes;
  factory _JobFilter.fromJson(Map<String, dynamic> json) => _$JobFilterFromJson(json);

 final  Set<WorkRegion> _workRegions;
@override@JsonKey() Set<WorkRegion> get workRegions {
  if (_workRegions is EqualUnmodifiableSetView) return _workRegions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_workRegions);
}

 final  Set<JobEmploymentType> _employmentTypes;
@override@JsonKey() Set<JobEmploymentType> get employmentTypes {
  if (_employmentTypes is EqualUnmodifiableSetView) return _employmentTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_employmentTypes);
}


/// Create a copy of JobFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobFilterCopyWith<_JobFilter> get copyWith => __$JobFilterCopyWithImpl<_JobFilter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobFilterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobFilter&&const DeepCollectionEquality().equals(other._workRegions, _workRegions)&&const DeepCollectionEquality().equals(other._employmentTypes, _employmentTypes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_workRegions),const DeepCollectionEquality().hash(_employmentTypes));

@override
String toString() {
  return 'JobFilter(workRegions: $workRegions, employmentTypes: $employmentTypes)';
}


}

/// @nodoc
abstract mixin class _$JobFilterCopyWith<$Res> implements $JobFilterCopyWith<$Res> {
  factory _$JobFilterCopyWith(_JobFilter value, $Res Function(_JobFilter) _then) = __$JobFilterCopyWithImpl;
@override @useResult
$Res call({
 Set<WorkRegion> workRegions, Set<JobEmploymentType> employmentTypes
});




}
/// @nodoc
class __$JobFilterCopyWithImpl<$Res>
    implements _$JobFilterCopyWith<$Res> {
  __$JobFilterCopyWithImpl(this._self, this._then);

  final _JobFilter _self;
  final $Res Function(_JobFilter) _then;

/// Create a copy of JobFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workRegions = null,Object? employmentTypes = null,}) {
  return _then(_JobFilter(
workRegions: null == workRegions ? _self._workRegions : workRegions // ignore: cast_nullable_to_non_nullable
as Set<WorkRegion>,employmentTypes: null == employmentTypes ? _self._employmentTypes : employmentTypes // ignore: cast_nullable_to_non_nullable
as Set<JobEmploymentType>,
  ));
}


}

// dart format on
