// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_postings_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JobPostingsResponse {

@JsonKey(name: 'content') List<JobPosting> get jobs; CursorPageInfo get pageInfo;
/// Create a copy of JobPostingsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobPostingsResponseCopyWith<JobPostingsResponse> get copyWith => _$JobPostingsResponseCopyWithImpl<JobPostingsResponse>(this as JobPostingsResponse, _$identity);

  /// Serializes this JobPostingsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobPostingsResponse&&const DeepCollectionEquality().equals(other.jobs, jobs)&&(identical(other.pageInfo, pageInfo) || other.pageInfo == pageInfo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(jobs),pageInfo);

@override
String toString() {
  return 'JobPostingsResponse(jobs: $jobs, pageInfo: $pageInfo)';
}


}

/// @nodoc
abstract mixin class $JobPostingsResponseCopyWith<$Res>  {
  factory $JobPostingsResponseCopyWith(JobPostingsResponse value, $Res Function(JobPostingsResponse) _then) = _$JobPostingsResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'content') List<JobPosting> jobs, CursorPageInfo pageInfo
});


$CursorPageInfoCopyWith<$Res> get pageInfo;

}
/// @nodoc
class _$JobPostingsResponseCopyWithImpl<$Res>
    implements $JobPostingsResponseCopyWith<$Res> {
  _$JobPostingsResponseCopyWithImpl(this._self, this._then);

  final JobPostingsResponse _self;
  final $Res Function(JobPostingsResponse) _then;

/// Create a copy of JobPostingsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? jobs = null,Object? pageInfo = null,}) {
  return _then(_self.copyWith(
jobs: null == jobs ? _self.jobs : jobs // ignore: cast_nullable_to_non_nullable
as List<JobPosting>,pageInfo: null == pageInfo ? _self.pageInfo : pageInfo // ignore: cast_nullable_to_non_nullable
as CursorPageInfo,
  ));
}
/// Create a copy of JobPostingsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CursorPageInfoCopyWith<$Res> get pageInfo {
  
  return $CursorPageInfoCopyWith<$Res>(_self.pageInfo, (value) {
    return _then(_self.copyWith(pageInfo: value));
  });
}
}


/// Adds pattern-matching-related methods to [JobPostingsResponse].
extension JobPostingsResponsePatterns on JobPostingsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobPostingsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobPostingsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobPostingsResponse value)  $default,){
final _that = this;
switch (_that) {
case _JobPostingsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobPostingsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _JobPostingsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'content')  List<JobPosting> jobs,  CursorPageInfo pageInfo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobPostingsResponse() when $default != null:
return $default(_that.jobs,_that.pageInfo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'content')  List<JobPosting> jobs,  CursorPageInfo pageInfo)  $default,) {final _that = this;
switch (_that) {
case _JobPostingsResponse():
return $default(_that.jobs,_that.pageInfo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'content')  List<JobPosting> jobs,  CursorPageInfo pageInfo)?  $default,) {final _that = this;
switch (_that) {
case _JobPostingsResponse() when $default != null:
return $default(_that.jobs,_that.pageInfo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobPostingsResponse implements JobPostingsResponse {
  const _JobPostingsResponse({@JsonKey(name: 'content') required final  List<JobPosting> jobs, required this.pageInfo}): _jobs = jobs;
  factory _JobPostingsResponse.fromJson(Map<String, dynamic> json) => _$JobPostingsResponseFromJson(json);

 final  List<JobPosting> _jobs;
@override@JsonKey(name: 'content') List<JobPosting> get jobs {
  if (_jobs is EqualUnmodifiableListView) return _jobs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_jobs);
}

@override final  CursorPageInfo pageInfo;

/// Create a copy of JobPostingsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobPostingsResponseCopyWith<_JobPostingsResponse> get copyWith => __$JobPostingsResponseCopyWithImpl<_JobPostingsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobPostingsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobPostingsResponse&&const DeepCollectionEquality().equals(other._jobs, _jobs)&&(identical(other.pageInfo, pageInfo) || other.pageInfo == pageInfo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_jobs),pageInfo);

@override
String toString() {
  return 'JobPostingsResponse(jobs: $jobs, pageInfo: $pageInfo)';
}


}

/// @nodoc
abstract mixin class _$JobPostingsResponseCopyWith<$Res> implements $JobPostingsResponseCopyWith<$Res> {
  factory _$JobPostingsResponseCopyWith(_JobPostingsResponse value, $Res Function(_JobPostingsResponse) _then) = __$JobPostingsResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'content') List<JobPosting> jobs, CursorPageInfo pageInfo
});


@override $CursorPageInfoCopyWith<$Res> get pageInfo;

}
/// @nodoc
class __$JobPostingsResponseCopyWithImpl<$Res>
    implements _$JobPostingsResponseCopyWith<$Res> {
  __$JobPostingsResponseCopyWithImpl(this._self, this._then);

  final _JobPostingsResponse _self;
  final $Res Function(_JobPostingsResponse) _then;

/// Create a copy of JobPostingsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? jobs = null,Object? pageInfo = null,}) {
  return _then(_JobPostingsResponse(
jobs: null == jobs ? _self._jobs : jobs // ignore: cast_nullable_to_non_nullable
as List<JobPosting>,pageInfo: null == pageInfo ? _self.pageInfo : pageInfo // ignore: cast_nullable_to_non_nullable
as CursorPageInfo,
  ));
}

/// Create a copy of JobPostingsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CursorPageInfoCopyWith<$Res> get pageInfo {
  
  return $CursorPageInfoCopyWith<$Res>(_self.pageInfo, (value) {
    return _then(_self.copyWith(pageInfo: value));
  });
}
}

// dart format on
