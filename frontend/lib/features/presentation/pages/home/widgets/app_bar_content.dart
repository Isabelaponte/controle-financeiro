import 'package:flutter/material.dart';
import 'package:frontend/features/presentation/providers/conta_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/core/app_colors.dart';

class AppBarContent extends StatelessWidget {
  final String userName;

  const AppBarContent({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ContaProvider>(
      builder: (context, contaProvider, _) {
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
                      child: Text(
                        userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                        style: TextStyle(
                          color: AppColors.purpleLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(userName, style: const TextStyle(fontSize: 16)),
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
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.savings,
                      size: 35,
                      color: AppColors.purpleDark,
                    );
                  },
                ),
                const SizedBox(width: 10),
                _buildSaldoTotal(contaProvider),
              ],
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  Widget _buildSaldoTotal(ContaProvider provider) {
    if (provider.isLoading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    return Text(
      provider.saldoTotalFormatado,
      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    );
  }
}