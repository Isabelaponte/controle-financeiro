import 'package:flutter/material.dart';
import 'package:frontend/core/app_colors.dart';

class SecaoCard extends StatelessWidget {
  final String titulo;
  final VoidCallback onAdd;
  final List<Widget> children;

  const SecaoCard({
    super.key,
    required this.titulo,
    required this.onAdd,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: AppColors.backgroundCard,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  IconButton(onPressed: onAdd, icon: const Icon(Icons.add)),
                ],
              ),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}