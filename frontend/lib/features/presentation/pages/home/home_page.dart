import 'package:flutter/material.dart';
import 'package:frontend/core/app_colors.dart';
import 'package:frontend/features/presentation/pages/home/widgets/app_bar_content.dart';
import 'package:frontend/features/presentation/pages/home/widgets/resumo_cards.dart';
import 'package:frontend/features/presentation/pages/home/widgets/secao_cartoes.dart';
import 'package:frontend/features/presentation/pages/home/widgets/secao_contas.dart';
import 'package:frontend/features/presentation/pages/home/widgets/secao_metas.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: const [
              ResumoCards(),
              SizedBox(height: 20),
              SecaoContas(),
              SizedBox(height: 10),
              SecaoCartoes(),
              SizedBox(height: 10),
              SecaoMetas(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.purpleDark,
      unselectedItemColor: AppColors.grayDark,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
        const BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_wallet_outlined),
          label: 'Carteira',
        ),
        BottomNavigationBarItem(
          icon: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.purpleLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.add, color: AppColors.purpleDark),
          ),
          label: 'Adicionar',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: 'Estatísticas',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Perfil',
        ),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const AppBarContent(),
      centerTitle: true,
      toolbarHeight: 140,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
      ),
      backgroundColor: AppColors.purpleLight,
      foregroundColor: AppColors.purpleDark,
    );
  }
}
