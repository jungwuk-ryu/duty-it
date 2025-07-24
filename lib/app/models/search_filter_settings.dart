import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_filter_settings.freezed.dart';
part 'search_filter_settings.g.dart';

@freezed
abstract class SearchFilter with _$SearchFilterSettings {
  const factory SearchFilter({
    @Default(<String>{}) Set<String> categories,
    String? host,
    @Default(true) bool showEnded,
  }) = _SearchFilterSettings;

  factory SearchFilter.fromJson(Map<String, Object?> json) =>
      _$SearchFilterSettingsFromJson(json);
}
