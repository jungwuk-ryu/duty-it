// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_posting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JobPosting {

 int get id;// ignore: invalid_annotation_target
@JsonKey(unknownEnumValue: JobSourceType.unknown) JobSourceType get sourceType; String get title; String get companyName; String get jobCategory; String get location;// ignore: invalid_annotation_target
@JsonKey(unknownEnumValue: WorkRegion.unknown) WorkRegion? get workRegion; String get workDistrict;// ignore: invalid_annotation_target
@JsonKey(unknownEnumValue: JobEmploymentType.unknown) JobEmploymentType? get employmentType; String get careerDescription;// ignore: invalid_annotation_target
@JsonKey(unknownEnumValue: JobEducationLevel.unknown) JobEducationLevel? get educationLevel; String get salaryDescription;// ignore: invalid_annotation_target
@JsonKey(unknownEnumValue: JobSalaryType.unknown) JobSalaryType? get salaryType; String get postingUrl; DateTime? get postedAt; DateTime? get expiresAt;// ignore: invalid_annotation_target
@JsonKey(unknownEnumValue: JobCloseType.unknown) JobCloseType get closeType; bool get isBookmarked; DateTime? get createdAt;
/// Create a copy of JobPosting
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobPostingCopyWith<JobPosting> get copyWith => _$JobPostingCopyWithImpl<JobPosting>(this as JobPosting, _$identity);

  /// Serializes this JobPosting to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobPosting&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&(identical(other.title, title) || other.title == title)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.jobCategory, jobCategory) || other.jobCategory == jobCategory)&&(identical(other.location, location) || other.location == location)&&(identical(other.workRegion, workRegion) || other.workRegion == workRegion)&&(identical(other.workDistrict, workDistrict) || other.workDistrict == workDistrict)&&(identical(other.employmentType, employmentType) || other.employmentType == employmentType)&&(identical(other.careerDescription, careerDescription) || other.careerDescription == careerDescription)&&(identical(other.educationLevel, educationLevel) || other.educationLevel == educationLevel)&&(identical(other.salaryDescription, salaryDescription) || other.salaryDescription == salaryDescription)&&(identical(other.salaryType, salaryType) || other.salaryType == salaryType)&&(identical(other.postingUrl, postingUrl) || other.postingUrl == postingUrl)&&(identical(other.postedAt, postedAt) || other.postedAt == postedAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.closeType, closeType) || other.closeType == closeType)&&(identical(other.isBookmarked, isBookmarked) || other.isBookmarked == isBookmarked)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,sourceType,title,companyName,jobCategory,location,workRegion,workDistrict,employmentType,careerDescription,educationLevel,salaryDescription,salaryType,postingUrl,postedAt,expiresAt,closeType,isBookmarked,createdAt]);

