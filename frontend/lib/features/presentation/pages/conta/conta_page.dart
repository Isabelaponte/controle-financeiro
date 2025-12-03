import 'package:flutter/material.dart';
import 'package:frontend/features/models/conta_model.dart';
import 'package:frontend/features/presentation/pages/conta/conta_form_page.dart';
import 'package:frontend/features/presentation/providers/conta_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/core/app_colors.dart';
import 'package:frontend/features/shared/widgets/icon_picker.dart';
import 'package:frontend/features/presentation/providers/auth_provider.dart';

class ContaPage extends StatefulWidget {
  const ContaPage({super.key});

  @override
  State<ContaPage> createState() => _ContaPageState();
}

class _ContaPageState extends State<ContaPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _carregarContas();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _carregarContas() async {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.user;
    if (user == null) return;

    final contaProvider = context.read<ContaProvider>();
    await contaProvider.carregarTodasAsContas(user.id);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ContaProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contas', style: TextStyle(fontSize: 16)),
        backgroundColor: AppColors.purpleLight,
        foregroundColor: AppColors.purpleDark,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.purpleDark,
          indicatorColor: AppColors.purpleDark,
          tabs: [
            Tab(
              icon: const Icon(Icons.check_circle),
              text: 'Ativas (${provider.contasAtivas.length})',
            ),
            Tab(
              icon: const Icon(Icons.block),
              text: 'Inativas (${provider.contasInativas.length})',
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _carregarContas,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildListaContas(provider, ativas: true),
            _buildListaContas(provider, ativas: false),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final resultado = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ContaFormPage()),
          );
          if (resultado == true) {
            _carregarContas();
          }
        },
        backgroundColor: AppColors.purpleLight,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildListaContas(ContaProvider provider, {required bool ativas}) {
    if (provider.isLoading && provider.contas.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.status == ContaStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.red),
            const SizedBox(height: 16),
            Text(
              provider.errorMessage ?? 'Erro ao carregar contas',
              style: TextStyle(color: AppColors.grayDark),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final contas = ativas ? provider.contasAtivas : provider.contasInativas;

    if (contas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              ativas ? Icons.account_balance_wallet : Icons.block,
              size: 64,
              color: AppColors.grayDark,
            ),
            const SizedBox(height: 16),
            Text(
              ativas ? 'Nenhuma conta ativa' : 'Nenhuma conta inativa',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkPurple,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              ativas
                  ? 'Crie contas para organizar\nsuas transações financeiras'
                  : 'As contas desativadas\naparecerão aqui',
              style: TextStyle(fontSize: 14, color: AppColors.grayDark),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: contas.length,
      itemBuilder: (context, index) {
        final conta = contas[index];
        return _buildContaCard(conta, ativas: ativas);
      },
    );
  }

  Widget _buildContaCard(ContaModel conta, {required bool ativas}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: ativas ? null : Colors.grey[200],
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: ativas ? AppColors.blue : Colors.grey,
            shape: BoxShape.circle,
          ),
          child: Icon(
            IconPicker.getIconByName('universal_currency'),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          conta.nome,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: ativas ? null : Colors.grey[600],
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              conta.nome,
              style: TextStyle(color: ativas ? null : Colors.grey[500]),
            ),
            const SizedBox(height: 4),
            Text(
              'Saldo: ${conta.saldoFormatado}',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: ativas ? AppColors.green : Colors.grey[500],
              ),
            ),
          ],
        ),
        trailing: ativas ? _buildMenuAtiva(conta) : _buildMenuInativa(conta),
      ),
    );
  }

  Widget _buildMenuAtiva(ContaModel conta) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          child: const Row(
            children: [Icon(Icons.edit), SizedBox(width: 8), Text('Editar')],
          ),
          onTap: () async {
            await Future.delayed(Duration.zero);
            if (!mounted) return;
            final resultado = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ContaFormPage(conta: conta),
              ),
            );
            if (resultado == true) {
              _carregarContas();
            }
          },
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.block, color: AppColors.red),
              const SizedBox(width: 8),
              Text('Desativar', style: TextStyle(color: AppColors.red)),
            ],
          ),
          onTap: () async {
            await Future.delayed(Duration.zero);
            if (!mounted) return;
            _confirmarDesativar(conta);
          },
        ),
      ],
    );
  }

  Widget _buildMenuInativa(ContaModel conta) {
    return IconButton(
      icon: Icon(Icons.restore, color: AppColors.green),
      onPressed: () => _confirmarReativar(conta),
      tooltip: 'Reativar',
    );
  }

  Future<void> _confirmarDesativar(ContaModel conta) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Desativar Conta'),
        content: Text(
          'Deseja desativar a conta "${conta.nome}"?\n\n'
          'Ela não aparecerá mais nas listas, mas as transações '
          'já criadas não serão afetadas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.red),
            child: const Text('Desativar'),
          ),
        ],
      ),
    );

    if (confirmar == true && mounted) {
      final provider = context.read<ContaProvider>();
      final sucesso = await provider.desativarConta(conta.id);

      if (mounted && sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Conta desativada!'),
            backgroundColor: Colors.orange,
            action: SnackBarAction(
              label: 'Desfazer',
              textColor: Colors.white,
              onPressed: () {
                _reativarConta(conta.id);
              },
            ),
          ),
        );
        _carregarContas();
      }
    }
  }

  Future<void> _confirmarReativar(ContaModel conta) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reativar Conta'),
        content: Text(
          'Deseja reativar a conta "${conta.nome}"?\n\n'
          'Ela voltará a aparecer nas listas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.green),
            child: const Text('Reativar'),
          ),
        ],
      ),
    );

    if (confirmar == true && mounted) {
      _reativarConta(conta.id);
    }
  }

  Future<void> _reativarConta(String id) async {
    final provider = context.read<ContaProvider>();
    final sucesso = await provider.reativarConta(id);

    if (mounted && sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conta reativada!'),
          backgroundColor: Colors.green,
        ),
      );
      _carregarContas();
    }
  }
}
