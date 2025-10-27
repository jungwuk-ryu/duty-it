import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/modules/notifications/models/app_notification.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class NotificationsViewController extends GetxController {
  ApiClient get _apiClient => Get.find<ApiClient>();

  final Rx<PagingState<int, AppNotification>> _pagingState =
      PagingState<int, AppNotification>().obs;
  PagingState<int, AppNotification> get pagingState => _pagingState.value;
  set pagingState(PagingState<int, AppNotification> state) =>
      _pagingState.value = state;

  Future<void> fetchNotificationList() async {
    
    pagingState = pagingState.copyWith(isLoading: true);

    final int nextKey = (pagingState.keys?.last ?? -1) + 1;
    RequestResult reqResult = await _apiClient.getNotificationList(nextKey);
    if (reqResult is RequestFail) {
      pagingState = pagingState.copyWith(
        isLoading: false,
        error: reqResult.serverFail,
      );
    }

    List<AppNotification> notiList =
        (reqResult as RequestSuccess<List<AppNotification>>).data;
    pagingState = pagingState.copyWith(
      isLoading: false,
      pages: [...pagingState.pages ?? [], notiList],
      keys: [...pagingState.keys ?? [], nextKey],
      hasNextPage: notiList.isNotEmpty,
    );

    markAllAsRead();
  }

  Future<bool> markAllAsRead() async {
    RequestResult rst = await _apiClient.readAllNotification();
    bool success = !(rst is RequestFail || (rst is RequestSuccess && rst.data == false)); 
    
    return success;
  }
}
