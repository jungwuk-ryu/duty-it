import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/splash_view_controller.dart';

class SplashView extends GetView<SplashViewController> {
  static const String heroKey = "app_logo";

  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(tag: heroKey, child: Image.asset(Assets.icons.logo.path, width: 84, height: 80)),
      ),
    );
  }
}
