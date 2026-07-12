import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/account/widgets/account_view_item_text.dart';
import 'package:duty_it/app/modules/account/widgets/account_view_item_title.dart';
import 'package:duty_it/app/widgets/simple_app_bar.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/account_view_controller.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  late final AccountViewController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<AccountViewController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SimpleAppBar(title: '계정 설정'),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AccountViewItemTitle("닉네임"),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Obx(
                          () => AccountViewItemText(controller.getUserName()),
                        ),
                        GestureDetector(
                          onTap: () => controller.onUserNameEditButtonClicked(),
                          child: Image.asset(
                            Assets.icons.pen.path,
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 42),

                    AccountViewItemTitle("연결된 ${controller.providerName} 계정"),
                    SizedBox(height: 8),
                    Obx(() => AccountViewItemText(controller.getAccountId())),

                    SizedBox(height: 32),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => controller.logout(),
                      child: AccountViewItemText("로그아웃", color: AppColors.g05),
                    ),

                    SizedBox(height: 16),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => controller.withdraw(),
                      child: AccountViewItemText("회원 탈퇴", color: AppColors.g05),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
