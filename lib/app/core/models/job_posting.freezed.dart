// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_posting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JobPosting {

 int get id;@JsonKey(readValue: _readSourceType, unknownEnumValue: JobSourceType.unknown) JobSourceType get sourceType; String get wantedAuthNo; bool get isActive;@JsonKey(readValue: _readTitle) String get title;@JsonKey(readValue: _readCompanyName) String get companyName;@JsonKey(readValue: _readCompanyAddress) String get companyAddress;@JsonKey(readValue: _readCompanyBusiness) String get companyBusiness;@JsonKey(readValue: _readJobCategory) String get jobCategory; String get relJobsNm; String get jobCont; String get receiptCloseDt;@JsonKey(readValue: _readEmploymentName) String get employmentName;@JsonKey(readValue: _readLocation) String get location;@JsonKey(unknownEnumValue: WorkRegion.unknown) WorkRegion? get workRegion; String get workDistrict;@JsonKey(unknownEnumValue: JobEmploymentType.unknown) JobEmploymentType? get employmentType;@JsonKey(readValue: _readCareerDescription) String get careerDescription;@JsonKey(unknownEnumValue: JobEducationLevel.unknown) JobEducationLevel? get educationLevel;@JsonKey(readValue: _readEducationName) String get educationName;@JsonKey(readValue: _readSalaryDescription) String get salaryDescription;@JsonKey(unknownEnumValue: JobSalaryType.unknown) JobSalaryType? get salaryType;@JsonKey(readValue: _readPostingUrl) String get postingUrl; String get collectPsncnt; String get forLang; String get major; String get certificate; String get mltsvcExcHope; String get compAbl; String get pfCond; String get etcPfCond; String get selMthd; String get rcptMthd; String get submitDoc; String get etcHopeCont; String get nearLine; String get workdayWorkhrCont; String get fourIns; String get retirepay; String get etcWelfare; String get disableCvntl; String get attachFileUrl; List<String> get corpAttachList; List<String> get keywordList; String get empChargerDpt; String get contactTelno; String get chargerFaxNo; DateTime? get postedAt; DateTime? get expiresAt;@JsonKey(unknownEnumValue: JobCloseType.unknown) JobCloseType get closeType; bool get isBookmarked; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of JobPosting
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobPostingCopyWith<JobPosting> get copyWith => _$JobPostingCopyWithImpl<JobPosting>(this as JobPosting, _$identity);

  /// Serializes this JobPosting to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as JobPosting;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobPosting&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.sourceType, _this.sourceType) || other.sourceType == _this.sourceType)&&(identical(other.wantedAuthNo, _this.wantedAuthNo) || other.wantedAuthNo == _this.wantedAuthNo)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.companyName, _this.companyName) || other.companyName == _this.companyName)&&(identical(other.companyAddress, _this.companyAddress) || other.companyAddress == _this.companyAddress)&&(identical(other.companyBusiness, _this.companyBusiness) || other.companyBusiness == _this.companyBusiness)&&(identical(other.jobCategory, _this.jobCategory) || other.jobCategory == _this.jobCategory)&&(identical(other.relJobsNm, _this.relJobsNm) || other.relJobsNm == _this.relJobsNm)&&(identical(other.jobCont, _this.jobCont) || other.jobCont == _this.jobCont)&&(identical(other.receiptCloseDt, _this.receiptCloseDt) || other.receiptCloseDt == _this.receiptCloseDt)&&(identical(other.employmentName, _this.employmentName) || other.employmentName == _this.employmentName)&&(identical(other.location, _this.location) || other.location == _this.location)&&(identical(other.workRegion, _this.workRegion) || other.workRegion == _this.workRegion)&&(identical(other.workDistrict, _this.workDistrict) || other.workDistrict == _this.workDistrict)&&(identical(other.employmentType, _this.employmentType) || other.employmentType == _this.employmentType)&&(identical(other.careerDescription, _this.careerDescription) || other.careerDescription == _this.careerDescription)&&(identical(other.educationLevel, _this.educationLevel) || other.educationLevel == _this.educationLevel)&&(identical(other.educationName, _this.educationName) || other.educationName == _this.educationName)&&(identical(other.salaryDescription, _this.salaryDescription) || other.salaryDescription == _this.salaryDescription)&&(identical(other.salaryType, _this.salaryType) || other.salaryType == _this.salaryType)&&(identical(other.postingUrl, _this.postingUrl) || other.postingUrl == _this.postingUrl)&&(identical(other.collectPsncnt, _this.collectPsncnt) || other.collectPsncnt == _this.collectPsncnt)&&(identical(other.forLang, _this.forLang) || other.forLang == _this.forLang)&&(identical(other.major, _this.major) || other.major == _this.major)&&(identical(other.certificate, _this.certificate) || other.certificate == _this.certificate)&&(identical(other.mltsvcExcHope, _this.mltsvcExcHope) || other.mltsvcExcHope == _this.mltsvcExcHope)&&(identical(other.compAbl, _this.compAbl) || other.compAbl == _this.compAbl)&&(identical(other.pfCond, _this.pfCond) || other.pfCond == _this.pfCond)&&(identical(other.etcPfCond, _this.etcPfCond) || other.etcPfCond == _this.etcPfCond)&&(identical(other.selMthd, _this.selMthd) || other.selMthd == _this.selMthd)&&(identical(other.rcptMthd, _this.rcptMthd) || other.rcptMthd == _this.rcptMthd)&&(identical(other.submitDoc, _this.submitDoc) || other.submitDoc == _this.submitDoc)&&(identical(other.etcHopeCont, _this.etcHopeCont) || other.etcHopeCont == _this.etcHopeCont)&&(identical(other.nearLine, _this.nearLine) || other.nearLine == _this.nearLine)&&(identical(other.workdayWorkhrCont, _this.workdayWorkhrCont) || other.workdayWorkhrCont == _this.workdayWorkhrCont)&&(identical(other.fourIns, _this.fourIns) || other.fourIns == _this.fourIns)&&(identical(other.retirepay, _this.retirepay) || other.retirepay == _this.retirepay)&&(identical(other.etcWelfare, _this.etcWelfare) || other.etcWelfare == _this.etcWelfare)&&(identical(other.disableCvntl, _this.disableCvntl) || other.disableCvntl == _this.disableCvntl)&&(identical(other.attachFileUrl, _this.attachFileUrl) || other.attachFileUrl == _this.attachFileUrl)&&const DeepCollectionEquality().equals(other.corpAttachList, _this.corpAttachList)&&const DeepCollectionEquality().equals(other.keywordList, _this.keywordList)&&(identical(other.empChargerDpt, _this.empChargerDpt) || other.empChargerDpt == _this.empChargerDpt)&&(identical(other.contactTelno, _this.contactTelno) || other.contactTelno == _this.contactTelno)&&(identical(other.chargerFaxNo, _this.chargerFaxNo) || other.chargerFaxNo == _this.chargerFaxNo)&&(identical(other.postedAt, _this.postedAt) || other.postedAt == _this.postedAt)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt)&&(identical(other.closeType, _this.closeType) || other.closeType == _this.closeType)&&(identical(other.isBookmarked, _this.isBookmarked) || other.isBookmarked == _this.isBookmarked)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as JobPosting;
  return Object.hashAll([runtimeType,_this.id,_this.sourceType,_this.wantedAuthNo,_this.isActive,_this.title,_this.companyName,_this.companyAddress,_this.companyBusiness,_this.jobCategory,_this.relJobsNm,_this.jobCont,_this.receiptCloseDt,_this.employmentName,_this.location,_this.workRegion,_this.workDistrict,_this.employmentType,_this.careerDescription,_this.educationLevel,_this.educationName,_this.salaryDescription,_this.salaryType,_this.postingUrl,_this.collectPsncnt,_this.forLang,_this.major,_this.certificate,_this.mltsvcExcHope,_this.compAbl,_this.pfCond,_this.etcPfCond,_this.selMthd,_this.rcptMthd,_this.submitDoc,_this.etcHopeCont,_this.nearLine,_this.workdayWorkhrCont,_this.fourIns,_this.retirepay,_this.etcWelfare,_this.disableCvntl,_this.attachFileUrl,const DeepCollectionEquality().hash(_this.corpAttachList),const DeepCollectionEquality().hash(_this.keywordList),_this.empChargerDpt,_this.contactTelno,_this.chargerFaxNo,_this.postedAt,_this.expiresAt,_this.closeType,_this.isBookmarked,_this.createdAt,_this.updatedAt]);
}

