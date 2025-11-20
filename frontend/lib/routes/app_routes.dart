import 'package:flutter/material.dart';
import 'package:frontend/features/presentation/pages/home/home_page.dart';
import 'package:frontend/features/presentation/pages/login_page.dart';
import 'package:frontend/features/presentation/pages/register_page.dart';
import 'package:frontend/features/presentation/pages/splash_page.dart';
import 'package:frontend/routes/auth_guard.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashPage(),

      login: (context) =>
          const AuthGuard(requireAuth: false, child: LoginPage()),
      register: (context) =>
          const AuthGuard(requireAuth: false, child: RegisterPage()),

      home: (context) => const AuthGuard(requireAuth: true, child: HomePage()),
    };
  }
}
