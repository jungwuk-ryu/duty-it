import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'cursor_page_info.freezed.dart';
part 'cursor_page_info.g.dart';

CursorPageInfo cursorPageInfoFromJson(String str) =>
    CursorPageInfo.fromJson(json.decode(str));

String cursorPageInfoToJson(CursorPageInfo data) => json.encode(data.toJson());

@freezed
abstract class CursorPageInfo with _$CursorPageInfo {
  const factory CursorPageInfo({
    required bool hasNext,
    required String? nextCursor,
    required int pageSize,
  }) = _CursorPageInfo;

  factory CursorPageInfo.fromJson(Map<String, dynamic> json) =>
      _$CursorPageInfoFromJson(json);
}
