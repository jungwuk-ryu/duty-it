import 'package:duty_it/app/core/enums/event_type.dart';
import 'package:duty_it/app/core/models/host.dart';

enum NotificationSubscriptionType {
  eventKeyword('EVENT_KEYWORD'),
  eventHost('EVENT_HOST'),
  eventType('EVENT_TYPE'),
  jobKeyword('JOB_KEYWORD'),
  jobCompany('JOB_COMPANY');

  final String serverValue;

  const NotificationSubscriptionType(this.serverValue);

  bool get isEvent =>
      this == eventKeyword || this == eventHost || this == eventType;

  bool get isJob => this == jobKeyword || this == jobCompany;

  static NotificationSubscriptionType? fromServerValue(String? value) {
    for (final type in values) {
      if (type.serverValue == value) return type;
    }
    return null;
  }
}

class NotificationCompany {
  final int id;
  final String name;

  const NotificationCompany({required this.id, required this.name});

  factory NotificationCompany.fromJson(Map<String, dynamic> json) {
    final idValue = json['id'];
    final nameValue = json['name'] ?? json['corpNm'];

    return NotificationCompany(
      id: idValue is num ? idValue.toInt() : 0,
      name: nameValue?.toString().trim().isNotEmpty == true
          ? nameValue.toString()
          : '회사명 없음',
    );
  }
}

class NotificationSubscription {
  final int id;
  final NotificationSubscriptionType type;
  final String? keyword;
  final Host? host;
  final EventType? eventType;
  final NotificationCompany? company;
  final DateTime? createdAt;

  const NotificationSubscription({
    required this.id,
    required this.type,
    this.keyword,
    this.host,
    this.eventType,
    this.company,
    this.createdAt,
  });

  factory NotificationSubscription.fromJson(Map<String, dynamic> json) {
    final type = NotificationSubscriptionType.fromServerValue(
      json['type']?.toString(),
    );
    if (type == null) {
      throw FormatException('Unknown subscription type: ${json['type']}');
    }

    final hostJson = json['host'];
    final companyJson = json['company'];
    final eventTypeName = json['eventType']?.toString();

    return NotificationSubscription(
      id: (json['id'] as num).toInt(),
      type: type,
      keyword: json['keyword']?.toString(),
      host: hostJson is Map
          ? Host.fromJson(Map<String, dynamic>.from(hostJson))
          : null,
      eventType: eventTypeName == null
          ? null
          : EventType.values.firstWhere(
              (e) => e.name == eventTypeName,
              orElse: () => EventType.ETC,
            ),
      company: companyJson is Map
          ? NotificationCompany.fromJson(Map<String, dynamic>.from(companyJson))
          : null,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
    );
  }

  NotificationSubscriptionDraft toDraft() {
    return NotificationSubscriptionDraft(
      type: type,
      keyword: keyword,
      host: host,
      eventType: eventType,
      company: company,
    );
  }
}

class NotificationSubscriptionDraft {
  final NotificationSubscriptionType type;
  final String? keyword;
  final Host? host;
  final EventType? eventType;
  final NotificationCompany? company;

  const NotificationSubscriptionDraft({
    required this.type,
    this.keyword,
    this.host,
    this.eventType,
    this.company,
  });

  String get key {
    return switch (type) {
      NotificationSubscriptionType.eventKeyword ||
      NotificationSubscriptionType.jobKeyword =>
        '${type.serverValue}:${keyword?.trim().toLowerCase() ?? ''}',
      NotificationSubscriptionType.eventHost =>
        '${type.serverValue}:${host?.id ?? 0}',
      NotificationSubscriptionType.eventType =>
        '${type.serverValue}:${eventType?.name ?? ''}',
      NotificationSubscriptionType.jobCompany =>
        '${type.serverValue}:${company?.id ?? 0}',
    };
  }

  String get label {
    return switch (type) {
      NotificationSubscriptionType.eventKeyword ||
      NotificationSubscriptionType.jobKeyword =>
        keyword?.trim().isNotEmpty == true ? keyword!.trim() : '키워드 없음',
      NotificationSubscriptionType.eventHost => host?.name ?? '주최 없음',
      NotificationSubscriptionType.eventType => eventType?.displayName ?? '기타',
      NotificationSubscriptionType.jobCompany => company?.name ?? '회사 없음',
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'type': type.serverValue,
      if (keyword?.trim().isNotEmpty == true) 'keyword': keyword!.trim(),
      if (host != null) 'hostId': host!.id,
      if (eventType != null) 'eventType': eventType!.name,
      if (company != null) 'companyId': company!.id,
    };
  }
}
