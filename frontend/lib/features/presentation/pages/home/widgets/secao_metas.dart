import 'package:flutter/material.dart';
import 'package:frontend/core/app_colors.dart';
import 'package:frontend/features/shared/widgets/secao_card.dart';

class SecaoMetas extends StatelessWidget {
  const SecaoMetas({super.key});

  @override
  Widget build(BuildContext context) {
    return SecaoCard(
      titulo: "Minhas metas",
      onAdd: () {},
      children: const [
        MetaTile(
          nome: 'Viagem',
          categoria: 'Lazer',
          valorAtual: 20.00,
          valorTotal: 2500.00,
        ),
        SizedBox(height: 10),
        MetaTile(
          nome: 'Celular novo',
          categoria: 'Compras',
          valorAtual: 800.00,
          valorTotal: 3000.00,
        ),
      ],
    );
  }
}

class MetaTile extends StatelessWidget {
  final String nome;
  final String categoria;
  final double valorAtual;
  final double valorTotal;

  const MetaTile({
    super.key,
    required this.nome,
    required this.categoria,
    required this.valorAtual,
    required this.valorTotal,
  });

  double get progresso => valorAtual / valorTotal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                nome,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.purpleLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  categoria,
                  style: TextStyle(fontSize: 12, color: AppColors.purpleDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'R\$ ${valorAtual.toStringAsFixed(2).replaceAll('.', ',')}',
                style: TextStyle(fontSize: 13, color: AppColors.grayDark),
              ),
              Text(
                'R\$ ${valorTotal.toStringAsFixed(2).replaceAll('.', ',')}',
                style: TextStyle(fontSize: 13, color: AppColors.grayDark),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progresso,
              minHeight: 8,
              backgroundColor: AppColors.grayLight,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.purpleDark),
            ),
          ),
        ],
      ),
    );
  }
}
