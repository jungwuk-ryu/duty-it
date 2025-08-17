import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/splash_view_controller.dart';

class SplashView extends GetView<SplashViewController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Hero(tag: "app_logo", child: Text('LOGO')),
      ),
    );
  }
}
