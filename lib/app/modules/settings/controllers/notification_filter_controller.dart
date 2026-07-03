import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/enums/event_type.dart';
import 'package:duty_it/app/core/enums/sort_direction.dart';
import 'package:duty_it/app/core/models/host.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/modules/search_filter/widgets/host_selection_bottom_modal.dart';
import 'package:duty_it/app/modules/settings/models/notification_subscription.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

enum NotificationFilterMode {
  event,
  job;

  String get title => switch (this) {
    event => '행사공고 맞춤 알림',
    job => '채용공고 맞춤 알림',
  };

  String get keywordHint => switch (this) {
    event => '예: 보수교육, 컨퍼런스',
    job => '예: 간호사, 조무사',
  };
}

class NotificationFilterController extends GetxController {
  final TextEditingController keywordController = TextEditingController();
  final TextEditingController targetSearchController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxMap<String, NotificationSubscriptionDraft> drafts =
      <String, NotificationSubscriptionDraft>{}.obs;
  final RxList<NotificationCompany> companies = <NotificationCompany>[].obs;
  final RxString targetQuery = ''.obs;

  final Map<String, NotificationSubscription> _existingSubscriptions =
      <String, NotificationSubscription>{};

  ApiClient get api => Get.find<ApiClient>();

  late final NotificationFilterMode mode;

  bool get isEventMode => mode == NotificationFilterMode.event;

  List<EventType> get eventTypes => EventType.values;

  List<NotificationCompany> get filteredCompanies {
    final query = targetQuery.value.trim().toLowerCase();
    if (query.isEmpty) return companies;

    return companies
        .where((company) => company.name.toLowerCase().contains(query))
        .toList();
  }

  @override
  void onInit() {
    super.onInit();

    mode = Get.arguments is NotificationFilterMode
        ? Get.arguments as NotificationFilterMode
        : NotificationFilterMode.event;

    targetSearchController.addListener(() {
      targetQuery.value = targetSearchController.text;
    });
  }

  @override
  void onReady() {
    super.onReady();
    load();
  }

  @override
  void onClose() {
    keywordController.dispose();
    targetSearchController.dispose();
    super.onClose();
  }

  Future<void> load() async {
    isLoading.value = true;
    try {
      await _fetchSubscriptions();
      if (!isEventMode) {
        await _fetchCompanies();
      }
    } finally {
      isLoading.value = false;
    }
  }

  void addKeyword() {
    final keyword = keywordController.text.trim();
    if (keyword.isEmpty) return;
    if (keyword.length > 50) {
      AppUtils.showSnackBar('키워드는 50자 이내로 입력해 주세요.');
      return;
    }

    final draft = NotificationSubscriptionDraft(
      type: isEventMode
          ? NotificationSubscriptionType.eventKeyword
          : NotificationSubscriptionType.jobKeyword,
      keyword: keyword,
    );

    drafts[draft.key] = draft;
    keywordController.clear();
    HapticFeedback.lightImpact();
  }

  void removeDraft(String key) {
    drafts.remove(key);
    HapticFeedback.lightImpact();
  }

  bool isEventTypeSelected(EventType eventType) {
    return drafts.containsKey(
      NotificationSubscriptionDraft(
        type: NotificationSubscriptionType.eventType,
        eventType: eventType,
      ).key,
    );
  }

  void toggleEventType(EventType eventType) {
    final draft = NotificationSubscriptionDraft(
      type: NotificationSubscriptionType.eventType,
      eventType: eventType,
    );
    _toggleDraft(draft);
  }

  bool isHostSelected(Host host) {
    return drafts.containsKey(
      NotificationSubscriptionDraft(
        type: NotificationSubscriptionType.eventHost,
        host: host,
      ).key,
    );
  }

  void toggleHost(Host host) {
    final draft = NotificationSubscriptionDraft(
      type: NotificationSubscriptionType.eventHost,
      host: host,
    );
    _toggleDraft(draft);
  }

  void showHostSelectionBottomModal() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => HostSelectionBottomModal(
        onHostSelected: toggleHost,
        isSelected: isHostSelected,
        sortDirection: SortDirection.ASC,
        field: 'NAME',
      ),
    );
  }

  bool isCompanySelected(NotificationCompany company) {
    return drafts.containsKey(
      NotificationSubscriptionDraft(
        type: NotificationSubscriptionType.jobCompany,
        company: company,
      ).key,
    );
  }

  void toggleCompany(NotificationCompany company) {
    final draft = NotificationSubscriptionDraft(
      type: NotificationSubscriptionType.jobCompany,
      company: company,
    );
    _toggleDraft(draft);
  }

  void resetDrafts() {
    drafts.clear();
    keywordController.clear();
    targetSearchController.clear();
  }

  Future<void> apply() async {
    if (isSaving.value) return;
    isSaving.value = true;

    try {
      final desiredKeys = drafts.keys.toSet();
      final existingKeys = _existingSubscriptions.keys.toSet();

      for (final key in desiredKeys.difference(existingKeys)) {
        final draft = drafts[key];
        if (draft == null) continue;

        final result = await api.createSubscription(draft);
        if (result is RequestFail) {
          AppUtils.showSnackBar(
            result.serverFail?.message ?? '맞춤 알림 조건을 저장하지 못했어요.',
          );
          return;
        }
      }

      for (final key in existingKeys.difference(desiredKeys)) {
        final subscription = _existingSubscriptions[key];
        if (subscription == null) continue;

        final result = await api.deleteSubscription(subscription.id);
        if (result is RequestFail) {
          AppUtils.showSnackBar(
            result.serverFail?.message ?? '맞춤 알림 조건을 삭제하지 못했어요.',
          );
          await _fetchSubscriptions();
          return;
        }
      }

      Get.back(result: true);
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> _fetchSubscriptions() async {
    final result = await api.getSubscriptions();
    if (result is RequestFail) {
      AppUtils.showSnackBar(
        result.serverFail?.message ?? '맞춤 알림 조건을 불러오지 못했어요.',
      );
      return;
    }

    final all = (result as RequestSuccess<List<NotificationSubscription>>).data;
    final filtered = all.where((subscription) {
      return isEventMode ? subscription.type.isEvent : subscription.type.isJob;
    }).toList();

    _existingSubscriptions
      ..clear()
      ..addEntries(
        filtered.map((subscription) {
          final draft = subscription.toDraft();
          return MapEntry(draft.key, subscription);
        }),
      );

    drafts.assignAll(
      Map.fromEntries(
        _existingSubscriptions.values.map((subscription) {
          final draft = subscription.toDraft();
          return MapEntry(draft.key, draft);
        }),
      ),
    );
  }

  Future<void> _fetchCompanies() async {
    final result = await api.getBookmarkedCompanies();
    if (result is RequestFail) {
      AppUtils.showSnackBar(result.serverFail?.message ?? '회사 목록을 불러오지 못했어요.');
      return;
    }

    companies.assignAll(
      (result as RequestSuccess<List<NotificationCompany>>).data,
    );
  }

  void _toggleDraft(NotificationSubscriptionDraft draft) {
    if (drafts.containsKey(draft.key)) {
      drafts.remove(draft.key);
    } else {
      drafts[draft.key] = draft;
    }

    HapticFeedback.lightImpact();
  }
}
