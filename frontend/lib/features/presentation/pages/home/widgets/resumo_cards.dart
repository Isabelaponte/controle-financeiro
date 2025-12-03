import 'package:flutter/material.dart';
import 'package:frontend/core/app_colors.dart';
import 'package:frontend/features/presentation/providers/resumo_provider.dart';
import 'package:provider/provider.dart';

class ResumoCards extends StatelessWidget {
  const ResumoCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ResumoProvider>(
      builder: (context, resumoProvider, child) {
        if (resumoProvider.isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (resumoProvider.status == ResumoStatus.error) {
          return Center(
            child: Text(
              resumoProvider.errorMessage ?? 'Erro ao carregar resumo',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        return Row(
          children: [
            Expanded(
              child: ResumoCard(
                valor: resumoProvider.totalGanhosFormatado.replaceAll(
                  'R\$ ',
                  '',
                ),
                label: "Ganhos",
                icon: Icons.trending_up,
                color: AppColors.green,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ResumoCard(
                valor: resumoProvider.totalGastosFormatado.replaceAll(
                  'R\$ ',
                  '',
                ),
                label: "Gastos",
                icon: Icons.trending_down,
                color: AppColors.red,
              ),
            ),
          ],
        );
      },
    );
  }
}

class ResumoCard extends StatelessWidget {
  final String valor;
  final String label;
  final IconData icon;
  final Color color;

  const ResumoCard({
    super.key,
    required this.valor,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.backgroundCard,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(width: 18),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(valor, style: TextStyle(color: color, fontSize: 18)),
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.darkPurple,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