@override
String toString() {
  return 'JobPosting(id: $id, sourceType: $sourceType, title: $title, companyName: $companyName, jobCategory: $jobCategory, location: $location, workRegion: $workRegion, workDistrict: $workDistrict, employmentType: $employmentType, careerDescription: $careerDescription, educationLevel: $educationLevel, salaryDescription: $salaryDescription, salaryType: $salaryType, postingUrl: $postingUrl, postedAt: $postedAt, expiresAt: $expiresAt, closeType: $closeType, isBookmarked: $isBookmarked, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $JobPostingCopyWith<$Res>  {
  factory $JobPostingCopyWith(JobPosting value, $Res Function(JobPosting) _then) = _$JobPostingCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(unknownEnumValue: JobSourceType.unknown) JobSourceType sourceType, String title, String companyName, String jobCategory, String location,@JsonKey(unknownEnumValue: WorkRegion.unknown) WorkRegion? workRegion, String workDistrict,@JsonKey(unknownEnumValue: JobEmploymentType.unknown) JobEmploymentType? employmentType, String careerDescription,@JsonKey(unknownEnumValue: JobEducationLevel.unknown) JobEducationLevel? educationLevel, String salaryDescription,@JsonKey(unknownEnumValue: JobSalaryType.unknown) JobSalaryType? salaryType, String postingUrl, DateTime? postedAt, DateTime? expiresAt,@JsonKey(unknownEnumValue: JobCloseType.unknown) JobCloseType closeType, bool isBookmarked, DateTime? createdAt
});




}
/// @nodoc
class _$JobPostingCopyWithImpl<$Res>
    implements $JobPostingCopyWith<$Res> {
  _$JobPostingCopyWithImpl(this._self, this._then);

  final JobPosting _self;
  final $Res Function(JobPosting) _then;

/// Create a copy of JobPosting
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sourceType = null,Object? title = null,Object? companyName = null,Object? jobCategory = null,Object? location = null,Object? workRegion = freezed,Object? workDistrict = null,Object? employmentType = freezed,Object? careerDescription = null,Object? educationLevel = freezed,Object? salaryDescription = null,Object? salaryType = freezed,Object? postingUrl = null,Object? postedAt = freezed,Object? expiresAt = freezed,Object? closeType = null,Object? isBookmarked = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,sourceType: null == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as JobSourceType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,jobCategory: null == jobCategory ? _self.jobCategory : jobCategory // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,workRegion: freezed == workRegion ? _self.workRegion : workRegion // ignore: cast_nullable_to_non_nullable
as WorkRegion?,workDistrict: null == workDistrict ? _self.workDistrict : workDistrict // ignore: cast_nullable_to_non_nullable
as String,employmentType: freezed == employmentType ? _self.employmentType : employmentType // ignore: cast_nullable_to_non_nullable
as JobEmploymentType?,careerDescription: null == careerDescription ? _self.careerDescription : careerDescription // ignore: cast_nullable_to_non_nullable
as String,educationLevel: freezed == educationLevel ? _self.educationLevel : educationLevel // ignore: cast_nullable_to_non_nullable
as JobEducationLevel?,salaryDescription: null == salaryDescription ? _self.salaryDescription : salaryDescription // ignore: cast_nullable_to_non_nullable
as String,salaryType: freezed == salaryType ? _self.salaryType : salaryType // ignore: cast_nullable_to_non_nullable
as JobSalaryType?,postingUrl: null == postingUrl ? _self.postingUrl : postingUrl // ignore: cast_nullable_to_non_nullable
as String,postedAt: freezed == postedAt ? _self.postedAt : postedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,closeType: null == closeType ? _self.closeType : closeType // ignore: cast_nullable_to_non_nullable
as JobCloseType,isBookmarked: null == isBookmarked ? _self.isBookmarked : isBookmarked // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [JobPosting].
extension JobPostingPatterns on JobPosting {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobPosting value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobPosting() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobPosting value)  $default,){
final _that = this;
switch (_that) {
case _JobPosting():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobPosting value)?  $default,){
final _that = this;
switch (_that) {
case _JobPosting() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(unknownEnumValue: JobSourceType.unknown)  JobSourceType sourceType,  String title,  String companyName,  String jobCategory,  String location, @JsonKey(unknownEnumValue: WorkRegion.unknown)  WorkRegion? workRegion,  String workDistrict, @JsonKey(unknownEnumValue: JobEmploymentType.unknown)  JobEmploymentType? employmentType,  String careerDescription, @JsonKey(unknownEnumValue: JobEducationLevel.unknown)  JobEducationLevel? educationLevel,  String salaryDescription, @JsonKey(unknownEnumValue: JobSalaryType.unknown)  JobSalaryType? salaryType,  String postingUrl,  DateTime? postedAt,  DateTime? expiresAt, @JsonKey(unknownEnumValue: JobCloseType.unknown)  JobCloseType closeType,  bool isBookmarked,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobPosting() when $default != null:
return $default(_that.id,_that.sourceType,_that.title,_that.companyName,_that.jobCategory,_that.location,_that.workRegion,_that.workDistrict,_that.employmentType,_that.careerDescription,_that.educationLevel,_that.salaryDescription,_that.salaryType,_that.postingUrl,_that.postedAt,_that.expiresAt,_that.closeType,_that.isBookmarked,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(unknownEnumValue: JobSourceType.unknown)  JobSourceType sourceType,  String title,  String companyName,  String jobCategory,  String location, @JsonKey(unknownEnumValue: WorkRegion.unknown)  WorkRegion? workRegion,  String workDistrict, @JsonKey(unknownEnumValue: JobEmploymentType.unknown)  JobEmploymentType? employmentType,  String careerDescription, @JsonKey(unknownEnumValue: JobEducationLevel.unknown)  JobEducationLevel? educationLevel,  String salaryDescription, @JsonKey(unknownEnumValue: JobSalaryType.unknown)  JobSalaryType? salaryType,  String postingUrl,  DateTime? postedAt,  DateTime? expiresAt, @JsonKey(unknownEnumValue: JobCloseType.unknown)  JobCloseType closeType,  bool isBookmarked,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _JobPosting():
return $default(_that.id,_that.sourceType,_that.title,_that.companyName,_that.jobCategory,_that.location,_that.workRegion,_that.workDistrict,_that.employmentType,_that.careerDescription,_that.educationLevel,_that.salaryDescription,_that.salaryType,_that.postingUrl,_that.postedAt,_that.expiresAt,_that.closeType,_that.isBookmarked,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(unknownEnumValue: JobSourceType.unknown)  JobSourceType sourceType,  String title,  String companyName,  String jobCategory,  String location, @JsonKey(unknownEnumValue: WorkRegion.unknown)  WorkRegion? workRegion,  String workDistrict, @JsonKey(unknownEnumValue: JobEmploymentType.unknown)  JobEmploymentType? employmentType,  String careerDescription, @JsonKey(unknownEnumValue: JobEducationLevel.unknown)  JobEducationLevel? educationLevel,  String salaryDescription, @JsonKey(unknownEnumValue: JobSalaryType.unknown)  JobSalaryType? salaryType,  String postingUrl,  DateTime? postedAt,  DateTime? expiresAt, @JsonKey(unknownEnumValue: JobCloseType.unknown)  JobCloseType closeType,  bool isBookmarked,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _JobPosting() when $default != null:
return $default(_that.id,_that.sourceType,_that.title,_that.companyName,_that.jobCategory,_that.location,_that.workRegion,_that.workDistrict,_that.employmentType,_that.careerDescription,_that.educationLevel,_that.salaryDescription,_that.salaryType,_that.postingUrl,_that.postedAt,_that.expiresAt,_that.closeType,_that.isBookmarked,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobPosting implements JobPosting {
  const _JobPosting({required this.id, @JsonKey(unknownEnumValue: JobSourceType.unknown) this.sourceType = JobSourceType.unknown, this.title = '?', this.companyName = '', this.jobCategory = '', this.location = '', @JsonKey(unknownEnumValue: WorkRegion.unknown) this.workRegion, this.workDistrict = '', @JsonKey(unknownEnumValue: JobEmploymentType.unknown) this.employmentType, this.careerDescription = '', @JsonKey(unknownEnumValue: JobEducationLevel.unknown) this.educationLevel, this.salaryDescription = '', @JsonKey(unknownEnumValue: JobSalaryType.unknown) this.salaryType, this.postingUrl = '', this.postedAt, this.expiresAt, @JsonKey(unknownEnumValue: JobCloseType.unknown) this.closeType = JobCloseType.unknown, this.isBookmarked = false, this.createdAt});
  factory _JobPosting.fromJson(Map<String, dynamic> json) => _$JobPostingFromJson(json);

@override final  int id;
// ignore: invalid_annotation_target
@override@JsonKey(unknownEnumValue: JobSourceType.unknown) final  JobSourceType sourceType;
@override@JsonKey() final  String title;
@override@JsonKey() final  String companyName;
@override@JsonKey() final  String jobCategory;
@override@JsonKey() final  String location;
// ignore: invalid_annotation_target
@override@JsonKey(unknownEnumValue: WorkRegion.unknown) final  WorkRegion? workRegion;
@override@JsonKey() final  String workDistrict;
// ignore: invalid_annotation_target
@override@JsonKey(unknownEnumValue: JobEmploymentType.unknown) final  JobEmploymentType? employmentType;
@override@JsonKey() final  String careerDescription;
// ignore: invalid_annotation_target
@override@JsonKey(unknownEnumValue: JobEducationLevel.unknown) final  JobEducationLevel? educationLevel;
@override@JsonKey() final  String salaryDescription;
// ignore: invalid_annotation_target
@override@JsonKey(unknownEnumValue: JobSalaryType.unknown) final  JobSalaryType? salaryType;
@override@JsonKey() final  String postingUrl;
@override final  DateTime? postedAt;
@override final  DateTime? expiresAt;
// ignore: invalid_annotation_target
@override@JsonKey(unknownEnumValue: JobCloseType.unknown) final  JobCloseType closeType;
@override@JsonKey() final  bool isBookmarked;
@override final  DateTime? createdAt;

/// Create a copy of JobPosting
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobPostingCopyWith<_JobPosting> get copyWith => __$JobPostingCopyWithImpl<_JobPosting>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobPostingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobPosting&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&(identical(other.title, title) || other.title == title)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.jobCategory, jobCategory) || other.jobCategory == jobCategory)&&(identical(other.location, location) || other.location == location)&&(identical(other.workRegion, workRegion) || other.workRegion == workRegion)&&(identical(other.workDistrict, workDistrict) || other.workDistrict == workDistrict)&&(identical(other.employmentType, employmentType) || other.employmentType == employmentType)&&(identical(other.careerDescription, careerDescription) || other.careerDescription == careerDescription)&&(identical(other.educationLevel, educationLevel) || other.educationLevel == educationLevel)&&(identical(other.salaryDescription, salaryDescription) || other.salaryDescription == salaryDescription)&&(identical(other.salaryType, salaryType) || other.salaryType == salaryType)&&(identical(other.postingUrl, postingUrl) || other.postingUrl == postingUrl)&&(identical(other.postedAt, postedAt) || other.postedAt == postedAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.closeType, closeType) || other.closeType == closeType)&&(identical(other.isBookmarked, isBookmarked) || other.isBookmarked == isBookmarked)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,sourceType,title,companyName,jobCategory,location,workRegion,workDistrict,employmentType,careerDescription,educationLevel,salaryDescription,salaryType,postingUrl,postedAt,expiresAt,closeType,isBookmarked,createdAt]);

@override
String toString() {
  return 'JobPosting(id: $id, sourceType: $sourceType, title: $title, companyName: $companyName, jobCategory: $jobCategory, location: $location, workRegion: $workRegion, workDistrict: $workDistrict, employmentType: $employmentType, careerDescription: $careerDescription, educationLevel: $educationLevel, salaryDescription: $salaryDescription, salaryType: $salaryType, postingUrl: $postingUrl, postedAt: $postedAt, expiresAt: $expiresAt, closeType: $closeType, isBookmarked: $isBookmarked, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$JobPostingCopyWith<$Res> implements $JobPostingCopyWith<$Res> {
  factory _$JobPostingCopyWith(_JobPosting value, $Res Function(_JobPosting) _then) = __$JobPostingCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(unknownEnumValue: JobSourceType.unknown) JobSourceType sourceType, String title, String companyName, String jobCategory, String location,@JsonKey(unknownEnumValue: WorkRegion.unknown) WorkRegion? workRegion, String workDistrict,@JsonKey(unknownEnumValue: JobEmploymentType.unknown) JobEmploymentType? employmentType, String careerDescription,@JsonKey(unknownEnumValue: JobEducationLevel.unknown) JobEducationLevel? educationLevel, String salaryDescription,@JsonKey(unknownEnumValue: JobSalaryType.unknown) JobSalaryType? salaryType, String postingUrl, DateTime? postedAt, DateTime? expiresAt,@JsonKey(unknownEnumValue: JobCloseType.unknown) JobCloseType closeType, bool isBookmarked, DateTime? createdAt
});




}
/// @nodoc
class __$JobPostingCopyWithImpl<$Res>
    implements _$JobPostingCopyWith<$Res> {
  __$JobPostingCopyWithImpl(this._self, this._then);

  final _JobPosting _self;
  final $Res Function(_JobPosting) _then;

/// Create a copy of JobPosting
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sourceType = null,Object? title = null,Object? companyName = null,Object? jobCategory = null,Object? location = null,Object? workRegion = freezed,Object? workDistrict = null,Object? employmentType = freezed,Object? careerDescription = null,Object? educationLevel = freezed,Object? salaryDescription = null,Object? salaryType = freezed,Object? postingUrl = null,Object? postedAt = freezed,Object? expiresAt = freezed,Object? closeType = null,Object? isBookmarked = null,Object? createdAt = freezed,}) {
  return _then(_JobPosting(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,sourceType: null == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as JobSourceType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,jobCategory: null == jobCategory ? _self.jobCategory : jobCategory // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,workRegion: freezed == workRegion ? _self.workRegion : workRegion // ignore: cast_nullable_to_non_nullable
as WorkRegion?,workDistrict: null == workDistrict ? _self.workDistrict : workDistrict // ignore: cast_nullable_to_non_nullable
as String,employmentType: freezed == employmentType ? _self.employmentType : employmentType // ignore: cast_nullable_to_non_nullable
as JobEmploymentType?,careerDescription: null == careerDescription ? _self.careerDescription : careerDescription // ignore: cast_nullable_to_non_nullable
as String,educationLevel: freezed == educationLevel ? _self.educationLevel : educationLevel // ignore: cast_nullable_to_non_nullable
as JobEducationLevel?,salaryDescription: null == salaryDescription ? _self.salaryDescription : salaryDescription // ignore: cast_nullable_to_non_nullable
as String,salaryType: freezed == salaryType ? _self.salaryType : salaryType // ignore: cast_nullable_to_non_nullable
as JobSalaryType?,postingUrl: null == postingUrl ? _self.postingUrl : postingUrl // ignore: cast_nullable_to_non_nullable
as String,postedAt: freezed == postedAt ? _self.postedAt : postedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,closeType: null == closeType ? _self.closeType : closeType // ignore: cast_nullable_to_non_nullable
as JobCloseType,isBookmarked: null == isBookmarked ? _self.isBookmarked : isBookmarked // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
