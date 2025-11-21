import 'package:flutter/material.dart';
import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/features/models/catao_model.dart';
import 'package:frontend/features/services/cartao_service.dart';

enum CartaoCreditoStatus { initial, loading, success, error }

class CartaoCreditoProvider extends ChangeNotifier {
  final CartaoCreditoService _cartaoService;

  CartaoCreditoProvider({CartaoCreditoService? cartaoService})
    : _cartaoService = cartaoService ?? CartaoCreditoService();

  List<CartaoCreditoModel> _cartoes = [];
  CartaoCreditoStatus _status = CartaoCreditoStatus.initial;
  String? _errorMessage;
  bool _isAuthError = false;

  // Getters
  List<CartaoCreditoModel> get cartoes => _cartoes;
  List<CartaoCreditoModel> get cartoesAtivos =>
      _cartoes.where((c) => c.ativo).toList();
  CartaoCreditoStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == CartaoCreditoStatus.loading;
  bool get isAuthError => _isAuthError;

  // Soma de todos os limites
  double get limiteTotal {
    return _cartoes.fold(0.0, (sum, cartao) => sum + cartao.limiteTotal);
  }

  String get limiteTotalFormatado {
    return 'R\$ ${limiteTotal.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  /// Carrega todos os cartões ativos do usuário
  Future<void> carregarCartoes(String usuarioId) async {
    _status = CartaoCreditoStatus.loading;
    _errorMessage = null;
    _isAuthError = false;
    notifyListeners();

    try {
      _cartoes = await _cartaoService.listarAtivosPorUsuario(usuarioId);
      _status = CartaoCreditoStatus.success;
    } on ApiException catch (e) {
      _status = CartaoCreditoStatus.error;
      _errorMessage = e.message;
      _isAuthError = e.isAuthError;
    } catch (e) {
      _status = CartaoCreditoStatus.error;
      _errorMessage = 'Erro inesperado ao carregar cartões';
    }
    notifyListeners();
  }

  /// Adiciona um novo cartão
  Future<bool> adicionarCartao({
    required String nome,
    required double limiteTotal,
    required int diaFechamento,
    required int diaVencimento,
    required String usuarioId,
    String? icone,
  }) async {
    try {
      final novoCartao = await _cartaoService.criar(
        nome: nome,
        limiteTotal: limiteTotal,
        diaFechamento: diaFechamento,
        diaVencimento: diaVencimento,
        usuarioId: usuarioId,
        icone: icone,
      );
      _cartoes.add(novoCartao);
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isAuthError = e.isAuthError;
      notifyListeners();
      return false;
    }
  }

  /// Altera o limite de um cartão
  Future<bool> alterarLimite(String id, double novoLimite) async {
    try {
      final cartaoAtualizado = await _cartaoService.alterarLimite(
        id,
        novoLimite,
      );
      final index = _cartoes.indexWhere((c) => c.id == id);
      if (index != -1) {
        _cartoes[index] = cartaoAtualizado;
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

  /// Desativa um cartão
  Future<bool> desativarCartao(String id) async {
    try {
      await _cartaoService.desativar(id);
      _cartoes.removeWhere((c) => c.id == id);
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isAuthError = e.isAuthError;
      notifyListeners();
      return false;
    }
  }

  /// Remove um cartão
  Future<bool> removerCartao(String id) async {
    try {
      await _cartaoService.deletar(id);
      _cartoes.removeWhere((c) => c.id == id);
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
    _cartoes = [];
    _status = CartaoCreditoStatus.initial;
    _errorMessage = null;
    _isAuthError = false;
    notifyListeners();
  }
}
