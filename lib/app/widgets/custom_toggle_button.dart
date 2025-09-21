import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';

class CustomToggleButton extends StatefulWidget {
  final bool checked;
  final Function() onTap;
  final bool enabled;

  const CustomToggleButton({
    super.key,
    required this.checked,
    required this.onTap,
    this.enabled = true,
  });

  @override
  State<CustomToggleButton> createState() => _CustomToggleButtonState();
}

class _CustomToggleButtonState extends State<CustomToggleButton> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (loading) return;
        setState(() {
          loading = true;  
        });

        try {
          await widget.onTap();
        } catch (e, st) {
          FirebaseCrashlytics.instance.recordError(e, st, fatal: false);
        } finally {
          if (mounted) {
            setState(() {
            loading = false;
          });
          }
        }
      },
      child: Container(
        width: 44,
        height: 22,
        padding: EdgeInsets.symmetric(horizontal: 1),
        decoration: ShapeDecoration(
          color: widget.enabled
              ? (widget.checked ? AppColors.main : AppColors.g05)
              : AppColors.g02,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.50),
          ),
        ),
        child: Row(
          mainAxisAlignment: widget.checked
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Container(
              width: 20,
              height: 20,
              padding: EdgeInsets.all(4),
              decoration: ShapeDecoration(
                color: AppColors.white,
                shape: OvalBorder(),
              ),
              child: Center(
                child: Visibility(
                  visible: loading,
                  child: CupertinoActivityIndicator(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
