// Resolve offset-free wire values before DateTime.parse can normalize them
// across a DST gap in the device's own time zone.
final _timeSeparator = RegExp('[Tt ]');
final _zoneSuffix = RegExp(r'(?:[zZ]|[+-]\d{2}(?::?\d{2})?)$');

DateTime? parseEventTimestamp(String? raw) {
  if (raw == null) return null;
  final input = raw.contains(_timeSeparator) ? raw : '${raw}T00:00:00';
  return DateTime.parse(_zoneSuffix.hasMatch(input) ? input : '$input+09:00');
}

// The event API uses Korean wall time when it omits an offset. Dart parses
// explicit offsets as UTC instants; device-local offsets must not be applied
// to the fields of an offset-free event.
extension EventTime on DateTime {
  static const _seoulOffset = Duration(hours: 9);

  /// Calendar components for display/comparison only, independent of device DST.
  DateTime get seoulWallTime => isUtc
      ? add(_seoulOffset)
      : DateTime.utc(
          year,
          month,
          day,
          hour,
          minute,
          second,
          millisecond,
          microsecond,
        );

  /// The actual instant to pass to the native calendar.
  DateTime get eventInstantUtc =>
      isUtc ? this : seoulWallTime.subtract(_seoulOffset);
}
