import 'package:flutter/material.dart';
import 'package:frontend/features/presentation/pages/home/widgets/app_bar_content.dart';
import 'package:frontend/features/presentation/pages/home/widgets/resumo_cards.dart';
import 'package:frontend/features/presentation/pages/home/widgets/secao_cartoes.dart';
import 'package:frontend/features/presentation/pages/home/widgets/secao_contas.dart';
import 'package:frontend/features/presentation/pages/home/widgets/secao_metas.dart';
import 'package:frontend/features/presentation/providers/cartao_provider.dart';
import 'package:frontend/features/presentation/providers/conta_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/core/app_colors.dart';
import 'package:frontend/features/presentation/providers/auth_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _carregarDados();
    });
  }

  Future<void> _carregarDados() async {
    final authProvider = context.read<AuthProvider>();

    final user = authProvider.user;

    if (user == null) {
      return;
    }

    if (user.id.isEmpty) {
      return;
    }

    final contaProvider = context.read<ContaProvider>();
    final cartaoProvider = context.read<CartaoCreditoProvider>();

    try {
      await contaProvider.carregarDados(user.id);
      await cartaoProvider.carregarCartoes(user.id);
    } catch (e) {
      debugPrint('DEBUG: Erro ao carregar dados: $e');
    }

    // Verifica se houve erro de autenticação
    if (contaProvider.isAuthError) {
      _handleAuthError();
    }
  }

  void _handleAuthError() {
    final authProvider = context.read<AuthProvider>();
    authProvider.logout();
  }

  Future<void> _atualizarDados() async {
    await _carregarDados();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return Scaffold(
      appBar: _buildAppBar(user?.name ?? 'Usuário'),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _atualizarDados,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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

  PreferredSizeWidget _buildAppBar(String userName) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: AppBarContent(userName: userName),
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
