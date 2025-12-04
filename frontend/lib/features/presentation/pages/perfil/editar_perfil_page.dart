import 'package:flutter/material.dart';
import 'package:frontend/core/app_colors.dart';
import 'package:frontend/features/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class UsuarioEditPage extends StatefulWidget {
  const UsuarioEditPage({super.key});

  @override
  State<UsuarioEditPage> createState() => _UsuarioEditPageState();
}

class _UsuarioEditPageState extends State<UsuarioEditPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Controllers para dados do usuário
  final _formKeyDados = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();

  // Controllers para senha
  final _formKeySenha = GlobalKey<FormState>();
  final _senhaAtualController = TextEditingController();
  final _novaSenhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  bool _isLoadingDados = false;
  bool _isLoadingSenha = false;
  bool _obscureSenhaAtual = true;
  bool _obscureNovaSenha = true;
  bool _obscureConfirmarSenha = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _carregarDadosUsuario();
  }

  void _carregarDadosUsuario() {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.user;

    if (user != null) {
      _nomeController.text = user.nomeUsuario;
      _emailController.text = user.email;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nomeController.dispose();
    _emailController.dispose();
    _senhaAtualController.dispose();
    _novaSenhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil', style: TextStyle(fontSize: 16)),
        backgroundColor: AppColors.purpleLight,
        foregroundColor: AppColors.purpleDark,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.purpleDark,
          indicatorColor: AppColors.purpleDark,
          tabs: const [
            Tab(icon: Icon(Icons.person), text: 'Dados'),
            Tab(icon: Icon(Icons.lock), text: 'Senha'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildDadosTab(), _buildSenhaTab()],
      ),
    );
  }

  Widget _buildDadosTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKeyDados,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Avatar
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.purpleLight,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: AppColors.purpleDark,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.purpleDark,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Nome
            TextFormField(
              controller: _nomeController,
              decoration: InputDecoration(
                labelText: 'Nome *',
                labelStyle: TextStyle(color: AppColors.purpleDark),
                prefixIcon: Icon(Icons.person, color: AppColors.purpleDark),
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nome é obrigatório';
                }
                if (value.trim().length < 3 || value.trim().length > 50) {
                  return 'Nome deve ter entre 3 e 50 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Email
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email *',
                labelStyle: TextStyle(color: AppColors.purpleDark),
                prefixIcon: Icon(Icons.email, color: AppColors.purpleDark),
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email é obrigatório';
                }
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegex.hasMatch(value)) {
                  return 'Email inválido';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),

            // Botões
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoadingDados
                        ? null
                        : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.purpleDark,
                      side: BorderSide(color: AppColors.purpleDark),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _isLoadingDados ? null : _salvarDados,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.purpleDark,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoadingDados
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Salvar', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSenhaTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKeySenha,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Senha Atual
            TextFormField(
              controller: _senhaAtualController,
              decoration: InputDecoration(
                labelText: 'Senha Atual *',
                labelStyle: TextStyle(color: AppColors.purpleDark),
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: AppColors.purpleDark,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureSenhaAtual
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: AppColors.purpleDark,
                  ),
                  onPressed: () {
                    setState(() => _obscureSenhaAtual = !_obscureSenhaAtual);
                  },
                ),
                border: const OutlineInputBorder(),
              ),
              obscureText: _obscureSenhaAtual,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Senha atual é obrigatória';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Nova Senha
            TextFormField(
              controller: _novaSenhaController,
              decoration: InputDecoration(
                labelText: 'Nova Senha *',
                labelStyle: TextStyle(color: AppColors.purpleDark),
                prefixIcon: Icon(Icons.lock, color: AppColors.purpleDark),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureNovaSenha ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.purpleDark,
                  ),
                  onPressed: () {
                    setState(() => _obscureNovaSenha = !_obscureNovaSenha);
                  },
                ),
                border: const OutlineInputBorder(),
                helperText: 'Mínimo de 6 caracteres',
              ),
              obscureText: _obscureNovaSenha,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nova senha é obrigatória';
                }
                if (value.length < 6) {
                  return 'Senha deve ter no mínimo 6 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Confirmar Nova Senha
            TextFormField(
              controller: _confirmarSenhaController,
              decoration: InputDecoration(
                labelText: 'Confirmar Nova Senha *',
                labelStyle: TextStyle(color: AppColors.purpleDark),
                prefixIcon: Icon(Icons.lock, color: AppColors.purpleDark),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmarSenha
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: AppColors.purpleDark,
                  ),
                  onPressed: () {
                    setState(
                      () => _obscureConfirmarSenha = !_obscureConfirmarSenha,
                    );
                  },
                ),
                border: const OutlineInputBorder(),
              ),
              obscureText: _obscureConfirmarSenha,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Confirmação de senha é obrigatória';
                }
                if (value != _novaSenhaController.text) {
                  return 'As senhas não coincidem';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),

            // Botões
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoadingSenha ? null : _limparCamposSenha,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.purpleDark,
                      side: BorderSide(color: AppColors.purpleDark),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Limpar', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _isLoadingSenha ? null : _alterarSenha,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.purpleDark,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoadingSenha
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Alterar Senha',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _salvarDados() async {
    if (!_formKeyDados.currentState!.validate()) return;

    setState(() => _isLoadingDados = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final user = authProvider.user;

      if (user == null) {
        _mostrarErro('Usuário não encontrado');
        return;
      }

      final sucesso = await authProvider.atualizarUsuario(
        nomeUsuario: _nomeController.text.trim(),
        email: _emailController.text.trim(),
      );

      if (!mounted) return;

      if (sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Dados atualizados com sucesso!'),
            backgroundColor: AppColors.green,
          ),
        );
        // Navigator.pop(context, true);
      } else {
        _mostrarErro(authProvider.errorMessage ?? 'Erro ao atualizar dados');
      }
    } catch (e) {
      _mostrarErro('Erro inesperado: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingDados = false);
      }
    }
  }

  Future<void> _alterarSenha() async {
    if (!_formKeySenha.currentState!.validate()) return;

    setState(() => _isLoadingSenha = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final user = authProvider.user;

      if (user == null) {
        _mostrarErro('Usuário não encontrado');
        return;
      }

      final sucesso = await authProvider.alterarSenha(
        senhaAtual: _senhaAtualController.text,
        novaSenha: _novaSenhaController.text,
        confirmarNovaSenha: _confirmarSenhaController.text,
      );

      if (!mounted) return;

      if (sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Senha alterada com sucesso!'),
            backgroundColor: AppColors.green,
          ),
        );
        _limparCamposSenha();
        _tabController.animateTo(0); // Volta para a aba de dados
      } else {
        _mostrarErro(authProvider.errorMessage ?? 'Erro ao alterar senha');
      }
    } catch (e) {
      _mostrarErro('Erro inesperado: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingSenha = false);
      }
    }
  }

  void _limparCamposSenha() {
    _senhaAtualController.clear();
    _novaSenhaController.clear();
    _confirmarSenhaController.clear();
    _formKeySenha.currentState?.reset();
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), backgroundColor: AppColors.red),
    );
  }
}
