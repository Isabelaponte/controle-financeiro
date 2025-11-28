import 'package:flutter/material.dart';
import 'package:frontend/features/presentation/pages/estatisticas/estatisticas_page.dart';
import 'package:frontend/features/presentation/pages/home/home_page.dart';
import 'package:frontend/features/presentation/pages/page_para_coisar.dart';
import 'package:frontend/features/presentation/pages/perfil/perfil_page.dart';
import 'package:frontend/features/presentation/pages/transacoes/transacoes_page.dart';
import 'package:frontend/features/presentation/providers/cartao_provider.dart';
import 'package:frontend/features/presentation/providers/conta_provider.dart';
import 'package:frontend/features/presentation/providers/meta_financeira_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/core/app_colors.dart';
import 'package:frontend/features/presentation/providers/auth_provider.dart';

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomePage(),
      const TransacoesPage(),
      const PageParaCoisar(),
      const EstatisticasPage(),
      const PerfilPage(),
    ];

    // Carrega os dados iniciais
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _carregarDados();
    });
  }

  Future<void> _carregarDados() async {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.user;

    if (user == null) return;

    final contaProvider = context.read<ContaProvider>();
    final cartaoProvider = context.read<CartaoCreditoProvider>();
    final metaProvider = context.read<MetaFinanceiraProvider>();

    try {
      await Future.wait([
        contaProvider.carregarDados(user.id),
        cartaoProvider.carregarCartoes(user.id),
        metaProvider.carregarMetas(user.id),
      ]);

      // Verifica se houve erro de autenticação
      if (contaProvider.isAuthError ||
          cartaoProvider.isAuthError ||
          metaProvider.isAuthError) {
        _handleAuthError();
      }
    } catch (e) {
      debugPrint('Erro ao carregar dados: $e');
    }
  }

  void _handleAuthError() {
    final authProvider = context.read<AuthProvider>();
    authProvider.logout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        if (index == 2) {
          // Botão central - mostrar modal
          _mostrarOpcoesAdicionar();
        } else {
          setState(() => _currentIndex = index);
        }
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.purpleDark,
      unselectedItemColor: AppColors.grayDark,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedFontSize: 12,
      unselectedFontSize: 12,
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

  void _mostrarOpcoesAdicionar() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Adicionar',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.purpleDark,
              ),
            ),
            const SizedBox(height: 20),
            _buildOpcaoAdicionar(
              icon: Icons.account_balance,
              titulo: 'Conta',
              subtitulo: 'Adicionar uma nova conta bancária',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Em desenvolvimento')),
                );
              },
            ),
            _buildOpcaoAdicionar(
              icon: Icons.credit_card,
              titulo: 'Cartão de Crédito',
              subtitulo: 'Adicionar um novo cartão',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Em desenvolvimento')),
                );
              },
            ),
            _buildOpcaoAdicionar(
              icon: Icons.flag,
              titulo: 'Meta Financeira',
              subtitulo: 'Criar uma nova meta',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Em desenvolvimento')),
                );
              },
            ),
            _buildOpcaoAdicionar(
              icon: Icons.swap_horiz,
              titulo: 'Transação',
              subtitulo: 'Registrar receita ou despesa',
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 2);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpcaoAdicionar({
    required IconData icon,
    required String titulo,
    required String subtitulo,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.purpleLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.purpleDark),
      ),
      title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(
        subtitulo,
        style: TextStyle(fontSize: 12, color: AppColors.grayDark),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
