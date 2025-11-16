import 'package:flutter/material.dart';
import 'package:frontend/pages/presentation/login_page.dart';
import 'package:frontend/pages/presentation/register_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginPage(),
    register: (context) => const RegisterPage(),
  };
}
