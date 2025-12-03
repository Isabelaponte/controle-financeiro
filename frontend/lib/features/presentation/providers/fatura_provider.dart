import 'package:flutter/material.dart';
import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/features/models/fatura_model.dart';
import 'package:frontend/features/services/fatura_service.dart';

class FaturaProvider with ChangeNotifier {
  final FaturaService _faturaService;

  FaturaProvider({FaturaService? faturaService})
    : _faturaService = faturaService ?? FaturaService();

  List<FaturaModel> _faturas = [];
  List<FaturaModel> _faturasPendentes = [];
  List<FaturaModel> _faturasVencidas = [];
  FaturaModel? _faturaAtual;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthError = false;

  // Getters
  List<FaturaModel> get faturas => _faturas;
  List<FaturaModel> get faturasPendentes => _faturasPendentes;
  List<FaturaModel> get faturasVencidas => _faturasVencidas;
  FaturaModel? get faturaAtual => _faturaAtual;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthError => _isAuthError;

  /// Carrega todas as faturas de um cartão
  Future<void> carregarFaturas(String cartaoId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _faturas = await _faturaService.listarPorCartao(cartaoId);
      _faturas.sort((a, b) => b.dataVencimento.compareTo(a.dataVencimento));
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isAuthError = e.isAuthError;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Carrega faturas pendentes de um cartão
  Future<void> carregarFaturasPendentes(String cartaoId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _faturasPendentes = await _faturaService.listarPendentesPorCartao(
        cartaoId,
      );
      _faturasPendentes.sort(
        (a, b) => a.dataVencimento.compareTo(b.dataVencimento),
      );
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isAuthError = e.isAuthError;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Carrega faturas vencidas do usuário
  Future<void> carregarFaturasVencidas(String usuarioId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _faturasVencidas = await _faturaService.listarVencidas(usuarioId);
      _faturasVencidas.sort(
        (a, b) => b.dataVencimento.compareTo(a.dataVencimento),
      );
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isAuthError = e.isAuthError;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Busca a fatura atual (primeira pendente) de um cartão
  Future<void> carregarFaturaAtual(String cartaoId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _faturaAtual = await _faturaService.buscarFaturaAtual(cartaoId);
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isAuthError = e.isAuthError;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Busca uma fatura por ID
  Future<FaturaModel?> buscarFaturaPorId(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final fatura = await _faturaService.buscarPorId(id);
      _isLoading = false;
      notifyListeners();
      return fatura;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isAuthError = e.isAuthError;
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// Cria uma nova fatura
  Future<bool> criarFatura({
    required String cartaoId,
    required double valorTotal,
    required DateTime dataVencimento,
  }) async {
    try {
      final novaFatura = await _faturaService.criar(
        cartaoId: cartaoId,
        valorTotal: valorTotal,
        dataVencimento: dataVencimento,
      );

      _faturas.add(novaFatura);
      _faturas.sort((a, b) => b.dataVencimento.compareTo(a.dataVencimento));
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isAuthError = e.isAuthError;
      notifyListeners();
      return false;
    }
  }

  /// Atualiza uma fatura
  Future<bool> atualizarFatura(
    String id, {
    double? valorTotal,
    DateTime? dataVencimento,
  }) async {
    try {
      final faturaAtualizada = await _faturaService.atualizar(
        id,
        valorTotal: valorTotal,
        dataVencimento: dataVencimento,
      );

      final index = _faturas.indexWhere((f) => f.id == id);
      if (index != -1) {
        _faturas[index] = faturaAtualizada;
        _faturas.sort((a, b) => b.dataVencimento.compareTo(a.dataVencimento));
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

  /// Marca fatura como paga
  Future<bool> pagarFatura(String id) async {
    try {
      final faturaPaga = await _faturaService.pagarFatura(id);

      // Atualiza na lista principal
      final index = _faturas.indexWhere((f) => f.id == id);
      if (index != -1) {
        _faturas[index] = faturaPaga;
      }

      // Remove das pendentes
      _faturasPendentes.removeWhere((f) => f.id == id);

      // Remove das vencidas
      _faturasVencidas.removeWhere((f) => f.id == id);

      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isAuthError = e.isAuthError;
      notifyListeners();
      return false;
    }
  }

  /// Deleta uma fatura
  Future<bool> deletarFatura(String id) async {
    try {
      await _faturaService.deletar(id);

      _faturas.removeWhere((f) => f.id == id);
      _faturasPendentes.removeWhere((f) => f.id == id);
      _faturasVencidas.removeWhere((f) => f.id == id);

      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isAuthError = e.isAuthError;
      notifyListeners();
      return false;
    }
  }

  /// Limpa os dados
  void limpar() {
    _faturas = [];
    _faturasPendentes = [];
    _faturasVencidas = [];
    _faturaAtual = null;
    _errorMessage = null;
    _isAuthError = false;
    notifyListeners();
  }
}
