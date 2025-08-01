import 'package:duty_it/app/modules/home/models/sorting_type.dart';
import 'package:get/get.dart';

class SortingModalController extends GetxController {
  final Rx<SortingType> _selectedType = SortingType("최신 등록순", "최신순").obs;
  SortingType get selectedType => _selectedType.value;
  set selectedType(t) => _selectedType.value = t;

  List<SortingType> getSortingTypes() {
    return [
      SortingType("최신 등록순", "최신순"),
      SortingType("인기순", "인기순"),
      SortingType("행사 날짜 임박순", "날짜 임박순"),
      SortingType("모집 마감 임박순", "마감 임박순"),
    ];
  }
}