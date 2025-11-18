import 'package:flutter/material.dart';
import 'package:frontend/features/presentation/pages/home_page.dart';
import 'package:frontend/features/presentation/pages/login_page.dart';
import 'package:frontend/features/presentation/pages/register_page.dart';
import 'package:frontend/features/presentation/pages/splash_page.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashPage(),
    login: (context) => const LoginPage(),
    register: (context) => const RegisterPage(),
    home: (context) => const HomePage(),
  };
}
