import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:myapp/app/core/constants/app_colors.dart';
import 'package:myapp/app/modules/account/controllers/account_view_controller.dart';
import 'package:myapp/gen/assets.gen.dart';

class AccountBottomModal extends StatefulWidget {
  const AccountBottomModal({super.key});

  @override
  State<AccountBottomModal> createState() => _AccountBottomModalState();
}

class _AccountBottomModalState extends State<AccountBottomModal> {
  late final TextEditingController editingController;

  final int _maxLen = 10;
  int _txtLen = 0;

  @override
  void initState() {
    super.initState();

    String username = Get.find<AccountViewController>().getUserName();
    editingController = TextEditingController(text: username);
    editingController.addListener(() => _onTextChanged());
    _txtLen = username.length;
  }

  @override
  void dispose() {
    editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 17.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 16.h),
          Text(
            "닉네임 수정",
            style: TextStyle(
              height: 1.60,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  controller: editingController,
                  autofocus: true,
                  maxLength: _maxLen,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => onSubmitted(),
                  decoration:
                      InputDecoration.collapsed(
                        hintText: "닉네임 입력",
                        hintStyle: TextStyle(color: AppColors.g05),
                      ).copyWith(
                        counterText: '', // 이 줄이 카운터를 숨깁니다
                      ),
                ),
              ),
              SizedBox(width: 5.w),
              Text(
                "$_txtLen/$_maxLen",
                style: TextStyle(
                  color: AppColors.g05,
                  fontSize: 13,
                  height: 1.20,
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  setState(() {
                    editingController.clear();
                  });

                  print("works");
                },
                child: Image.asset(
                  Assets.icons.iconTextdelete.path,
                  width: 40.r,
                  height: 40.r,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 1.h,
            width: double.infinity,
            child: ColoredBox(color: AppColors.g05),
          ),

          SizedBox(height: 16.h),
          Text(
            "닉네임 주의사항 자리",
            style: TextStyle(
              color: AppColors.g06,
              fontSize: 13,
              fontWeight: FontWeight.w400,
              height: 1.20,
            ),
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  void _onTextChanged() {
    String txt = editingController.text;

    setState(() {
      _txtLen = txt.length;
    });
  }

  Future<void> onSubmitted() async {
    bool result = await Get.find<AccountViewController>().setUserName(
      editingController.text.trim(),
    );

    if (result) Get.back();
  }
}
