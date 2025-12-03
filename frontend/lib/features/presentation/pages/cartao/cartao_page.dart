import 'package:flutter/material.dart';
import 'package:frontend/features/models/catao_model.dart';
import 'package:frontend/features/presentation/pages/cartao/cartao_form_page.dart';
import 'package:frontend/features/presentation/providers/cartao_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/core/app_colors.dart';
import 'package:frontend/features/presentation/providers/auth_provider.dart';

class CartaoCreditoPage extends StatefulWidget {
  const CartaoCreditoPage({super.key});

  @override
  State<CartaoCreditoPage> createState() => _CartaoCreditoPageState();
}

class _CartaoCreditoPageState extends State<CartaoCreditoPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _carregarCartoes();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _carregarCartoes() async {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.user;
    if (user == null) return;

    final cartaoProvider = context.read<CartaoCreditoProvider>();
    await cartaoProvider.carregarTodosCartoes(user.id);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CartaoCreditoProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cartões de Crédito', style: TextStyle(fontSize: 16)),
        backgroundColor: AppColors.purpleLight,
        foregroundColor: AppColors.purpleDark,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.purpleDark,
          indicatorColor: AppColors.purpleDark,
          tabs: [
            Tab(
              icon: const Icon(Icons.check_circle),
              text: 'Ativos (${provider.cartoesAtivos.length})',
            ),
            Tab(
              icon: const Icon(Icons.block),
              text: 'Inativos (${provider.cartoesInativos.length})',
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _carregarCartoes,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildListaCartoes(provider, ativos: true),
            _buildListaCartoes(provider, ativos: false),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final resultado = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CartaoFormPage()),
          );
          if (resultado == true) {
            _carregarCartoes();
          }
        },
        backgroundColor: AppColors.purpleLight,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildListaCartoes(
    CartaoCreditoProvider provider, {
    required bool ativos,
  }) {
    if (provider.isLoading && provider.cartoes.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.status == CartaoCreditoStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.red),
            const SizedBox(height: 16),
            Text(
              provider.errorMessage ?? 'Erro ao carregar cartões',
              style: TextStyle(color: AppColors.grayDark),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final cartoes = ativos ? provider.cartoesAtivos : provider.cartoesInativos;

    if (cartoes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              ativos ? Icons.credit_card : Icons.block,
              size: 64,
              color: AppColors.grayDark,
            ),
            const SizedBox(height: 16),
            Text(
              ativos ? 'Nenhum cartão ativo' : 'Nenhum cartão inativo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkPurple,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              ativos
                  ? 'Adicione cartões de crédito\npara gerenciar suas faturas'
                  : 'Os cartões desativados\naparecerão aqui',
              style: TextStyle(fontSize: 14, color: AppColors.grayDark),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: cartoes.length,
      itemBuilder: (context, index) {
        final cartao = cartoes[index];
        return _buildCartaoCard(cartao, ativos: ativos);
      },
    );
  }

  Widget _buildCartaoCard(CartaoCreditoModel cartao, {required bool ativos}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: ativos ? null : Colors.grey[200],
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: ativos ? _getCorCartao(cartao) : Colors.grey,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.credit_card, color: Colors.white, size: 24),
        ),
        title: Row(
          children: [
            Text(
              cartao.nome,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ativos ? null : Colors.grey[600],
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Disponível',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.grayDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Limite: ${cartao.limiteTotalFormatado}',
              style: TextStyle(
                fontSize: 12,
                color: ativos ? AppColors.grayDark : Colors.grey[500],
              ),
            ),
          ],
        ),
        trailing: ativos ? _buildMenuAtivo(cartao) : _buildMenuInativo(cartao),
        onTap: () => _mostrarDetalhes(cartao),
      ),
    );
  }

  Color _getCorCartao(CartaoCreditoModel cartao) {
    switch (cartao.categoriaNome?.toLowerCase()) {
      case 'nubank':
        return const Color(0xFF8A05BE);
      case 'itaú':
      case 'itau':
        return Colors.orange;
      case 'bradesco':
        return Colors.red;
      case 'inter':
        return Colors.orange.shade700;
      case 'c6':
      case 'c6 bank':
        return Colors.grey.shade800;
      default:
        return AppColors.purpleDark;
    }
  }

  Widget _buildMenuAtivo(CartaoCreditoModel cartao) {
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
                builder: (context) => CartaoFormPage(cartao: cartao),
              ),
            );
            if (resultado == true) {
              _carregarCartoes();
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
            _confirmarDesativar(cartao);
          },
        ),
      ],
    );
  }

  Widget _buildMenuInativo(CartaoCreditoModel cartao) {
    return IconButton(
      icon: Icon(Icons.restore, color: AppColors.green),
      onPressed: () => _confirmarReativar(cartao),
      tooltip: 'Reativar',
    );
  }

  void _mostrarDetalhes(CartaoCreditoModel cartao) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cartao.nome,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Limite total', cartao.limiteTotalFormatado),
            _buildInfoRow('Dia de fechamento', '${cartao.diaFechamento}'),
            _buildInfoRow('Dia de vencimento', '${cartao.diaVencimento}'),
            if (cartao.categoriaNome != null)
              _buildInfoRow('Categoria', cartao.categoriaNome!),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isError = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppColors.grayDark)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isError ? AppColors.red : null,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmarDesativar(CartaoCreditoModel cartao) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Desativar Cartão'),
        content: Text(
          'Deseja desativar o cartão "${cartao.nome}"?\n\n'
          'Ele não aparecerá mais nas listas, mas as transações '
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
      final provider = context.read<CartaoCreditoProvider>();
      final sucesso = await provider.desativarCartao(cartao.id);

      if (mounted && sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Cartão desativado!'),
            backgroundColor: Colors.orange,
            action: SnackBarAction(
              label: 'Desfazer',
              textColor: Colors.white,
              onPressed: () {
                _reativarCartao(cartao.id);
              },
            ),
          ),
        );
        _carregarCartoes();
      }
    }
  }

  Future<void> _confirmarReativar(CartaoCreditoModel cartao) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reativar Cartão'),
        content: Text(
          'Deseja reativar o cartão "${cartao.nome}"?\n\n'
          'Ele voltará a aparecer nas listas.',
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
      _reativarCartao(cartao.id);
    }
  }

  Future<void> _reativarCartao(String id) async {
    final provider = context.read<CartaoCreditoProvider>();
    final sucesso = await provider.reativarCartao(id);

    if (mounted && sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cartão reativado!'),
          backgroundColor: Colors.green,
        ),
      );
      _carregarCartoes();
    }
  }
}
