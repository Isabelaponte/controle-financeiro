import 'package:flutter/material.dart';
import 'package:frontend/features/presentation/pages/home/widgets/app_bar_content.dart';
import 'package:frontend/features/presentation/pages/home/widgets/resumo_cards.dart';
import 'package:frontend/features/presentation/pages/home/widgets/secao_cartoes.dart';
import 'package:frontend/features/presentation/pages/home/widgets/secao_contas.dart';
import 'package:frontend/features/presentation/pages/home/widgets/secao_metas.dart';
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
  Future<void> _atualizarDados() async {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.user;

    if (user == null) return;

    final contaProvider = context.read<ContaProvider>();
    await contaProvider.carregarDados(user.id);
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
