import 'package:flutter/material.dart';
import 'package:frontend/core/app_colors.dart';

class FilterChips extends StatefulWidget {
  final Function(String) onFilterChanged;

  const FilterChips({super.key, required this.onFilterChanged});

  @override
  State<FilterChips> createState() => _FilterChipsState();
}

class _FilterChipsState extends State<FilterChips> {
  String _selectedFilter = 'Geral';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildFilterChip("Geral", Icons.wallet_outlined, "Geral"),
        const SizedBox(width: 10),
        _buildFilterChip("Cartões", Icons.credit_card_outlined, "Cartões"),
      ],
    );
  }

  Widget _buildFilterChip(String label, IconData icon, String value) {
    final isSelected = _selectedFilter == value;

    return InputChip(
      label: Text(label),
      avatar: Icon(icon, size: 18),
      selected: isSelected,
      showCheckmark: false,
      onSelected: (selected) {
        setState(() => _selectedFilter = value);
        widget.onFilterChanged(value);
      },
      selectedColor: AppColors.purpleLight,
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
        color: isSelected ? AppColors.purpleDark : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
