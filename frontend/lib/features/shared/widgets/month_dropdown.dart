import 'package:flutter/material.dart';
import 'package:frontend/core/app_colors.dart';

class MonthDropdown extends StatefulWidget {
  final Function(String) onChanged;
  final List<String> months;

  const MonthDropdown({
    super.key,
    required this.onChanged,
    required this.months,
  });

  @override
  State<MonthDropdown> createState() => _MonthDropdownState();
}

class _MonthDropdownState extends State<MonthDropdown> {
  late String _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedMonth = widget.months.first;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selectedMonth,
      icon: const Icon(
        Icons.expand_circle_down_outlined,
        color: AppColors.darkPurple,
        size: 20,
      ),
      elevation: 16,
      style: const TextStyle(
        color: AppColors.darkPurple,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      underline: Container(height: 0),
      onChanged: (String? value) {
        if (value != null) {
          setState(() => _selectedMonth = value);
          widget.onChanged(value);
        }
      },
      items: widget.months.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
    );
  }
}
