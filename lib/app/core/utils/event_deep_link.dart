/// Event detail links shared by the website, iOS, and Android.
/// Unmarked /visitEvent links retain their organizer-page behavior in main.dart.
int? eventIdFromDeepLink(Uri uri) {
  if (uri.userInfo.isNotEmpty) return null;
  final segments = uri.pathSegments.toList();
  if (segments.isNotEmpty && segments.last.isEmpty) segments.removeLast();

  String? value;
  if (uri.scheme == 'https' &&
      uri.host.toLowerCase() == 'www.dutyit.net' &&
      (!uri.hasPort || uri.port == 443) &&
      segments.length == 2 &&
      (segments.first == 'events' ||
          (segments.first == 'visitEvent' &&
              uri.queryParametersAll['openIn']?.length == 1 &&
              uri.queryParameters['openIn'] == 'app'))) {
    value = segments[1];
  } else if (uri.scheme == 'dutyit' &&
      uri.host == 'events' &&
      !uri.hasPort &&
      segments.length == 1) {
    value = segments.single;
  }

  if (value == null || !RegExp(r'^\d+$').hasMatch(value)) return null;
  final id = int.tryParse(value);
  // Keep IDs compatible with the website's positive safe-integer validation.
  return id != null && id > 0 && id <= 9007199254740991 ? id : null;
}
