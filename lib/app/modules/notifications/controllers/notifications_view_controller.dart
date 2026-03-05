import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/modules/notifications/models/app_notification.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class NotificationsViewController extends GetxController {
  ApiClient get _apiClient => Get.find<ApiClient>();
  bool _didMarkAllAsRead = false;

  final Rx<PagingState<int, AppNotification>> _pagingState =
      PagingState<int, AppNotification>().obs;
  PagingState<int, AppNotification> get pagingState => _pagingState.value;
  set pagingState(PagingState<int, AppNotification> state) =>
      _pagingState.value = state;

  @override
  void onInit() {
    super.onInit();

    bool isMarkingAllAsRead = false;
    _pagingState.listen((state) async {
      if (_didMarkAllAsRead) return;
      if ((state.pages?.isNotEmpty ?? false) && !isMarkingAllAsRead) {
        isMarkingAllAsRead = true;

        try {
          _didMarkAllAsRead = await markAllAsRead();
        } finally {
          isMarkingAllAsRead = false;
        }
      }
    });

    fetchNotificationList();
  }

  Future<void> refreshNotificationList() async {
    await fetchNotificationList(clearPage: true);
  }

  Future<void> fetchNotificationList({bool clearPage = false}) async {
    if (!clearPage && pagingState.isLoading) return;

    final PagingState<int, AppNotification> baseState = clearPage
        ? PagingState<int, AppNotification>()
        : pagingState;
    pagingState = baseState.copyWith(isLoading: true, error: null);

    final int nextKey = (baseState.keys?.last ?? -1) + 1;
    RequestResult reqResult = await _apiClient.getNotificationList(nextKey);
    if (reqResult is RequestFail) {
      pagingState = pagingState.copyWith(
        isLoading: false,
        error: reqResult.serverFail,
      );

      return;
    }

    List<AppNotification> notiList =
        (reqResult as RequestSuccess<List<AppNotification>>).data;
    pagingState = pagingState.copyWith(
      isLoading: false,
      pages: [...baseState.pages ?? [], notiList],
      keys: [...baseState.keys ?? [], nextKey],
      hasNextPage: notiList.isNotEmpty,
    );
  }

  Future<bool> markAllAsRead() async {
    RequestResult rst = await _apiClient.readAllNotification();
    bool success =
        !(rst is RequestFail || (rst is RequestSuccess && rst.data == false));

    return success;
  }

  Future<bool> deleteNotification(int id) async {
    RequestResult rst = await _apiClient.deleteNotification(id);
    bool success =
        !(rst is RequestFail || (rst is RequestSuccess && rst.data == false));
    return success;
  }
}
