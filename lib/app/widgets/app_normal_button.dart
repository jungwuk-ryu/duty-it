import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/widgets/tap_scale.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class AppNormalButton extends StatefulWidget {
  final String text;
  final Function() onTap;
  final Color? color;

  const AppNormalButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color,
  });

  @override
  State<AppNormalButton> createState() => _AppNormalButtonState();
}

class _AppNormalButtonState extends State<AppNormalButton> {
  bool isCallbackRunning = false;

  @override
  Widget build(BuildContext context) {
    return TapScale(
      child: GestureDetector(
        onTap: tap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: widget.color ?? AppColors.main,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            widget.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.20,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> tap() async {
    if (isCallbackRunning) return;
    isCallbackRunning = true;

    try {
      await widget.onTap();
    } catch (e, st) {
      if (kDebugMode) {
        print("앱 버튼 클릭 callback 실행 중 오류 발생: $e\n$st");
      }

      AppUtils.showSnackBar('오류가 발생했어요. 다시 시도해주세요\n');
      FirebaseCrashlytics.instance.recordError(
        e,
        st,
        reason: "앱 버튼 클릭 callback 실행 중 오류 발생",
      );
    } finally {
      isCallbackRunning = false;
    }
  }
}
