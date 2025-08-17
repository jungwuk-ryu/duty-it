import 'package:duty_it/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AuthGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return RouteSettings(name: Routes.LOGIN);
    }

    return super.redirect(route);
  }
}