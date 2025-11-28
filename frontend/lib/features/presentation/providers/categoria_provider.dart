import 'package:flutter/material.dart';
import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/features/models/categoria_model.dart';
import 'package:frontend/features/services/categoria_service.dart';

enum CategoriaStatus { initial, loading, success, error }

class CategoriaProvider extends ChangeNotifier {
  final CategoriaService _categoriaService;

  CategoriaProvider({CategoriaService? categoriaService})
    : _categoriaService = categoriaService ?? CategoriaService();

  List<CategoriaModel> _categorias = [];
  CategoriaStatus _status = CategoriaStatus.initial;
  String? _errorMessage;
  bool _isAuthError = false;

  List<CategoriaModel> get categorias => _categorias;
  List<CategoriaModel> get categoriasAtivas =>
      _categorias.where((c) => c.ativo).toList();
  CategoriaStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == CategoriaStatus.loading;
  bool get isAuthError => _isAuthError;

  Future<void> carregarCategorias(String usuarioId) async {
    _status = CategoriaStatus.loading;
    _errorMessage = null;
    _isAuthError = false;
    notifyListeners();

    try {
      _categorias = await _categoriaService.listarPorUsuario(usuarioId);
      _status = CategoriaStatus.success;
    } on ApiException catch (e) {
      _status = CategoriaStatus.error;
      _errorMessage = e.message;
      _isAuthError = e.isAuthError;
    } catch (e) {
      _status = CategoriaStatus.error;
      _errorMessage = 'Erro inesperado ao carregar categorias';
    }
    notifyListeners();
  }

  Future<void> carregarCategoriasAtivas(String usuarioId) async {
    _status = CategoriaStatus.loading;
    _errorMessage = null;
    _isAuthError = false;
    notifyListeners();

    try {
      _categorias = await _categoriaService.listarAtivasPorUsuario(usuarioId);
      _status = CategoriaStatus.success;
    } on ApiException catch (e) {
      _status = CategoriaStatus.error;
      _errorMessage = e.message;
      _isAuthError = e.isAuthError;
    } catch (e) {
      _status = CategoriaStatus.error;
      _errorMessage = 'Erro inesperado ao carregar categorias';
    }
    notifyListeners();
  }

  Future<bool> adicionarCategoria({
    required String nome,
    required String usuarioId,
    String? cor,
    String? icone,
    String? descricao,
  }) async {
    try {
      final novaCategoria = await _categoriaService.criar(
        nome: nome,
        usuarioId: usuarioId,
        cor: cor,
        icone: icone,
        descricao: descricao,
      );
      _categorias.add(novaCategoria);
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isAuthError = e.isAuthError;
      notifyListeners();
      return false;
    }
  }

  Future<bool> atualizarCategoria(
    String id, {
    required String nome,
    String? cor,
    String? icone,
    String? descricao,
  }) async {
    try {
      final categoriaAtualizada = await _categoriaService.atualizar(
        id,
        nome: nome,
        cor: cor,
        icone: icone,
        descricao: descricao,
      );
      final index = _categorias.indexWhere((c) => c.id == id);
      if (index != -1) {
        _categorias[index] = categoriaAtualizada;
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

  // Adicione este getter após categoriasAtivas:
  List<CategoriaModel> get categoriasInativas =>
      _categorias.where((c) => !c.ativo).toList();

  Future<bool> reativarCategoria(String id) async {
    try {
      await _categoriaService.reativar(id);
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isAuthError = e.isAuthError;
      notifyListeners();
      return false;
    }
  }

  Future<bool> desativarCategoria(String id) async {
    try {
      await _categoriaService.desativar(id);
      _categorias.removeWhere((c) => c.id == id);
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
    _categorias = [];
    _status = CategoriaStatus.initial;
    _errorMessage = null;
    _isAuthError = false;
    notifyListeners();
  }
}
