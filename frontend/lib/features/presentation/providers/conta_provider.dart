import 'package:flutter/material.dart';
import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/features/models/conta_model.dart';
import 'package:frontend/features/services/conta_service.dart';

enum ContaStatus { initial, loading, success, error }

class ContaProvider extends ChangeNotifier {
  final ContaService _contaService;

  ContaProvider({ContaService? contaService})
    : _contaService = contaService ?? ContaService();

  List<ContaModel> _contas = [];
  double _saldoTotal = 0.0;
  ContaStatus _status = ContaStatus.initial;
  String? _errorMessage;
  bool _isAuthError = false;

  // Getters
  List<ContaModel> get contas => _contas;
  List<ContaModel> get contasAtivas => _contas.where((c) => c.ativa).toList();
  List<ContaModel> get contasInativas => _contas.where((c) => !c.ativa).toList();
  double get saldoTotal => _saldoTotal;
  ContaStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == ContaStatus.loading;
  bool get isAuthError => _isAuthError;

  String get saldoTotalFormatado {
    return _saldoTotal.toStringAsFixed(2).replaceAll('.', ',');
  }

  Future<void> carregarTodasAsContas(String usuarioId) async {
    _status = ContaStatus.loading;
    _errorMessage = null;
    _isAuthError = false;
    notifyListeners();

    try {
      _contas = await _contaService.listarPorUsuario(usuarioId);
      _status = ContaStatus.success;
    } on ApiException catch (e) {
      _status = ContaStatus.error;
      _errorMessage = e.message;
      _isAuthError = e.isAuthError;
    } catch (e) {
      _status = ContaStatus.error;
      _errorMessage = 'Erro inesperado ao carregar contas';
    }
    notifyListeners();
  }

  Future<void> carregarContas(String usuarioId) async {
    _status = ContaStatus.loading;
    _errorMessage = null;
    _isAuthError = false;
    notifyListeners();

    try {
      _contas = await _contaService.listarAtivasPorUsuario(usuarioId);
      _status = ContaStatus.success;
    } on ApiException catch (e) {
      _status = ContaStatus.error;
      _errorMessage = e.message;
      _isAuthError = e.isAuthError;
    } catch (e) {
      _status = ContaStatus.error;
      _errorMessage = 'Erro inesperado ao carregar contas';
    }
    notifyListeners();
  }

  /// Carrega o saldo total do usuário
  Future<void> carregarSaldoTotal(String usuarioId) async {
    try {
      _saldoTotal = await _contaService.calcularSaldoTotal(usuarioId);
      notifyListeners();
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isAuthError = e.isAuthError;
    }
  }

  /// Carrega contas e saldo total de uma vez
  Future<void> carregarDados(String usuarioId) async {
    _status = ContaStatus.loading;
    _errorMessage = null;
    _isAuthError = false;
    notifyListeners();

    try {
      final results = await Future.wait([
        _contaService.listarAtivasPorUsuario(usuarioId),
        _contaService.calcularSaldoTotal(usuarioId),
      ]);

      _contas = results[0] as List<ContaModel>;
      _saldoTotal = results[1] as double;
      _status = ContaStatus.success;
    } on ApiException catch (e) {
      _status = ContaStatus.error;
      _errorMessage = e.message;
      _isAuthError = e.isAuthError;
    } catch (e) {
      _status = ContaStatus.error;
      _errorMessage = 'Erro inesperado';
    }
    notifyListeners();
  }

  /// Adiciona uma nova conta
  Future<bool> adicionarConta({
    required String nome,
    required String tipo,
    required double saldo,
    required String usuarioId,
    String? icone,
  }) async {
    try {
      final novaConta = await _contaService.criar(
        nome: nome,
        tipo: tipo,
        saldo: saldo,
        usuarioId: usuarioId,
        icone: icone,
      );
      _contas.add(novaConta);
      _saldoTotal += saldo;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isAuthError = e.isAuthError;
      notifyListeners();
      return false;
    }
  }

  /// Remove uma conta
  Future<bool> removerConta(String id) async {
    try {
      await _contaService.deletar(id);
      final conta = _contas.firstWhere((c) => c.id == id);
      _saldoTotal -= conta.saldo;
      _contas.removeWhere((c) => c.id == id);
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isAuthError = e.isAuthError;
      notifyListeners();
      return false;
    }
  }

  /// Atualiza uma conta existente
  Future<bool> atualizarConta(
    String id, {
    String? nome,
    String? tipo,
    String? icone,
  }) async {
    try {
      final contaAtualizada = await _contaService.atualizar(
        id,
        nome: nome,
        tipo: tipo,
        icone: icone,
      );
      final index = _contas.indexWhere((c) => c.id == id);
      if (index != -1) {
        _contas[index] = contaAtualizada;
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

  /// Desativa uma conta
  Future<bool> desativarConta(String id) async {
    try {
      await _contaService.desativar(id);
      final conta = _contas.firstWhere((c) => c.id == id);
      _saldoTotal -= conta.saldo;
      _contas.removeWhere((c) => c.id == id);
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isAuthError = e.isAuthError;
      notifyListeners();
      return false;
    }
  }

    Future<bool> reativarConta(String id) async {
    try {
      await _contaService.reativar(id);
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
    _contas = [];
    _saldoTotal = 0.0;
    _status = ContaStatus.initial;
    _errorMessage = null;
    _isAuthError = false;
    notifyListeners();
  }
}