@override
String toString() {
  final _this = this as JobPosting;
  return 'JobPosting(id: ${_this.id}, sourceType: ${_this.sourceType}, wantedAuthNo: ${_this.wantedAuthNo}, isActive: ${_this.isActive}, title: ${_this.title}, companyName: ${_this.companyName}, companyAddress: ${_this.companyAddress}, companyBusiness: ${_this.companyBusiness}, jobCategory: ${_this.jobCategory}, relJobsNm: ${_this.relJobsNm}, jobCont: ${_this.jobCont}, receiptCloseDt: ${_this.receiptCloseDt}, employmentName: ${_this.employmentName}, location: ${_this.location}, workRegion: ${_this.workRegion}, workDistrict: ${_this.workDistrict}, employmentType: ${_this.employmentType}, careerDescription: ${_this.careerDescription}, educationLevel: ${_this.educationLevel}, educationName: ${_this.educationName}, salaryDescription: ${_this.salaryDescription}, salaryType: ${_this.salaryType}, postingUrl: ${_this.postingUrl}, collectPsncnt: ${_this.collectPsncnt}, forLang: ${_this.forLang}, major: ${_this.major}, certificate: ${_this.certificate}, mltsvcExcHope: ${_this.mltsvcExcHope}, compAbl: ${_this.compAbl}, pfCond: ${_this.pfCond}, etcPfCond: ${_this.etcPfCond}, selMthd: ${_this.selMthd}, rcptMthd: ${_this.rcptMthd}, submitDoc: ${_this.submitDoc}, etcHopeCont: ${_this.etcHopeCont}, nearLine: ${_this.nearLine}, workdayWorkhrCont: ${_this.workdayWorkhrCont}, fourIns: ${_this.fourIns}, retirepay: ${_this.retirepay}, etcWelfare: ${_this.etcWelfare}, disableCvntl: ${_this.disableCvntl}, attachFileUrl: ${_this.attachFileUrl}, corpAttachList: ${_this.corpAttachList}, keywordList: ${_this.keywordList}, empChargerDpt: ${_this.empChargerDpt}, contactTelno: ${_this.contactTelno}, chargerFaxNo: ${_this.chargerFaxNo}, postedAt: ${_this.postedAt}, expiresAt: ${_this.expiresAt}, closeType: ${_this.closeType}, isBookmarked: ${_this.isBookmarked}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $JobPostingCopyWith<$Res>  {
  factory $JobPostingCopyWith(JobPosting value, $Res Function(JobPosting) _then) = _$JobPostingCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(readValue: _readSourceType, unknownEnumValue: JobSourceType.unknown) JobSourceType sourceType, String wantedAuthNo, bool isActive,@JsonKey(readValue: _readTitle) String title,@JsonKey(readValue: _readCompanyName) String companyName,@JsonKey(readValue: _readCompanyAddress) String companyAddress,@JsonKey(readValue: _readCompanyBusiness) String companyBusiness,@JsonKey(readValue: _readJobCategory) String jobCategory, String relJobsNm, String jobCont, String receiptCloseDt,@JsonKey(readValue: _readEmploymentName) String employmentName,@JsonKey(readValue: _readLocation) String location,@JsonKey(unknownEnumValue: WorkRegion.unknown) WorkRegion? workRegion, String workDistrict,@JsonKey(unknownEnumValue: JobEmploymentType.unknown) JobEmploymentType? employmentType,@JsonKey(readValue: _readCareerDescription) String careerDescription,@JsonKey(unknownEnumValue: JobEducationLevel.unknown) JobEducationLevel? educationLevel,@JsonKey(readValue: _readEducationName) String educationName,@JsonKey(readValue: _readSalaryDescription) String salaryDescription,@JsonKey(unknownEnumValue: JobSalaryType.unknown) JobSalaryType? salaryType,@JsonKey(readValue: _readPostingUrl) String postingUrl, String collectPsncnt, String forLang, String major, String certificate, String mltsvcExcHope, String compAbl, String pfCond, String etcPfCond, String selMthd, String rcptMthd, String submitDoc, String etcHopeCont, String nearLine, String workdayWorkhrCont, String fourIns, String retirepay, String etcWelfare, String disableCvntl, String attachFileUrl, List<String> corpAttachList, List<String> keywordList, String empChargerDpt, String contactTelno, String chargerFaxNo, DateTime? postedAt, DateTime? expiresAt,@JsonKey(unknownEnumValue: JobCloseType.unknown) JobCloseType closeType, bool isBookmarked, DateTime? createdAt, DateTime? updatedAt
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sourceType = null,Object? wantedAuthNo = null,Object? isActive = null,Object? title = null,Object? companyName = null,Object? companyAddress = null,Object? companyBusiness = null,Object? jobCategory = null,Object? relJobsNm = null,Object? jobCont = null,Object? receiptCloseDt = null,Object? employmentName = null,Object? location = null,Object? workRegion = freezed,Object? workDistrict = null,Object? employmentType = freezed,Object? careerDescription = null,Object? educationLevel = freezed,Object? educationName = null,Object? salaryDescription = null,Object? salaryType = freezed,Object? postingUrl = null,Object? collectPsncnt = null,Object? forLang = null,Object? major = null,Object? certificate = null,Object? mltsvcExcHope = null,Object? compAbl = null,Object? pfCond = null,Object? etcPfCond = null,Object? selMthd = null,Object? rcptMthd = null,Object? submitDoc = null,Object? etcHopeCont = null,Object? nearLine = null,Object? workdayWorkhrCont = null,Object? fourIns = null,Object? retirepay = null,Object? etcWelfare = null,Object? disableCvntl = null,Object? attachFileUrl = null,Object? corpAttachList = null,Object? keywordList = null,Object? empChargerDpt = null,Object? contactTelno = null,Object? chargerFaxNo = null,Object? postedAt = freezed,Object? expiresAt = freezed,Object? closeType = null,Object? isBookmarked = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(JobPosting(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,sourceType: null == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as JobSourceType,wantedAuthNo: null == wantedAuthNo ? _self.wantedAuthNo : wantedAuthNo // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,companyAddress: null == companyAddress ? _self.companyAddress : companyAddress // ignore: cast_nullable_to_non_nullable
as String,companyBusiness: null == companyBusiness ? _self.companyBusiness : companyBusiness // ignore: cast_nullable_to_non_nullable
as String,jobCategory: null == jobCategory ? _self.jobCategory : jobCategory // ignore: cast_nullable_to_non_nullable
as String,relJobsNm: null == relJobsNm ? _self.relJobsNm : relJobsNm // ignore: cast_nullable_to_non_nullable
as String,jobCont: null == jobCont ? _self.jobCont : jobCont // ignore: cast_nullable_to_non_nullable
as String,receiptCloseDt: null == receiptCloseDt ? _self.receiptCloseDt : receiptCloseDt // ignore: cast_nullable_to_non_nullable
as String,employmentName: null == employmentName ? _self.employmentName : employmentName // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,workRegion: freezed == workRegion ? _self.workRegion : workRegion // ignore: cast_nullable_to_non_nullable
as WorkRegion?,workDistrict: null == workDistrict ? _self.workDistrict : workDistrict // ignore: cast_nullable_to_non_nullable
as String,employmentType: freezed == employmentType ? _self.employmentType : employmentType // ignore: cast_nullable_to_non_nullable
as JobEmploymentType?,careerDescription: null == careerDescription ? _self.careerDescription : careerDescription // ignore: cast_nullable_to_non_nullable
as String,educationLevel: freezed == educationLevel ? _self.educationLevel : educationLevel // ignore: cast_nullable_to_non_nullable
as JobEducationLevel?,educationName: null == educationName ? _self.educationName : educationName // ignore: cast_nullable_to_non_nullable
as String,salaryDescription: null == salaryDescription ? _self.salaryDescription : salaryDescription // ignore: cast_nullable_to_non_nullable
as String,salaryType: freezed == salaryType ? _self.salaryType : salaryType // ignore: cast_nullable_to_non_nullable
as JobSalaryType?,postingUrl: null == postingUrl ? _self.postingUrl : postingUrl // ignore: cast_nullable_to_non_nullable
as String,collectPsncnt: null == collectPsncnt ? _self.collectPsncnt : collectPsncnt // ignore: cast_nullable_to_non_nullable
as String,forLang: null == forLang ? _self.forLang : forLang // ignore: cast_nullable_to_non_nullable
as String,major: null == major ? _self.major : major // ignore: cast_nullable_to_non_nullable
as String,certificate: null == certificate ? _self.certificate : certificate // ignore: cast_nullable_to_non_nullable
as String,mltsvcExcHope: null == mltsvcExcHope ? _self.mltsvcExcHope : mltsvcExcHope // ignore: cast_nullable_to_non_nullable
as String,compAbl: null == compAbl ? _self.compAbl : compAbl // ignore: cast_nullable_to_non_nullable
as String,pfCond: null == pfCond ? _self.pfCond : pfCond // ignore: cast_nullable_to_non_nullable
as String,etcPfCond: null == etcPfCond ? _self.etcPfCond : etcPfCond // ignore: cast_nullable_to_non_nullable
as String,selMthd: null == selMthd ? _self.selMthd : selMthd // ignore: cast_nullable_to_non_nullable
as String,rcptMthd: null == rcptMthd ? _self.rcptMthd : rcptMthd // ignore: cast_nullable_to_non_nullable
as String,submitDoc: null == submitDoc ? _self.submitDoc : submitDoc // ignore: cast_nullable_to_non_nullable
as String,etcHopeCont: null == etcHopeCont ? _self.etcHopeCont : etcHopeCont // ignore: cast_nullable_to_non_nullable
as String,nearLine: null == nearLine ? _self.nearLine : nearLine // ignore: cast_nullable_to_non_nullable
as String,workdayWorkhrCont: null == workdayWorkhrCont ? _self.workdayWorkhrCont : workdayWorkhrCont // ignore: cast_nullable_to_non_nullable
as String,fourIns: null == fourIns ? _self.fourIns : fourIns // ignore: cast_nullable_to_non_nullable
as String,retirepay: null == retirepay ? _self.retirepay : retirepay // ignore: cast_nullable_to_non_nullable
as String,etcWelfare: null == etcWelfare ? _self.etcWelfare : etcWelfare // ignore: cast_nullable_to_non_nullable
as String,disableCvntl: null == disableCvntl ? _self.disableCvntl : disableCvntl // ignore: cast_nullable_to_non_nullable
as String,attachFileUrl: null == attachFileUrl ? _self.attachFileUrl : attachFileUrl // ignore: cast_nullable_to_non_nullable
as String,corpAttachList: null == corpAttachList ? _self.corpAttachList : corpAttachList // ignore: cast_nullable_to_non_nullable
as List<String>,keywordList: null == keywordList ? _self.keywordList : keywordList // ignore: cast_nullable_to_non_nullable
as List<String>,empChargerDpt: null == empChargerDpt ? _self.empChargerDpt : empChargerDpt // ignore: cast_nullable_to_non_nullable
as String,contactTelno: null == contactTelno ? _self.contactTelno : contactTelno // ignore: cast_nullable_to_non_nullable
as String,chargerFaxNo: null == chargerFaxNo ? _self.chargerFaxNo : chargerFaxNo // ignore: cast_nullable_to_non_nullable
as String,postedAt: freezed == postedAt ? _self.postedAt : postedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,closeType: null == closeType ? _self.closeType : closeType // ignore: cast_nullable_to_non_nullable
as JobCloseType,isBookmarked: null == isBookmarked ? _self.isBookmarked : isBookmarked // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(readValue: _readSourceType, unknownEnumValue: JobSourceType.unknown)  JobSourceType sourceType,  String wantedAuthNo,  bool isActive, @JsonKey(readValue: _readTitle)  String title, @JsonKey(readValue: _readCompanyName)  String companyName, @JsonKey(readValue: _readCompanyAddress)  String companyAddress, @JsonKey(readValue: _readCompanyBusiness)  String companyBusiness, @JsonKey(readValue: _readJobCategory)  String jobCategory,  String relJobsNm,  String jobCont,  String receiptCloseDt, @JsonKey(readValue: _readEmploymentName)  String employmentName, @JsonKey(readValue: _readLocation)  String location, @JsonKey(unknownEnumValue: WorkRegion.unknown)  WorkRegion? workRegion,  String workDistrict, @JsonKey(unknownEnumValue: JobEmploymentType.unknown)  JobEmploymentType? employmentType, @JsonKey(readValue: _readCareerDescription)  String careerDescription, @JsonKey(unknownEnumValue: JobEducationLevel.unknown)  JobEducationLevel? educationLevel, @JsonKey(readValue: _readEducationName)  String educationName, @JsonKey(readValue: _readSalaryDescription)  String salaryDescription, @JsonKey(unknownEnumValue: JobSalaryType.unknown)  JobSalaryType? salaryType, @JsonKey(readValue: _readPostingUrl)  String postingUrl,  String collectPsncnt,  String forLang,  String major,  String certificate,  String mltsvcExcHope,  String compAbl,  String pfCond,  String etcPfCond,  String selMthd,  String rcptMthd,  String submitDoc,  String etcHopeCont,  String nearLine,  String workdayWorkhrCont,  String fourIns,  String retirepay,  String etcWelfare,  String disableCvntl,  String attachFileUrl,  List<String> corpAttachList,  List<String> keywordList,  String empChargerDpt,  String contactTelno,  String chargerFaxNo,  DateTime? postedAt,  DateTime? expiresAt, @JsonKey(unknownEnumValue: JobCloseType.unknown)  JobCloseType closeType,  bool isBookmarked,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobPosting() when $default != null:
return $default(_that.id,_that.sourceType,_that.wantedAuthNo,_that.isActive,_that.title,_that.companyName,_that.companyAddress,_that.companyBusiness,_that.jobCategory,_that.relJobsNm,_that.jobCont,_that.receiptCloseDt,_that.employmentName,_that.location,_that.workRegion,_that.workDistrict,_that.employmentType,_that.careerDescription,_that.educationLevel,_that.educationName,_that.salaryDescription,_that.salaryType,_that.postingUrl,_that.collectPsncnt,_that.forLang,_that.major,_that.certificate,_that.mltsvcExcHope,_that.compAbl,_that.pfCond,_that.etcPfCond,_that.selMthd,_that.rcptMthd,_that.submitDoc,_that.etcHopeCont,_that.nearLine,_that.workdayWorkhrCont,_that.fourIns,_that.retirepay,_that.etcWelfare,_that.disableCvntl,_that.attachFileUrl,_that.corpAttachList,_that.keywordList,_that.empChargerDpt,_that.contactTelno,_that.chargerFaxNo,_that.postedAt,_that.expiresAt,_that.closeType,_that.isBookmarked,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(readValue: _readSourceType, unknownEnumValue: JobSourceType.unknown)  JobSourceType sourceType,  String wantedAuthNo,  bool isActive, @JsonKey(readValue: _readTitle)  String title, @JsonKey(readValue: _readCompanyName)  String companyName, @JsonKey(readValue: _readCompanyAddress)  String companyAddress, @JsonKey(readValue: _readCompanyBusiness)  String companyBusiness, @JsonKey(readValue: _readJobCategory)  String jobCategory,  String relJobsNm,  String jobCont,  String receiptCloseDt, @JsonKey(readValue: _readEmploymentName)  String employmentName, @JsonKey(readValue: _readLocation)  String location, @JsonKey(unknownEnumValue: WorkRegion.unknown)  WorkRegion? workRegion,  String workDistrict, @JsonKey(unknownEnumValue: JobEmploymentType.unknown)  JobEmploymentType? employmentType, @JsonKey(readValue: _readCareerDescription)  String careerDescription, @JsonKey(unknownEnumValue: JobEducationLevel.unknown)  JobEducationLevel? educationLevel, @JsonKey(readValue: _readEducationName)  String educationName, @JsonKey(readValue: _readSalaryDescription)  String salaryDescription, @JsonKey(unknownEnumValue: JobSalaryType.unknown)  JobSalaryType? salaryType, @JsonKey(readValue: _readPostingUrl)  String postingUrl,  String collectPsncnt,  String forLang,  String major,  String certificate,  String mltsvcExcHope,  String compAbl,  String pfCond,  String etcPfCond,  String selMthd,  String rcptMthd,  String submitDoc,  String etcHopeCont,  String nearLine,  String workdayWorkhrCont,  String fourIns,  String retirepay,  String etcWelfare,  String disableCvntl,  String attachFileUrl,  List<String> corpAttachList,  List<String> keywordList,  String empChargerDpt,  String contactTelno,  String chargerFaxNo,  DateTime? postedAt,  DateTime? expiresAt, @JsonKey(unknownEnumValue: JobCloseType.unknown)  JobCloseType closeType,  bool isBookmarked,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _JobPosting():
return $default(_that.id,_that.sourceType,_that.wantedAuthNo,_that.isActive,_that.title,_that.companyName,_that.companyAddress,_that.companyBusiness,_that.jobCategory,_that.relJobsNm,_that.jobCont,_that.receiptCloseDt,_that.employmentName,_that.location,_that.workRegion,_that.workDistrict,_that.employmentType,_that.careerDescription,_that.educationLevel,_that.educationName,_that.salaryDescription,_that.salaryType,_that.postingUrl,_that.collectPsncnt,_that.forLang,_that.major,_that.certificate,_that.mltsvcExcHope,_that.compAbl,_that.pfCond,_that.etcPfCond,_that.selMthd,_that.rcptMthd,_that.submitDoc,_that.etcHopeCont,_that.nearLine,_that.workdayWorkhrCont,_that.fourIns,_that.retirepay,_that.etcWelfare,_that.disableCvntl,_that.attachFileUrl,_that.corpAttachList,_that.keywordList,_that.empChargerDpt,_that.contactTelno,_that.chargerFaxNo,_that.postedAt,_that.expiresAt,_that.closeType,_that.isBookmarked,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(readValue: _readSourceType, unknownEnumValue: JobSourceType.unknown)  JobSourceType sourceType,  String wantedAuthNo,  bool isActive, @JsonKey(readValue: _readTitle)  String title, @JsonKey(readValue: _readCompanyName)  String companyName, @JsonKey(readValue: _readCompanyAddress)  String companyAddress, @JsonKey(readValue: _readCompanyBusiness)  String companyBusiness, @JsonKey(readValue: _readJobCategory)  String jobCategory,  String relJobsNm,  String jobCont,  String receiptCloseDt, @JsonKey(readValue: _readEmploymentName)  String employmentName, @JsonKey(readValue: _readLocation)  String location, @JsonKey(unknownEnumValue: WorkRegion.unknown)  WorkRegion? workRegion,  String workDistrict, @JsonKey(unknownEnumValue: JobEmploymentType.unknown)  JobEmploymentType? employmentType, @JsonKey(readValue: _readCareerDescription)  String careerDescription, @JsonKey(unknownEnumValue: JobEducationLevel.unknown)  JobEducationLevel? educationLevel, @JsonKey(readValue: _readEducationName)  String educationName, @JsonKey(readValue: _readSalaryDescription)  String salaryDescription, @JsonKey(unknownEnumValue: JobSalaryType.unknown)  JobSalaryType? salaryType, @JsonKey(readValue: _readPostingUrl)  String postingUrl,  String collectPsncnt,  String forLang,  String major,  String certificate,  String mltsvcExcHope,  String compAbl,  String pfCond,  String etcPfCond,  String selMthd,  String rcptMthd,  String submitDoc,  String etcHopeCont,  String nearLine,  String workdayWorkhrCont,  String fourIns,  String retirepay,  String etcWelfare,  String disableCvntl,  String attachFileUrl,  List<String> corpAttachList,  List<String> keywordList,  String empChargerDpt,  String contactTelno,  String chargerFaxNo,  DateTime? postedAt,  DateTime? expiresAt, @JsonKey(unknownEnumValue: JobCloseType.unknown)  JobCloseType closeType,  bool isBookmarked,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _JobPosting() when $default != null:
return $default(_that.id,_that.sourceType,_that.wantedAuthNo,_that.isActive,_that.title,_that.companyName,_that.companyAddress,_that.companyBusiness,_that.jobCategory,_that.relJobsNm,_that.jobCont,_that.receiptCloseDt,_that.employmentName,_that.location,_that.workRegion,_that.workDistrict,_that.employmentType,_that.careerDescription,_that.educationLevel,_that.educationName,_that.salaryDescription,_that.salaryType,_that.postingUrl,_that.collectPsncnt,_that.forLang,_that.major,_that.certificate,_that.mltsvcExcHope,_that.compAbl,_that.pfCond,_that.etcPfCond,_that.selMthd,_that.rcptMthd,_that.submitDoc,_that.etcHopeCont,_that.nearLine,_that.workdayWorkhrCont,_that.fourIns,_that.retirepay,_that.etcWelfare,_that.disableCvntl,_that.attachFileUrl,_that.corpAttachList,_that.keywordList,_that.empChargerDpt,_that.contactTelno,_that.chargerFaxNo,_that.postedAt,_that.expiresAt,_that.closeType,_that.isBookmarked,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobPosting implements JobPosting {
  const _JobPosting({required this.id, @JsonKey(readValue: _readSourceType, unknownEnumValue: JobSourceType.unknown) this.sourceType = JobSourceType.work24, this.wantedAuthNo = '', this.isActive = true, @JsonKey(readValue: _readTitle) this.title = '?', @JsonKey(readValue: _readCompanyName) this.companyName = '', @JsonKey(readValue: _readCompanyAddress) this.companyAddress = '', @JsonKey(readValue: _readCompanyBusiness) this.companyBusiness = '', @JsonKey(readValue: _readJobCategory) this.jobCategory = '', this.relJobsNm = '', this.jobCont = '', this.receiptCloseDt = '', @JsonKey(readValue: _readEmploymentName) this.employmentName = '', @JsonKey(readValue: _readLocation) this.location = '', @JsonKey(unknownEnumValue: WorkRegion.unknown) this.workRegion, this.workDistrict = '', @JsonKey(unknownEnumValue: JobEmploymentType.unknown) this.employmentType, @JsonKey(readValue: _readCareerDescription) this.careerDescription = '', @JsonKey(unknownEnumValue: JobEducationLevel.unknown) this.educationLevel, @JsonKey(readValue: _readEducationName) this.educationName = '', @JsonKey(readValue: _readSalaryDescription) this.salaryDescription = '', @JsonKey(unknownEnumValue: JobSalaryType.unknown) this.salaryType, @JsonKey(readValue: _readPostingUrl) this.postingUrl = '', this.collectPsncnt = '', this.forLang = '', this.major = '', this.certificate = '', this.mltsvcExcHope = '', this.compAbl = '', this.pfCond = '', this.etcPfCond = '', this.selMthd = '', this.rcptMthd = '', this.submitDoc = '', this.etcHopeCont = '', this.nearLine = '', this.workdayWorkhrCont = '', this.fourIns = '', this.retirepay = '', this.etcWelfare = '', this.disableCvntl = '', this.attachFileUrl = '',  List<String> corpAttachList = const <String>[],  List<String> keywordList = const <String>[], this.empChargerDpt = '', this.contactTelno = '', this.chargerFaxNo = '', this.postedAt, this.expiresAt, @JsonKey(unknownEnumValue: JobCloseType.unknown) this.closeType = JobCloseType.unknown, this.isBookmarked = false, this.createdAt, this.updatedAt}): _corpAttachList = corpAttachList,_keywordList = keywordList;
  factory _JobPosting.fromJson(Map<String, dynamic> json) => _$JobPostingFromJson(json);

@override final  int id;
@override@JsonKey(readValue: _readSourceType, unknownEnumValue: JobSourceType.unknown) final  JobSourceType sourceType;
@override@JsonKey() final  String wantedAuthNo;
@override@JsonKey() final  bool isActive;
@override@JsonKey(readValue: _readTitle) final  String title;
@override@JsonKey(readValue: _readCompanyName) final  String companyName;
@override@JsonKey(readValue: _readCompanyAddress) final  String companyAddress;
@override@JsonKey(readValue: _readCompanyBusiness) final  String companyBusiness;
@override@JsonKey(readValue: _readJobCategory) final  String jobCategory;
@override@JsonKey() final  String relJobsNm;
@override@JsonKey() final  String jobCont;
@override@JsonKey() final  String receiptCloseDt;
@override@JsonKey(readValue: _readEmploymentName) final  String employmentName;
@override@JsonKey(readValue: _readLocation) final  String location;
@override@JsonKey(unknownEnumValue: WorkRegion.unknown) final  WorkRegion? workRegion;
@override@JsonKey() final  String workDistrict;
@override@JsonKey(unknownEnumValue: JobEmploymentType.unknown) final  JobEmploymentType? employmentType;
@override@JsonKey(readValue: _readCareerDescription) final  String careerDescription;
@override@JsonKey(unknownEnumValue: JobEducationLevel.unknown) final  JobEducationLevel? educationLevel;
@override@JsonKey(readValue: _readEducationName) final  String educationName;
@override@JsonKey(readValue: _readSalaryDescription) final  String salaryDescription;
@override@JsonKey(unknownEnumValue: JobSalaryType.unknown) final  JobSalaryType? salaryType;
@override@JsonKey(readValue: _readPostingUrl) final  String postingUrl;
@override@JsonKey() final  String collectPsncnt;
@override@JsonKey() final  String forLang;
@override@JsonKey() final  String major;
@override@JsonKey() final  String certificate;
@override@JsonKey() final  String mltsvcExcHope;
@override@JsonKey() final  String compAbl;
@override@JsonKey() final  String pfCond;
@override@JsonKey() final  String etcPfCond;
@override@JsonKey() final  String selMthd;
@override@JsonKey() final  String rcptMthd;
@override@JsonKey() final  String submitDoc;
@override@JsonKey() final  String etcHopeCont;
@override@JsonKey() final  String nearLine;
@override@JsonKey() final  String workdayWorkhrCont;
@override@JsonKey() final  String fourIns;
@override@JsonKey() final  String retirepay;
@override@JsonKey() final  String etcWelfare;
@override@JsonKey() final  String disableCvntl;
@override@JsonKey() final  String attachFileUrl;
 final  List<String> _corpAttachList;
@override@JsonKey() List<String> get corpAttachList {
  if (_corpAttachList is EqualUnmodifiableListView) return _corpAttachList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_corpAttachList);
}

 final  List<String> _keywordList;
@override@JsonKey() List<String> get keywordList {
  if (_keywordList is EqualUnmodifiableListView) return _keywordList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_keywordList);
}

@override@JsonKey() final  String empChargerDpt;
@override@JsonKey() final  String contactTelno;
@override@JsonKey() final  String chargerFaxNo;
@override final  DateTime? postedAt;
@override final  DateTime? expiresAt;
@override@JsonKey(unknownEnumValue: JobCloseType.unknown) final  JobCloseType closeType;
@override@JsonKey() final  bool isBookmarked;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

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
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobPosting&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&(identical(other.wantedAuthNo, wantedAuthNo) || other.wantedAuthNo == wantedAuthNo)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.title, title) || other.title == title)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.companyAddress, companyAddress) || other.companyAddress == companyAddress)&&(identical(other.companyBusiness, companyBusiness) || other.companyBusiness == companyBusiness)&&(identical(other.jobCategory, jobCategory) || other.jobCategory == jobCategory)&&(identical(other.relJobsNm, relJobsNm) || other.relJobsNm == relJobsNm)&&(identical(other.jobCont, jobCont) || other.jobCont == jobCont)&&(identical(other.receiptCloseDt, receiptCloseDt) || other.receiptCloseDt == receiptCloseDt)&&(identical(other.employmentName, employmentName) || other.employmentName == employmentName)&&(identical(other.location, location) || other.location == location)&&(identical(other.workRegion, workRegion) || other.workRegion == workRegion)&&(identical(other.workDistrict, workDistrict) || other.workDistrict == workDistrict)&&(identical(other.employmentType, employmentType) || other.employmentType == employmentType)&&(identical(other.careerDescription, careerDescription) || other.careerDescription == careerDescription)&&(identical(other.educationLevel, educationLevel) || other.educationLevel == educationLevel)&&(identical(other.educationName, educationName) || other.educationName == educationName)&&(identical(other.salaryDescription, salaryDescription) || other.salaryDescription == salaryDescription)&&(identical(other.salaryType, salaryType) || other.salaryType == salaryType)&&(identical(other.postingUrl, postingUrl) || other.postingUrl == postingUrl)&&(identical(other.collectPsncnt, collectPsncnt) || other.collectPsncnt == collectPsncnt)&&(identical(other.forLang, forLang) || other.forLang == forLang)&&(identical(other.major, major) || other.major == major)&&(identical(other.certificate, certificate) || other.certificate == certificate)&&(identical(other.mltsvcExcHope, mltsvcExcHope) || other.mltsvcExcHope == mltsvcExcHope)&&(identical(other.compAbl, compAbl) || other.compAbl == compAbl)&&(identical(other.pfCond, pfCond) || other.pfCond == pfCond)&&(identical(other.etcPfCond, etcPfCond) || other.etcPfCond == etcPfCond)&&(identical(other.selMthd, selMthd) || other.selMthd == selMthd)&&(identical(other.rcptMthd, rcptMthd) || other.rcptMthd == rcptMthd)&&(identical(other.submitDoc, submitDoc) || other.submitDoc == submitDoc)&&(identical(other.etcHopeCont, etcHopeCont) || other.etcHopeCont == etcHopeCont)&&(identical(other.nearLine, nearLine) || other.nearLine == nearLine)&&(identical(other.workdayWorkhrCont, workdayWorkhrCont) || other.workdayWorkhrCont == workdayWorkhrCont)&&(identical(other.fourIns, fourIns) || other.fourIns == fourIns)&&(identical(other.retirepay, retirepay) || other.retirepay == retirepay)&&(identical(other.etcWelfare, etcWelfare) || other.etcWelfare == etcWelfare)&&(identical(other.disableCvntl, disableCvntl) || other.disableCvntl == disableCvntl)&&(identical(other.attachFileUrl, attachFileUrl) || other.attachFileUrl == attachFileUrl)&&const DeepCollectionEquality().equals(other.corpAttachList, _corpAttachList)&&const DeepCollectionEquality().equals(other.keywordList, _keywordList)&&(identical(other.empChargerDpt, empChargerDpt) || other.empChargerDpt == empChargerDpt)&&(identical(other.contactTelno, contactTelno) || other.contactTelno == contactTelno)&&(identical(other.chargerFaxNo, chargerFaxNo) || other.chargerFaxNo == chargerFaxNo)&&(identical(other.postedAt, postedAt) || other.postedAt == postedAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.closeType, closeType) || other.closeType == closeType)&&(identical(other.isBookmarked, isBookmarked) || other.isBookmarked == isBookmarked)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,sourceType,wantedAuthNo,isActive,title,companyName,companyAddress,companyBusiness,jobCategory,relJobsNm,jobCont,receiptCloseDt,employmentName,location,workRegion,workDistrict,employmentType,careerDescription,educationLevel,educationName,salaryDescription,salaryType,postingUrl,collectPsncnt,forLang,major,certificate,mltsvcExcHope,compAbl,pfCond,etcPfCond,selMthd,rcptMthd,submitDoc,etcHopeCont,nearLine,workdayWorkhrCont,fourIns,retirepay,etcWelfare,disableCvntl,attachFileUrl,const DeepCollectionEquality().hash(_corpAttachList),const DeepCollectionEquality().hash(_keywordList),empChargerDpt,contactTelno,chargerFaxNo,postedAt,expiresAt,closeType,isBookmarked,createdAt,updatedAt]);
}

