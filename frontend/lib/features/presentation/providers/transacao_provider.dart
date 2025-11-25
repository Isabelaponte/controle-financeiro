import 'package:flutter/material.dart';
import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/features/models/transacao_model.dart';
import 'package:frontend/features/services/transacao_service.dart';

enum TransacaoStatus { initial, loading, success, error }

class TransacaoProvider extends ChangeNotifier {
  final TransacaoService _transacaoService;

  TransacaoProvider({TransacaoService? transacaoService})
    : _transacaoService = transacaoService ?? TransacaoService();

  List<TransacaoModel> _transacoes = [];
  TransacaoStatus _status = TransacaoStatus.initial;
  String? _errorMessage;
  bool _isAuthError = false;

  // Getters
  List<TransacaoModel> get transacoes => _transacoes;
  List<TransacaoModel> get receitas =>
      _transacoes.where((t) => t.isReceita).toList();
  List<TransacaoModel> get despesas =>
      _transacoes.where((t) => t.isDespesa).toList();
  TransacaoStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == TransacaoStatus.loading;
  bool get isAuthError => _isAuthError;

  // Balanço total
  double get balancoTotal {
    double total = 0.0;
    for (var transacao in _transacoes) {
      if (transacao.isReceita) {
        total += transacao.valor;
      } else {
        total -= transacao.valor;
      }
    }
    return total;
  }

  String get balancoTotalFormatado {
    final sinal = balancoTotal >= 0 ? '+' : '';
    return '$sinal R\$ ${balancoTotal.abs().toStringAsFixed(2).replaceAll('.', ',')}';
  }

  // Agrupa transações por data
  Map<String, List<TransacaoModel>> get transacoesAgrupadas {
    final Map<String, List<TransacaoModel>> agrupadas = {};

    for (var transacao in _transacoes) {
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
      'janeiro',
      'fevereiro',
      'março',
      'abril',
      'maio',
      'junho',
      'julho',
      'agosto',
      'setembro',
      'outubro',
      'novembro',
      'dezembro',
    ];

    final diaSemana = diasSemana[data.weekday % 7];
    final dia = data.day;
    final mes = meses[data.month - 1];

    return '$diaSemana, $dia de $mes';
  }

  /// Carrega todas as transações do usuário
  Future<void> carregarTransacoes(String usuarioId) async {
    _status = TransacaoStatus.loading;
    _errorMessage = null;
    _isAuthError = false;
    notifyListeners();

    try {
      _transacoes = await _transacaoService.listarTodasTransacoes(usuarioId);
      _status = TransacaoStatus.success;
    } on ApiException catch (e) {
      _status = TransacaoStatus.error;
      _errorMessage = e.message;
      _isAuthError = e.isAuthError;
    } catch (e) {
      _status = TransacaoStatus.error;
      _errorMessage = 'Erro inesperado ao carregar transações';
    }
    notifyListeners();
  }

  /// Carrega transações por período
  Future<void> carregarPorPeriodo(
    String usuarioId,
    DateTime dataInicio,
    DateTime dataFim,
  ) async {
    _status = TransacaoStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _transacoes = await _transacaoService.listarPorPeriodo(
        usuarioId,
        dataInicio,
        dataFim,
      );
      _status = TransacaoStatus.success;
    } on ApiException catch (e) {
      _status = TransacaoStatus.error;
      _errorMessage = e.message;
      _isAuthError = e.isAuthError;
    } catch (e) {
      _status = TransacaoStatus.error;
      _errorMessage = 'Erro ao carregar transações';
    }
    notifyListeners();
  }

  /// Marca receita como recebida
  Future<bool> marcarReceitaRecebida(String id) async {
    try {
      final transacaoAtualizada = await _transacaoService.marcarReceitaRecebida(
        id,
      );
      final index = _transacoes.indexWhere((t) => t.id == id);
      if (index != -1) {
        _transacoes[index] = transacaoAtualizada;
      }
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isAuthError = e.isAuthError;
      notifyListeners();
      return false;
    }
  }

  /// Marca despesa geral como paga
  Future<bool> pagarDespesaGeral(String id) async {
    try {
      final transacaoAtualizada = await _transacaoService.pagarDespesaGeral(id);
      final index = _transacoes.indexWhere((t) => t.id == id);
      if (index != -1) {
        _transacoes[index] = transacaoAtualizada;
      }
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isAuthError = e.isAuthError;
      notifyListeners();
      return false;
    }
  }

  /// Deleta uma transação
  Future<bool> deletarTransacao(String id, TipoTransacao tipo) async {
    try {
      await _transacaoService.deletar(id, tipo);
      _transacoes.removeWhere((t) => t.id == id);
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isAuthError = e.isAuthError;
      notifyListeners();
      return false;
    }
  }

  void limparErro() {
    _errorMessage = null;
    _isAuthError = false;
    notifyListeners();
  }

  void limparDados() {
    _transacoes = [];
    _status = TransacaoStatus.initial;
    _errorMessage = null;
    _isAuthError = false;
    notifyListeners();
  }
}
