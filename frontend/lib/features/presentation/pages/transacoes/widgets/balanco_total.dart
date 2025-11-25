import 'package:flutter/material.dart';
import 'package:frontend/core/app_colors.dart';

class BalancoTotal extends StatelessWidget {
  final double valor;

  const BalancoTotal({super.key, required this.valor});

  String get valorFormatado {
    final sinal = valor >= 0 ? '+' : '';
    return '$sinal R\$ ${valor.abs().toStringAsFixed(2).replaceAll('.', ',')}';
  }

  Color get cor {
    if (valor > 0) return AppColors.green;
    if (valor < 0) return AppColors.red;
    return Colors.black87;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Balanço total",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Text(
            valorFormatado,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: cor,
            ),
          ),
        ],
      ),
    );
  }
}
