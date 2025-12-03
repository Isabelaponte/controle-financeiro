import 'package:flutter/material.dart';
import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/features/models/resumo_model.dart';
import 'package:frontend/features/services/resumo_service.dart';

enum ResumoStatus { initial, loading, success, error }

class ResumoProvider extends ChangeNotifier {
  final ResumoService _resumoService;

  ResumoProvider({ResumoService? resumoService})
    : _resumoService = resumoService ?? ResumoService();

  ResumoMensal? _resumoAtual;
  ResumoStatus _status = ResumoStatus.initial;
  String? _errorMessage;
  bool _isAuthError = false;

  ResumoMensal? get resumoAtual => _resumoAtual;
  ResumoStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == ResumoStatus.loading;
  bool get isAuthError => _isAuthError;

  double get totalGanhos => _resumoAtual?.totalGanhos ?? 0.0;
  double get totalGastos => _resumoAtual?.totalGastos ?? 0.0;
  double get saldo => _resumoAtual?.saldo ?? 0.0;

  String get totalGanhosFormatado {
    return _resumoAtual?.totalGanhosFormatado ?? 'R\$ 0,00';
  }

  String get totalGastosFormatado {
    return _resumoAtual?.totalGastosFormatado ?? 'R\$ 0,00';
  }

  String get saldoFormatado {
    return _resumoAtual?.saldoFormatado ?? 'R\$ 0,00';
  }

  bool get temSaldoPositivo => _resumoAtual?.temSaldoPositivo ?? true;

  Future<void> carregarResumoMensal({
    required String usuarioId,
  }) async {
    _status = ResumoStatus.loading;
    _errorMessage = null;
    _isAuthError = false;
    notifyListeners();

    try {
      _resumoAtual = await _resumoService.getResumoMensal(usuarioId: usuarioId);
      _status = ResumoStatus.success;
    } on ApiException catch (e) {
      _status = ResumoStatus.error;
      _errorMessage = e.message;
      _isAuthError = e.isAuthError;
    } catch (e) {
      _status = ResumoStatus.error;
      _errorMessage = 'Erro inesperado ao carregar resumo';
    }
    notifyListeners();
  }

  Future<void> atualizarResumo({
    required String usuarioId,
  }) async {
    await carregarResumoMensal(usuarioId: usuarioId);
  }

  void limparErro() {
    _errorMessage = null;
    _isAuthError = false;
    notifyListeners();
  }

  void limparDados() {
    _resumoAtual = null;
    _status = ResumoStatus.initial;
    _errorMessage = null;
    _isAuthError = false;
    notifyListeners();
  }
}
