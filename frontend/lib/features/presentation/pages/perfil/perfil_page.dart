import 'package:flutter/material.dart';
import 'package:frontend/features/presentation/pages/cartao/cartao_page.dart';
import 'package:frontend/features/presentation/pages/categoria/categorias_page.dart';
import 'package:frontend/features/presentation/pages/conta/conta_page.dart';
import 'package:frontend/features/presentation/pages/perfil/configuracoes_page.dart';
import 'package:provider/provider.dart';
import 'package:frontend/core/app_colors.dart';
import 'package:frontend/features/presentation/providers/auth_provider.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mais opções', style: TextStyle(fontSize: 16)),
        backgroundColor: AppColors.purpleLight,
        foregroundColor: AppColors.purpleDark,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Avatar e informações do usuário
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: AppColors.purpleDark,
                    child: Text(
                      user?.nomeUsuario.isNotEmpty == true
                          ? user!.nomeUsuario[0].toUpperCase()
                          : 'U',
                      style: TextStyle(
                        color: AppColors.purpleLight,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.nomeUsuario ?? 'Usuário',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '',
                    style: TextStyle(fontSize: 14, color: AppColors.grayDark),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Opções do perfil
            Column(
              children: [
                _buildMenuOption(
                  icon: Icons.credit_card,
                  titulo: 'Cartões de crédito',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CartaoCreditoPage(),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                _buildMenuOption(
                  icon: Icons.account_balance_wallet,
                  titulo: 'Contas',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ContaPage(),
                      ),
                    );
                  },
                ),
                // const Divider(height: 1),
                // _buildMenuOption(
                //   icon: Icons.flag,
                //   titulo: 'Minhas Metas',
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => const CategoriasPage(),
                //       ),
                //     );
                //   },
                // ),
                const Divider(height: 1),
                _buildMenuOption(
                  icon: Icons.category,
                  titulo: 'Categorias',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CategoriasPage(),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            Column(
              children: [
                _buildMenuOption(
                  icon: Icons.settings,
                  titulo: 'Configurações',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ConfiguracoesPage(),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                _buildMenuOption(
                  icon: Icons.info,
                  titulo: 'Sobre',
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'Controle Financeiro',
                      applicationVersion: '1.0.0',
                      applicationIcon: Icon(
                        Icons.savings,
                        size: 48,
                        color: AppColors.grayDark,
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String titulo,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.grayDark),
      title: Text(titulo),
      trailing: Icon(Icons.chevron_right, color: AppColors.grayDark),
      onTap: onTap,
    );
  }
}
