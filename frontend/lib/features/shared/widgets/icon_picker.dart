import 'package:flutter/material.dart';
import 'package:frontend/core/app_colors.dart';

class IconPickerData {
  final IconData icon;
  final String name;
  final String label;

  const IconPickerData({
    required this.icon,
    required this.name,
    required this.label,
  });
}

class IconPicker extends StatelessWidget {
  final String selectedIconName;
  final Function(String) onIconSelected;

  const IconPicker({
    super.key,
    required this.selectedIconName,
    required this.onIconSelected,
  });

  static final List<IconPickerData> icons = [
    IconPickerData(
      icon: Icons.attach_money,
      name: 'attach_money',
      label: 'Dinheiro',
    ),
    IconPickerData(
      icon: Icons.shopping_cart,
      name: 'shopping_cart',
      label: 'Compras',
    ),
    IconPickerData(
      icon: Icons.restaurant,
      name: 'restaurant',
      label: 'Alimentação',
    ),
    IconPickerData(icon: Icons.home, name: 'home', label: 'Casa'),
    IconPickerData(
      icon: Icons.directions_car,
      name: 'directions_car',
      label: 'Transporte',
    ),
    IconPickerData(
      icon: Icons.health_and_safety,
      name: 'health_and_safety',
      label: 'Saúde',
    ),
    IconPickerData(icon: Icons.school, name: 'school', label: 'Educação'),
    IconPickerData(
      icon: Icons.subscriptions,
      name: 'subscriptions',
      label: 'Assinaturas',
    ),
    IconPickerData(
      icon: Icons.credit_card,
      name: 'credit_card',
      label: 'Cartão',
    ),
    IconPickerData(icon: Icons.work, name: 'work', label: 'Trabalho'),
    IconPickerData(icon: Icons.savings, name: 'savings', label: 'Poupança'),
    IconPickerData(icon: Icons.flight, name: 'flight', label: 'Viagens'),
    IconPickerData(icon: Icons.pets, name: 'pets', label: 'Pets'),
    IconPickerData(
      icon: Icons.fitness_center,
      name: 'fitness_center',
      label: 'Academia',
    ),
    IconPickerData(
      icon: Icons.celebration,
      name: 'celebration',
      label: 'Lazer',
    ),
    IconPickerData(
      icon: Icons.phone_android,
      name: 'phone_android',
      label: 'Eletrônicos',
    ),
    IconPickerData(
      icon: Icons.local_hospital,
      name: 'local_hospital',
      label: 'Médico',
    ),
    IconPickerData(icon: Icons.movie, name: 'movie', label: 'Entretenimento'),
    IconPickerData(
      icon: Icons.checkroom,
      name: 'checkroom',
      label: 'Vestuário',
    ),
    IconPickerData(icon: Icons.local_cafe, name: 'local_cafe', label: 'Café'),
  ];

  static IconData getIconByName(String name) {
    return icons.firstWhere((i) => i.name == name, orElse: () => icons[0]).icon;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ícone da Categoria',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.darkPurple,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: icons.length,
          itemBuilder: (context, index) {
            final iconData = icons[index];
            final isSelected = iconData.name == selectedIconName;

            return GestureDetector(
              onTap: () => onIconSelected(iconData.name),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.purpleDark
                          : AppColors.purpleLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.purpleDark
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      iconData.icon,
                      color: isSelected ? Colors.white : AppColors.purpleDark,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    iconData.label,
                    style: TextStyle(
                      fontSize: 10,
                      color: isSelected
                          ? AppColors.purpleDark
                          : AppColors.grayDark,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
