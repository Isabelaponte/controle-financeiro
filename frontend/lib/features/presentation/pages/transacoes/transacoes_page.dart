import 'package:flutter/material.dart';
import 'package:frontend/core/app_colors.dart';

class TransacoesPage extends StatelessWidget {
  const TransacoesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TransacoesPage'),
        backgroundColor: AppColors.purpleLight,
        foregroundColor: AppColors.purpleDark,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Minhas finanças',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.purpleDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
