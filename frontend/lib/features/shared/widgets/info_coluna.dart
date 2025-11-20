import 'package:flutter/material.dart';
import 'package:frontend/core/app_colors.dart';

class InfoColuna extends StatelessWidget {
  final String label;
  final String valor;
  final Color? corValor;

  const InfoColuna({
    super.key,
    required this.label,
    required this.valor,
    this.corValor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(label, style: TextStyle(color: AppColors.grayDark, fontSize: 12)),
        const SizedBox(height: 10),
        Text(
          valor,
          style: TextStyle(color: corValor ?? AppColors.grayDark, fontSize: 12),
        ),
      ],
    );
  }
}