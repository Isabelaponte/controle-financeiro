import 'package:flutter/material.dart';
import 'package:frontend/core/app_colors.dart';

class AppBarContent extends StatelessWidget {
  const AppBarContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.purpleDark,
                  child: Icon(
                    Icons.person,
                    color: AppColors.purpleLight,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                const Text("Isabela", style: TextStyle(fontSize: 16)),
              ],
            ),
            IconButton(
              icon: Icon(
                Icons.notifications_outlined,
                color: AppColors.purpleDark,
                size: 28,
              ),
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text("Saldo Total", style: TextStyle(fontSize: 14)),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/cofrinho_logo.png',
              height: 35,
              width: 35,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 10),
            const Text(
              "1.654,36",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
