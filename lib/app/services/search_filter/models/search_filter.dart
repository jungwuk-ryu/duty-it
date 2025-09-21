import 'package:duty_it/app/models/host.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_filter.freezed.dart';
part 'search_filter.g.dart';

@freezed
abstract class SearchFilter with _$SearchFilter {
  const factory SearchFilter({
    @Default(<String>{}) Set<String> categories,
    Host? host,
    @Default(true) bool showEnded,
  }) = _SearchFilter;

  factory SearchFilter.fromJson(Map<String, Object?> json) =>
      _$SearchFilterFromJson(json);
}
