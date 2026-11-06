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
