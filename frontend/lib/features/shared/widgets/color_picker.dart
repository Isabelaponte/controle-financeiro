import 'package:flutter/material.dart';
import 'package:frontend/core/app_colors.dart';

class ColorPicker extends StatelessWidget {
  final Color selectedColor;
  final Function(Color) onColorSelected;

  const ColorPicker({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  static final List<Color> colors = [
    const Color(0xFFE53935), // Vermelho
    const Color(0xFFD81B60), // Rosa
    const Color(0xFF8E24AA), // Roxo
    const Color(0xFF5E35B1), // Roxo Escuro
    const Color(0xFF3949AB), // Índigo
    const Color(0xFF1E88E5), // Azul
    const Color(0xFF039BE5), // Azul Claro
    const Color(0xFF00ACC1), // Ciano
    const Color(0xFF00897B), // Verde-azulado
    const Color(0xFF43A047), // Verde
    const Color(0xFF7CB342), // Verde Claro
    const Color(0xFFC0CA33), // Lima
    const Color(0xFFFDD835), // Amarelo
    const Color(0xFFFFB300), // Âmbar
    const Color(0xFFFB8C00), // Laranja
    const Color(0xFFF4511E), // Laranja Escuro
    const Color(0xFF6D4C41), // Marrom
    const Color(0xFF757575), // Cinza
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cor da Categoria',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.darkPurple,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: colors.map((color) {
            final isSelected = color == selectedColor;
            return GestureDetector(
              onTap: () => onColorSelected(color),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.purpleDark
                        : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(color: color, blurRadius: 8, spreadRadius: 1),
                  ],
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 24)
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
