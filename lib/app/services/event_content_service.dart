import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

enum EventContentAvailability { available, unavailable, failed }

class EventContentResult {
  final EventContentAvailability availability;
  final String? body;

  const EventContentResult._(this.availability, this.body);

  const EventContentResult.available(String body)
    : this._(EventContentAvailability.available, body);
  const EventContentResult.unavailable()
    : this._(EventContentAvailability.unavailable, null);
  const EventContentResult.failed()
    : this._(EventContentAvailability.failed, null);
}

class EventContentService {
  final http.Client _client;
  final bool _ownsClient;
  final Uri _baseUri;

  EventContentService({http.Client? client, Uri? baseUri})
    : _client = client ?? http.Client(),
      _ownsClient = client == null,
      _baseUri = baseUri ?? Uri.parse('https://surfer.dutyit.net');

  Future<EventContentResult> fetch(int eventId) async {
    if (eventId <= 0) return const EventContentResult.failed();

    try {
      final response = await _client
          .get(
            _baseUri.resolve('/api/v1/public/duit-events/$eventId/content'),
            headers: const {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) return const EventContentResult.failed();

      final payload = jsonDecode(utf8.decode(response.bodyBytes));
      if (payload is! Map<String, dynamic> ||
          payload['schemaVersion'] != 'duit-event-content-api.v1' ||
          payload['eventId'] != eventId.toString()) {
        return const EventContentResult.failed();
      }

      final content = payload['content'];
      if (payload['availability'] == 'unavailable' && content == null) {
        return const EventContentResult.unavailable();
      }
      if (payload['availability'] != 'available' ||
          content is! Map<String, dynamic> ||
          content['format'] != 'text/plain' ||
          content['language'] != 'ko') {
        return const EventContentResult.failed();
      }

      final body = content['body'];
      if (body is! String || body.trim().isEmpty) {
        return const EventContentResult.failed();
      }
      return EventContentResult.available(body.trim());
    } catch (_) {
      return const EventContentResult.failed();
    }
  }

  void close() {
    if (_ownsClient) _client.close();
  }
}
