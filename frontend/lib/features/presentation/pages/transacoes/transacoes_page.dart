import 'package:flutter/material.dart';
import 'package:frontend/features/models/transacao_model.dart';
import 'package:frontend/features/presentation/pages/transacoes/widgets/balanco_total.dart';
import 'package:frontend/features/presentation/pages/transacoes/widgets/secao_transacoes.dart';
import 'package:frontend/features/presentation/providers/transacao_provider.dart';
import 'package:frontend/features/shared/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:frontend/core/app_colors.dart';
import 'package:frontend/features/presentation/providers/auth_provider.dart';

class TransacoesPage extends StatefulWidget {
  const TransacoesPage({super.key});

  @override
  State<TransacoesPage> createState() => _TransacoesPageState();
}

class _TransacoesPageState extends State<TransacoesPage> {
  String _selectedFilter = 'Geral';
  String _selectedMonth = 'Novembro 2025';

  // TODO: Substituir por dados reais da API
  final List<String> _meses = [
    'Agosto 2025',
    'Setembro 2025',
    'Outubro 2025',
    'Novembro 2025',
  ];

  // Mock de transações para demonstração
  List<TransacaoModel> get _transacoesMock {
    return context.watch<TransacaoProvider>().transacoes;
  }

  double get _balancoTotal {
    return context.watch<TransacaoProvider>().balancoTotal;
  }

  Map<String, List<TransacaoModel>> get _transacoesAgrupadas {
    return context.watch<TransacaoProvider>().transacoesAgrupadas;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransacaoProvider>();

    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _atualizarTransacoes,
              child: _buildBody(provider),
            ),
          ),
          BalancoTotal(valor: _balancoTotal),
        ],
      ),
    );
  }

  Widget _buildBody(TransacaoProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.status == TransacaoStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.red),
            const SizedBox(height: 16),
            Text(
              provider.errorMessage ?? 'Erro ao carregar transações',
              style: TextStyle(color: AppColors.grayDark),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dropdown de mês
          Center(
            child: MonthDropdown(
              months: _meses,
              onChanged: (month) {
                setState(() => _selectedMonth = month);
                // TODO: Carregar transações do mês selecionado
              },
            ),
          ),
          const SizedBox(height: 16),

          // Filtros
          FilterChips(
            onFilterChanged: (filter) {
              setState(() => _selectedFilter = filter);
              // TODO: Filtrar transações
            },
          ),
          const SizedBox(height: 30),

          // Lista de transações agrupadas por data
          if (_transacoesMock.isEmpty)
            _buildEmptyState()
          else
            ..._transacoesAgrupadas.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SecaoTransacoes(
                  titulo: entry.key,
                  transacoes: entry.value,
                ),
              );
            }),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: AppColors.grayDark,
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhuma transação',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkPurple,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Adicione transações para começar\na acompanhar suas finanças',
              style: TextStyle(fontSize: 14, color: AppColors.grayDark),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transações',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0, top: 4.0),
              child: Text(
                'Todos os lançamentos',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
      ),
      toolbarHeight: 90,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
      ),
      backgroundColor: AppColors.purpleLight,
      foregroundColor: AppColors.purpleDark,
    );
  }

  Future<void> _atualizarTransacoes() async {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.user;

    if (user == null) return;

    final transacaoProvider = context.read<TransacaoProvider>();
    await transacaoProvider.carregarTransacoes(user.id);
  }
}
