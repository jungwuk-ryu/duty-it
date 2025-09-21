import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/modules/account/controllers/account_view_controller.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

class AccountBottomModal extends StatefulWidget {
  const AccountBottomModal({super.key});

  @override
  State<AccountBottomModal> createState() => _AccountBottomModalState();
}

class _AccountBottomModalState extends State<AccountBottomModal> {
  late final TextEditingController editingController;

  final int _maxLen = 10;
  final int _minLen = 2;
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
      padding: EdgeInsets.only(
        top: 17,
        left: 17,
        right: 17,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 16),
          Text(
            "닉네임 수정",
            style: TextStyle(
              height: 1.60,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  controller: editingController,
                  autofocus: true,
                  maxLength: _maxLen,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[A-Za-z0-9가-힣ㄱ-ㅎㅏ-ㅣ ]'),
                    ),
                  ],
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => onSubmitted(),
                  decoration: InputDecoration.collapsed(
                    hintText: "도라지 감자도리",
                    hintStyle: TextStyle(color: AppColors.g05),
                  ).copyWith(counterText: ''),
                ),
              ),
              SizedBox(width: 5),
              Text(
                "$_txtLen/$_maxLen",
                style: TextStyle(
                  color: AppColors.g05,
                  fontSize: 13,
                  height: 1.20,
                ),
              ),
              SizedBox(width: 12),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  setState(() {
                    editingController.clear();
                  });
                },
                child: Image.asset(
                  Assets.icons.textdelete.path,
                  width: 16,
                  height: 16,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 1,
            width: double.infinity,
            child: ColoredBox(color: AppColors.g05),
          ),

          SizedBox(height: 16),
          Text(
            "닉네임은 2~10자의 한글·영문·숫자만 가능하며, 변경 시 되돌릴 수 없습니다",
            style: TextStyle(
              color: AppColors.g06,
              fontSize: 13,
              fontWeight: FontWeight.w400,
              height: 1.20,
            ),
          ),
          SizedBox(height: 40),
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
    final AccountViewController controller = Get.find<AccountViewController>();

    var newName = editingController.text.trim();
    if (newName.length < _minLen || newName.length > _maxLen) {
      AppUtils.showSnackBar('닉네임은 $_minLen~$_maxLen자여야 합니다.');
      return;
    }

    var available = await controller.isNicknameAvailable(newName);
    if (!available) {
      AppUtils.showSnackBar('이 닉네임은 사용할 수 없어요');
      return;
    }

    bool result = await controller.setUserName(newName);
    if (result) {
      Get.back();
      AppUtils.showSnackBar('닉네임이 변경되었어요');
    } else {
      AppUtils.showSnackBar('닉네임을 변경하지 못했어요');
    }

    controller.fetchUser();
  }
}