@override
String toString() {
    return 'JobPosting(id: $id, sourceType: $sourceType, wantedAuthNo: $wantedAuthNo, isActive: $isActive, title: $title, companyName: $companyName, companyAddress: $companyAddress, companyBusiness: $companyBusiness, jobCategory: $jobCategory, relJobsNm: $relJobsNm, jobCont: $jobCont, receiptCloseDt: $receiptCloseDt, employmentName: $employmentName, location: $location, workRegion: $workRegion, workDistrict: $workDistrict, employmentType: $employmentType, careerDescription: $careerDescription, educationLevel: $educationLevel, educationName: $educationName, salaryDescription: $salaryDescription, salaryType: $salaryType, postingUrl: $postingUrl, collectPsncnt: $collectPsncnt, forLang: $forLang, major: $major, certificate: $certificate, mltsvcExcHope: $mltsvcExcHope, compAbl: $compAbl, pfCond: $pfCond, etcPfCond: $etcPfCond, selMthd: $selMthd, rcptMthd: $rcptMthd, submitDoc: $submitDoc, etcHopeCont: $etcHopeCont, nearLine: $nearLine, workdayWorkhrCont: $workdayWorkhrCont, fourIns: $fourIns, retirepay: $retirepay, etcWelfare: $etcWelfare, disableCvntl: $disableCvntl, attachFileUrl: $attachFileUrl, corpAttachList: $corpAttachList, keywordList: $keywordList, empChargerDpt: $empChargerDpt, contactTelno: $contactTelno, chargerFaxNo: $chargerFaxNo, postedAt: $postedAt, expiresAt: $expiresAt, closeType: $closeType, isBookmarked: $isBookmarked, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$JobPostingCopyWith<$Res> implements $JobPostingCopyWith<$Res> {
  factory _$JobPostingCopyWith(_JobPosting value, $Res Function(_JobPosting) _then) = __$JobPostingCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(readValue: _readSourceType, unknownEnumValue: JobSourceType.unknown) JobSourceType sourceType, String wantedAuthNo, bool isActive,@JsonKey(readValue: _readTitle) String title,@JsonKey(readValue: _readCompanyName) String companyName,@JsonKey(readValue: _readCompanyAddress) String companyAddress,@JsonKey(readValue: _readCompanyBusiness) String companyBusiness,@JsonKey(readValue: _readJobCategory) String jobCategory, String relJobsNm, String jobCont, String receiptCloseDt,@JsonKey(readValue: _readEmploymentName) String employmentName,@JsonKey(readValue: _readLocation) String location,@JsonKey(unknownEnumValue: WorkRegion.unknown) WorkRegion? workRegion, String workDistrict,@JsonKey(unknownEnumValue: JobEmploymentType.unknown) JobEmploymentType? employmentType,@JsonKey(readValue: _readCareerDescription) String careerDescription,@JsonKey(unknownEnumValue: JobEducationLevel.unknown) JobEducationLevel? educationLevel,@JsonKey(readValue: _readEducationName) String educationName,@JsonKey(readValue: _readSalaryDescription) String salaryDescription,@JsonKey(unknownEnumValue: JobSalaryType.unknown) JobSalaryType? salaryType,@JsonKey(readValue: _readPostingUrl) String postingUrl, String collectPsncnt, String forLang, String major, String certificate, String mltsvcExcHope, String compAbl, String pfCond, String etcPfCond, String selMthd, String rcptMthd, String submitDoc, String etcHopeCont, String nearLine, String workdayWorkhrCont, String fourIns, String retirepay, String etcWelfare, String disableCvntl, String attachFileUrl, List<String> corpAttachList, List<String> keywordList, String empChargerDpt, String contactTelno, String chargerFaxNo, DateTime? postedAt, DateTime? expiresAt,@JsonKey(unknownEnumValue: JobCloseType.unknown) JobCloseType closeType, bool isBookmarked, DateTime? createdAt, DateTime? updatedAt
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sourceType = null,Object? wantedAuthNo = null,Object? isActive = null,Object? title = null,Object? companyName = null,Object? companyAddress = null,Object? companyBusiness = null,Object? jobCategory = null,Object? relJobsNm = null,Object? jobCont = null,Object? receiptCloseDt = null,Object? employmentName = null,Object? location = null,Object? workRegion = freezed,Object? workDistrict = null,Object? employmentType = freezed,Object? careerDescription = null,Object? educationLevel = freezed,Object? educationName = null,Object? salaryDescription = null,Object? salaryType = freezed,Object? postingUrl = null,Object? collectPsncnt = null,Object? forLang = null,Object? major = null,Object? certificate = null,Object? mltsvcExcHope = null,Object? compAbl = null,Object? pfCond = null,Object? etcPfCond = null,Object? selMthd = null,Object? rcptMthd = null,Object? submitDoc = null,Object? etcHopeCont = null,Object? nearLine = null,Object? workdayWorkhrCont = null,Object? fourIns = null,Object? retirepay = null,Object? etcWelfare = null,Object? disableCvntl = null,Object? attachFileUrl = null,Object? corpAttachList = null,Object? keywordList = null,Object? empChargerDpt = null,Object? contactTelno = null,Object? chargerFaxNo = null,Object? postedAt = freezed,Object? expiresAt = freezed,Object? closeType = null,Object? isBookmarked = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_JobPosting(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,sourceType: null == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as JobSourceType,wantedAuthNo: null == wantedAuthNo ? _self.wantedAuthNo : wantedAuthNo // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,companyAddress: null == companyAddress ? _self.companyAddress : companyAddress // ignore: cast_nullable_to_non_nullable
as String,companyBusiness: null == companyBusiness ? _self.companyBusiness : companyBusiness // ignore: cast_nullable_to_non_nullable
as String,jobCategory: null == jobCategory ? _self.jobCategory : jobCategory // ignore: cast_nullable_to_non_nullable
as String,relJobsNm: null == relJobsNm ? _self.relJobsNm : relJobsNm // ignore: cast_nullable_to_non_nullable
as String,jobCont: null == jobCont ? _self.jobCont : jobCont // ignore: cast_nullable_to_non_nullable
as String,receiptCloseDt: null == receiptCloseDt ? _self.receiptCloseDt : receiptCloseDt // ignore: cast_nullable_to_non_nullable
as String,employmentName: null == employmentName ? _self.employmentName : employmentName // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,workRegion: freezed == workRegion ? _self.workRegion : workRegion // ignore: cast_nullable_to_non_nullable
as WorkRegion?,workDistrict: null == workDistrict ? _self.workDistrict : workDistrict // ignore: cast_nullable_to_non_nullable
as String,employmentType: freezed == employmentType ? _self.employmentType : employmentType // ignore: cast_nullable_to_non_nullable
as JobEmploymentType?,careerDescription: null == careerDescription ? _self.careerDescription : careerDescription // ignore: cast_nullable_to_non_nullable
as String,educationLevel: freezed == educationLevel ? _self.educationLevel : educationLevel // ignore: cast_nullable_to_non_nullable
as JobEducationLevel?,educationName: null == educationName ? _self.educationName : educationName // ignore: cast_nullable_to_non_nullable
as String,salaryDescription: null == salaryDescription ? _self.salaryDescription : salaryDescription // ignore: cast_nullable_to_non_nullable
as String,salaryType: freezed == salaryType ? _self.salaryType : salaryType // ignore: cast_nullable_to_non_nullable
as JobSalaryType?,postingUrl: null == postingUrl ? _self.postingUrl : postingUrl // ignore: cast_nullable_to_non_nullable
as String,collectPsncnt: null == collectPsncnt ? _self.collectPsncnt : collectPsncnt // ignore: cast_nullable_to_non_nullable
as String,forLang: null == forLang ? _self.forLang : forLang // ignore: cast_nullable_to_non_nullable
as String,major: null == major ? _self.major : major // ignore: cast_nullable_to_non_nullable
as String,certificate: null == certificate ? _self.certificate : certificate // ignore: cast_nullable_to_non_nullable
as String,mltsvcExcHope: null == mltsvcExcHope ? _self.mltsvcExcHope : mltsvcExcHope // ignore: cast_nullable_to_non_nullable
as String,compAbl: null == compAbl ? _self.compAbl : compAbl // ignore: cast_nullable_to_non_nullable
as String,pfCond: null == pfCond ? _self.pfCond : pfCond // ignore: cast_nullable_to_non_nullable
as String,etcPfCond: null == etcPfCond ? _self.etcPfCond : etcPfCond // ignore: cast_nullable_to_non_nullable
as String,selMthd: null == selMthd ? _self.selMthd : selMthd // ignore: cast_nullable_to_non_nullable
as String,rcptMthd: null == rcptMthd ? _self.rcptMthd : rcptMthd // ignore: cast_nullable_to_non_nullable
as String,submitDoc: null == submitDoc ? _self.submitDoc : submitDoc // ignore: cast_nullable_to_non_nullable
as String,etcHopeCont: null == etcHopeCont ? _self.etcHopeCont : etcHopeCont // ignore: cast_nullable_to_non_nullable
as String,nearLine: null == nearLine ? _self.nearLine : nearLine // ignore: cast_nullable_to_non_nullable
as String,workdayWorkhrCont: null == workdayWorkhrCont ? _self.workdayWorkhrCont : workdayWorkhrCont // ignore: cast_nullable_to_non_nullable
as String,fourIns: null == fourIns ? _self.fourIns : fourIns // ignore: cast_nullable_to_non_nullable
as String,retirepay: null == retirepay ? _self.retirepay : retirepay // ignore: cast_nullable_to_non_nullable
as String,etcWelfare: null == etcWelfare ? _self.etcWelfare : etcWelfare // ignore: cast_nullable_to_non_nullable
as String,disableCvntl: null == disableCvntl ? _self.disableCvntl : disableCvntl // ignore: cast_nullable_to_non_nullable
as String,attachFileUrl: null == attachFileUrl ? _self.attachFileUrl : attachFileUrl // ignore: cast_nullable_to_non_nullable
as String,corpAttachList: null == corpAttachList ? _self._corpAttachList : corpAttachList // ignore: cast_nullable_to_non_nullable
as List<String>,keywordList: null == keywordList ? _self._keywordList : keywordList // ignore: cast_nullable_to_non_nullable
as List<String>,empChargerDpt: null == empChargerDpt ? _self.empChargerDpt : empChargerDpt // ignore: cast_nullable_to_non_nullable
as String,contactTelno: null == contactTelno ? _self.contactTelno : contactTelno // ignore: cast_nullable_to_non_nullable
as String,chargerFaxNo: null == chargerFaxNo ? _self.chargerFaxNo : chargerFaxNo // ignore: cast_nullable_to_non_nullable
as String,postedAt: freezed == postedAt ? _self.postedAt : postedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,closeType: null == closeType ? _self.closeType : closeType // ignore: cast_nullable_to_non_nullable
as JobCloseType,isBookmarked: null == isBookmarked ? _self.isBookmarked : isBookmarked // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
