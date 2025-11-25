import 'package:flutter/material.dart';
import 'package:frontend/routes/app_routes.dart';
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
        title: const Text('Perfil'),
        backgroundColor: AppColors.purpleLight,
        foregroundColor: AppColors.purpleDark,
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
                      user?.name.isNotEmpty == true
                          ? user!.name[0].toUpperCase()
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
                    user?.name ?? 'Usuário',
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
            Card(
              color: AppColors.backgroundCard,
              child: Column(
                children: [
                  _buildMenuOption(
                    icon: Icons.person,
                    titulo: 'Editar Perfil',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Em desenvolvimento')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  _buildMenuOption(
                    icon: Icons.lock,
                    titulo: 'Alterar Senha',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Em desenvolvimento')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  _buildMenuOption(
                    icon: Icons.notifications,
                    titulo: 'Notificações',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Em desenvolvimento')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Card(
              color: AppColors.backgroundCard,
              child: Column(
                children: [
                  _buildMenuOption(
                    icon: Icons.category,
                    titulo: 'Gerenciar Categorias',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Em desenvolvimento')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  _buildMenuOption(
                    icon: Icons.settings,
                    titulo: 'Configurações',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Em desenvolvimento')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  _buildMenuOption(
                    icon: Icons.help,
                    titulo: 'Ajuda e Suporte',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Em desenvolvimento')),
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
                          color: AppColors.purpleDark,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Botão de Logout
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
      leading: Icon(icon, color: AppColors.purpleDark),
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
}
