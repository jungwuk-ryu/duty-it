import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // 이제 시작입니다.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(home: const Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
    )
    ));
  }
}
