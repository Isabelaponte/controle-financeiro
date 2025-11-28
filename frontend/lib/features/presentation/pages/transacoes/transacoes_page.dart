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
  late String _selectedMonth;
  late List<String> _meses;

  @override
  void initState() {
    super.initState();
    _meses = _gerarListaMeses();
    _selectedMonth = _meses.first; // Seleciona o mês atual por padrão
    
    // Carrega os dados assim que a tela é criada
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _carregarDadosIniciais();
    });
  }

  List<String> _gerarListaMeses() {
    final agora = DateTime.now();
    final List<String> meses = [];
    
    // Gera últimos 12 meses
    for (int i = 0; i < 12; i++) {
      final mes = DateTime(agora.year, agora.month - i, 1);
      meses.add(_formatarMesAno(mes));
    }
    
    return meses;
  }

  String _formatarMesAno(DateTime data) {
    final meses = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    return '${meses[data.month - 1]} ${data.year}';
  }

  Future<void> _carregarDadosIniciais() async {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.user;
    
    if (user == null) return;

    final transacaoProvider = context.read<TransacaoProvider>();
    
    // Só carrega se ainda não tiver dados ou se estiver no estado inicial
    if (transacaoProvider.status == TransacaoStatus.initial || 
        transacaoProvider.transacoes.isEmpty) {
      await transacaoProvider.carregarTransacoes(user.id);
    }
  }

  // Transações filtradas
  List<TransacaoModel> get _transacoesFiltradas {
    final provider = context.watch<TransacaoProvider>();
    var transacoes = provider.transacoes;

    // Aplica filtro de tipo (Geral ou Cartões)
    if (_selectedFilter == 'Cartões') {
      transacoes = transacoes.where((t) => t.tipo == TipoTransacao.despesaCartao).toList();
    }

    // Aplica filtro de mês
    final mesSelecionado = _obterMesSelecionado();
    if (mesSelecionado != null) {
      transacoes = transacoes.where((t) {
        return t.data.month == mesSelecionado.month && 
               t.data.year == mesSelecionado.year;
      }).toList();
    }

    return transacoes;
  }

  double get _balancoTotalFiltrado {
    double total = 0.0;
    for (var transacao in _transacoesFiltradas) {
      if (transacao.isReceita) {
        total += transacao.valor;
      } else {
        total -= transacao.valor;
      }
    }
    return total;
  }

  Map<String, List<TransacaoModel>> get _transacoesAgrupadasFiltradas {
    final Map<String, List<TransacaoModel>> agrupadas = {};
    
    for (var transacao in _transacoesFiltradas) {
      final dataKey = _formatarDataGrupo(transacao.data);
      if (!agrupadas.containsKey(dataKey)) {
        agrupadas[dataKey] = [];
      }
      agrupadas[dataKey]!.add(transacao);
    }
    
    return agrupadas;
  }

  String _formatarDataGrupo(DateTime data) {
    final diasSemana = ['dom.', 'seg.', 'ter.', 'qua.', 'qui.', 'sex.', 'sáb.'];
    final meses = [
      'janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho',
      'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro'
    ];
    
    final diaSemana = diasSemana[data.weekday % 7];
    final dia = data.day;
    final mes = meses[data.month - 1];
    
    return '$diaSemana, $dia de $mes';
  }

  DateTime? _obterMesSelecionado() {
    // Extrai mês e ano do texto selecionado
    final partes = _selectedMonth.split(' ');
    if (partes.length != 2) return null;
    
    final mesesMap = {
      'Janeiro': 1, 'Fevereiro': 2, 'Março': 3, 'Abril': 4,
      'Maio': 5, 'Junho': 6, 'Julho': 7, 'Agosto': 8,
      'Setembro': 9, 'Outubro': 10, 'Novembro': 11, 'Dezembro': 12
    };
    
    final mes = mesesMap[partes[0]];
    final ano = int.tryParse(partes[1]);
    
    if (mes == null || ano == null) return null;
    
    return DateTime(ano, mes);
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
          BalancoTotal(valor: _balancoTotalFiltrado),
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
              },
            ),
          ),
          const SizedBox(height: 16),

          // Filtros
          FilterChips(
            onFilterChanged: (filter) {
              setState(() => _selectedFilter = filter);
            },
          ),
          const SizedBox(height: 30),

          // Lista de transações agrupadas por data
          if (_transacoesFiltradas.isEmpty)
            _buildEmptyState()
          else
            ..._transacoesAgrupadasFiltradas.entries.map((entry) {
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