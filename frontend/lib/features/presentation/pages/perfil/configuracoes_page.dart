import 'package:flutter/material.dart';
import 'package:frontend/features/presentation/pages/perfil/editar_perfil_page.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:frontend/core/app_colors.dart';
import 'package:frontend/features/presentation/providers/auth_provider.dart';

class ConfiguracoesPage extends StatelessWidget {
  const ConfiguracoesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações', style: TextStyle(fontSize: 16)),
        backgroundColor: AppColors.purpleLight,
        foregroundColor: AppColors.purpleDark,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const SizedBox(height: 20),
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

            Column(
              children: [
                _buildMenuOption(
                  icon: Icons.person,
                  titulo: 'Editar Perfil',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UsuarioEditPage(),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                _buildMenuOption(
                  icon: Icons.delete,
                  titulo: 'Excluir minha conta',
                  onTap: () => _confirmarRemoverConta(context, authProvider),
                ),
              ],
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _confirmarLogout(context, authProvider),
                icon: Icon(Icons.logout, color: AppColors.red),
                label: Text(
                  'Sair da Conta',
                  style: TextStyle(color: AppColors.red),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: AppColors.red),
                ),
              ),
            ),
            const SizedBox(height: 20),
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

  Future<void> _confirmarLogout(
    BuildContext context,
    AuthProvider authProvider,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar saída'),
        content: const Text('Deseja realmente sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.red),
            child: const Text('Sair'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      await authProvider.logout();
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    }
  }

  Future<void> _confirmarRemoverConta(
    BuildContext context,
    AuthProvider authProvider,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text(
          'Deseja realmente excluir sua conta? Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      try {
        await authProvider.deletarConta();
        await authProvider.logout();

        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.login,
            (route) => false,
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao excluir conta: $e'),
              backgroundColor: AppColors.red,
            ),
          );
        }
      }
    }
  }
}
