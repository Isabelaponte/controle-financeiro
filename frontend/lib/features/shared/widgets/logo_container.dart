import 'package:flutter/material.dart';

class LogoContainer extends StatelessWidget {
  final Color cor;

  const LogoContainer({super.key, required this.cor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
