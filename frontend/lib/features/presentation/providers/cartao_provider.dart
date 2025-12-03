import 'package:flutter/material.dart';
import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/features/models/catao_model.dart';
import 'package:frontend/features/models/fatura_model.dart';
import 'package:frontend/features/services/cartao_service.dart';
import 'package:frontend/features/services/fatura_service.dart';

enum CartaoCreditoStatus { initial, loading, success, error }

class CartaoCreditoProvider extends ChangeNotifier {
  final CartaoCreditoService _cartaoService;
  final FaturaService _faturaService;

  CartaoCreditoProvider({
    CartaoCreditoService? cartaoService,
    FaturaService? faturaService,
  }) : _cartaoService = cartaoService ?? CartaoCreditoService(),
       _faturaService = faturaService ?? FaturaService();

  List<CartaoCreditoModel> _cartoes = [];
  Map<String, FaturaModel?> _faturasPorCartao = {};
  CartaoCreditoStatus _status = CartaoCreditoStatus.initial;
  String? _errorMessage;
  bool _isAuthError = false;

  // Getters
  List<CartaoCreditoModel> get cartoes => _cartoes;
  List<CartaoCreditoModel> get cartoesAtivos =>
      _cartoes.where((c) => c.ativo).toList();
  List<CartaoCreditoModel> get cartoesInativos =>
      _cartoes.where((c) => !c.ativo).toList();
  Map<String, FaturaModel?> get faturasPorCartao => _faturasPorCartao;
  CartaoCreditoStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == CartaoCreditoStatus.loading;
  bool get isAuthError => _isAuthError;

  /// Retorna a fatura de um cartão específico
  FaturaModel? getFaturaDoCartao(String cartaoId) {
    return _faturasPorCartao[cartaoId];
  }

  /// Retorna o valor da fatura atual de um cartão
  double getValorFaturaAtual(String cartaoId) {
    return _faturasPorCartao[cartaoId]?.valorTotal ?? 0.0;
  }

  // Soma de todos os limites
  double get limiteTotal {
    return _cartoes.fold(0.0, (sum, cartao) => sum + cartao.limiteTotal);
  }

  String get limiteTotalFormatado {
    return 'R\$ ${limiteTotal.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  /// Carrega todos os cartões ativos do usuário e suas faturas
  Future<void> carregarCartoes(String usuarioId) async {
    _status = CartaoCreditoStatus.loading;
    _errorMessage = null;
    _isAuthError = false;
    notifyListeners();

    try {
      _cartoes = await _cartaoService.listarAtivosPorUsuario(usuarioId);

      await _carregarFaturas();

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

  Future<void> carregarTodosCartoes(String usuarioId) async {
    _status = CartaoCreditoStatus.loading;
    _errorMessage = null;
    _isAuthError = false;
    notifyListeners();

    try {
      _cartoes = await _cartaoService.listarPorUsuario(usuarioId);

      await _carregarFaturas();

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

  /// Carrega as faturas atuais de todos os cartões
  Future<void> _carregarFaturas() async {
    _faturasPorCartao.clear();

    for (var cartao in _cartoes) {
      try {
        final fatura = await _faturaService.buscarFaturaAtual(cartao.id);
        _faturasPorCartao[cartao.id] = fatura;
      } catch (e) {
        // Se não encontrar fatura, deixa como null
        _faturasPorCartao[cartao.id] = null;
      }
    }
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

  /// Atualiza um cartão existente
  Future<bool> atualizarCartao(
    String id, {
    String? nome,
    String? icone,
    double? limiteTotal,
    int? diaFechamento,
    int? diaVencimento,
    String? categoriaId,
  }) async {
    try {
      final cartaoAtualizado = await _cartaoService.atualizar(
        id,
        nome: nome,
        icone: icone,
        limiteTotal: limiteTotal,
        diaFechamento: diaFechamento,
        diaVencimento: diaVencimento,
        categoriaId: categoriaId,
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

  Future<bool> reativarCartao(String id) async {
    try {
      await _cartaoService.ativar(id);
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
    _faturasPorCartao = {};
    _status = CartaoCreditoStatus.initial;
    _errorMessage = null;
    _isAuthError = false;
    notifyListeners();
  }
}
