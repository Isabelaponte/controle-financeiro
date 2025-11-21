import 'package:flutter/material.dart';
import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/features/models/meta_financeira_model.dart';
import 'package:frontend/features/services/meta_financeira_service.dart';

enum MetaStatus { initial, loading, success, error }

class MetaFinanceiraProvider extends ChangeNotifier {
  final MetaFinanceiraService _metaService;

  MetaFinanceiraProvider({MetaFinanceiraService? metaService})
    : _metaService = metaService ?? MetaFinanceiraService();

  List<MetaFinanceiraModel> _metas = [];
  ResumoMetasModel? _resumo;
  MetaStatus _status = MetaStatus.initial;
  String? _errorMessage;
  bool _isAuthError = false;

  // Getters
  List<MetaFinanceiraModel> get metas => _metas;
  List<MetaFinanceiraModel> get metasEmAndamento =>
      _metas.where((m) => !m.concluida).toList();
  List<MetaFinanceiraModel> get metasConcluidas =>
      _metas.where((m) => m.concluida).toList();
  ResumoMetasModel? get resumo => _resumo;
  MetaStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == MetaStatus.loading;
  bool get isAuthError => _isAuthError;

  /// Carrega metas em andamento e resumo
  Future<void> carregarMetas(String usuarioId) async {
    _status = MetaStatus.loading;
    _errorMessage = null;
    _isAuthError = false;
    notifyListeners();

    try {
      final results = await Future.wait([
        _metaService.listarEmAndamento(usuarioId),
        _metaService.buscarResumo(usuarioId),
      ]);

      _metas = results[0] as List<MetaFinanceiraModel>;
      _resumo = results[1] as ResumoMetasModel;
      _status = MetaStatus.success;
    } on ApiException catch (e) {
      _status = MetaStatus.error;
      _errorMessage = e.message;
      _isAuthError = e.isAuthError;
    } catch (e) {
      _status = MetaStatus.error;
      _errorMessage = 'Erro inesperado ao carregar metas';
    }
    notifyListeners();
  }

  /// Carrega todas as metas (em andamento + concluídas)
  Future<void> carregarTodasMetas(String usuarioId) async {
    _status = MetaStatus.loading;
    _errorMessage = null;
    _isAuthError = false;
    notifyListeners();

    try {
      _metas = await _metaService.listarPorUsuario(usuarioId);
      _resumo = await _metaService.buscarResumo(usuarioId);
      _status = MetaStatus.success;
    } on ApiException catch (e) {
      _status = MetaStatus.error;
      _errorMessage = e.message;
      _isAuthError = e.isAuthError;
    } catch (e) {
      _status = MetaStatus.error;
      _errorMessage = 'Erro inesperado ao carregar metas';
    }
    notifyListeners();
  }

  /// Adiciona uma nova meta
  Future<bool> adicionarMeta({
    required String nome,
    required double valorDesejado,
    required DateTime dataInicio,
    required String usuarioId,
    double? valorAtual,
    DateTime? dataAlvo,
    String? categoriaId,
  }) async {
    try {
      final novaMeta = await _metaService.criar(
        nome: nome,
        valorDesejado: valorDesejado,
        dataInicio: dataInicio,
        usuarioId: usuarioId,
        valorAtual: valorAtual,
        dataAlvo: dataAlvo,
        categoriaId: categoriaId,
      );
      _metas.add(novaMeta);
      // Atualiza resumo
      _resumo = await _metaService.buscarResumo(usuarioId);
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isAuthError = e.isAuthError;
      notifyListeners();
      return false;
    }
  }

  /// Adiciona valor a uma meta
  Future<bool> adicionarValor(String id, double valor, String usuarioId) async {
    try {
      final metaAtualizada = await _metaService.adicionarValor(id, valor);
      final index = _metas.indexWhere((m) => m.id == id);
      if (index != -1) {
        _metas[index] = metaAtualizada;
      }
      // Atualiza resumo
      _resumo = await _metaService.buscarResumo(usuarioId);
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isAuthError = e.isAuthError;
      notifyListeners();
      return false;
    }
  }

  /// Subtrai valor de uma meta
  Future<bool> subtrairValor(String id, double valor, String usuarioId) async {
    try {
      final metaAtualizada = await _metaService.subtrairValor(id, valor);
      final index = _metas.indexWhere((m) => m.id == id);
      if (index != -1) {
        _metas[index] = metaAtualizada;
      }
      // Atualiza resumo
      _resumo = await _metaService.buscarResumo(usuarioId);
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isAuthError = e.isAuthError;
      notifyListeners();
      return false;
    }
  }

  /// Marca meta como concluída
  Future<bool> marcarConcluida(String id) async {
    try {
      final metaAtualizada = await _metaService.marcarConcluida(id);
      final index = _metas.indexWhere((m) => m.id == id);
      if (index != -1) {
        _metas[index] = metaAtualizada;
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

  /// Remove uma meta
  Future<bool> removerMeta(String id, String usuarioId) async {
    try {
      await _metaService.deletar(id);
      _metas.removeWhere((m) => m.id == id);
      // Atualiza resumo
      _resumo = await _metaService.buscarResumo(usuarioId);
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
    _metas = [];
    _resumo = null;
    _status = MetaStatus.initial;
    _errorMessage = null;
    _isAuthError = false;
    notifyListeners();
  }
}
