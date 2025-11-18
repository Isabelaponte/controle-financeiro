import 'package:flutter/material.dart';
// import 'package:frontend/core/app_colors.dart';
// import 'package:frontend/routes/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: Text("Hello!")));
  }
}
