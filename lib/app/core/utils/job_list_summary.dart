/// Short labels used by the web and app job cards.
class JobListSummary {
  JobListSummary._();

  static const _regions = <String, String>{
    '서울특별시': '서울',
    '부산광역시': '부산',
    '대구광역시': '대구',
    '인천광역시': '인천',
    '광주광역시': '광주',
    '대전광역시': '대전',
    '울산광역시': '울산',
    '세종특별자치시': '세종',
    '경기도': '경기',
    '강원도': '강원',
    '강원특별자치도': '강원',
    '충청북도': '충북',
    '충청남도': '충남',
    '전라북도': '전북',
    '전북특별자치도': '전북',
    '전라남도': '전남',
    '경상북도': '경북',
    '경상남도': '경남',
    '제주특별자치도': '제주',
  };

  static String location(String value) {
    final address = _clean(
      value,
    ).replaceFirst(RegExp(r'^(?:\(\d{5}\)|\d{5})\s*'), '');
    if (address.isEmpty) return '근무지 미정';

    final parts = address.split(' ');
    final region = parts.first;
    final district = parts.length > 1 ? parts[1] : '';
    final shortRegion =
        _regions[region] ??
        (_regions.values.contains(region) ||
                RegExp(r'(?:특별시|광역시|자치시|자치도|[시도])$').hasMatch(region)
            ? region
            : null);
    if (shortRegion == null) return address;
    if (RegExp(r'^[가-힣]+[시군구]$').hasMatch(district)) {
      return '$shortRegion $district';
    }
    return shortRegion == '세종' ? shortRegion : address;
  }

  static String career(String value) {
    final cleaned = _clean(value);
    if (cleaned.isEmpty) return '경력 정보 미등록';
    if (RegExp(r'^(관계없음|경력\s*무관|무관)$').hasMatch(cleaned)) {
      return '경력무관';
    }
    return cleaned
        .replaceAllMapped(
          RegExp(r'\(최소\s*(\d+)\s*(년|개월)\)'),
          (match) => '${match[1]}${match[2]} 이상',
        )
        .replaceAll(RegExp(r'[()]'), '');
  }

  static String salary(String value) {
    var cleaned = _clean(value).replaceFirst(RegExp(r'[,，]\s*$'), '');
    if (cleaned.isEmpty) return '급여 정보 미등록';

    const periods = {'월급': '월', '연봉': '연', '시급': '시', '일급': '일'};
    cleaned = cleaned.replaceFirstMapped(
      RegExp(r'^(월급|연봉|시급|일급)\s*'),
      (match) => '${periods[match[1]]} ',
    );
    cleaned = cleaned.replaceAllMapped(
      RegExp(r'(?:\d{1,3}(?:,\d{3})+|\d+)\s*원'),
      (match) {
        final won = int.parse(match[0]!.replaceAll(RegExp(r'[^\d]'), ''));
        if (won < 100000) return '${_commas(won)}원';
        final amount = won / 10000;
        final text = amount == amount.roundToDouble()
            ? amount.toInt().toString()
            : amount
                  .toStringAsFixed(4)
                  .replaceFirst(RegExp(r'0+$'), '')
                  .replaceFirst(RegExp(r'\.$'), '');
        return '${_commasInDecimal(text)}만원';
      },
    );
    return cleaned.replaceAllMapped(
      RegExp(r'([\d,.]+)(만원|원) 이상\s*~\s*([\d,.]+)\2 이하'),
      (match) => match[1] == match[3]
          ? '${match[1]}${match[2]}'
          : '${match[1]}~${match[3]}${match[2]}',
    );
  }

  static String _clean(String value) =>
      value.replaceAll(RegExp(r'\s+'), ' ').trim();

  static String _commas(int value) => _commasInDecimal(value.toString());

  static String _commasInDecimal(String value) {
    final parts = value.split('.');
    final digits = parts.first;
    final withCommas = digits.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => ',',
    );
    return parts.length == 1 ? withCommas : '$withCommas.${parts.last}';
  }
}
