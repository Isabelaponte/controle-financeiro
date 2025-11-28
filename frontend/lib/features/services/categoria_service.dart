import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/features/models/categoria_model.dart';

class CategoriaService {
  final ApiClient _apiClient;

  CategoriaService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<CategoriaModel> buscarPorId(String id) async {
    return _apiClient.get(
      '/categorias/$id',
      (json) => CategoriaModel.fromJson(json),
    );
  }

  Future<List<CategoriaModel>> listarPorUsuario(String usuarioId) async {
    return _apiClient.get(
      '/categorias/usuario/$usuarioId',
      (json) => (json as List).map((e) => CategoriaModel.fromJson(e)).toList(),
    );
  }

  Future<List<CategoriaModel>> listarAtivasPorUsuario(String usuarioId) async {
    return _apiClient.get(
      '/categorias/usuario/$usuarioId/ativas',
      (json) => (json as List).map((e) => CategoriaModel.fromJson(e)).toList(),
    );
  }

  Future<CategoriaModel> criar({
    required String nome,
    required String usuarioId,
    String? cor,
    String? icone,
    String? descricao,
  }) async {
    return _apiClient.post('/categorias', {
      'nome': nome,
      'usuarioId': usuarioId,
      if (cor != null) 'cor': cor,
      if (icone != null) 'icone': icone,
      if (descricao != null) 'descricao': descricao,
    }, (json) => CategoriaModel.fromJson(json));
  }

  Future<CategoriaModel> atualizar(
    String id, {
    required String nome,
    String? cor,
    String? icone,
    String? descricao,
    bool? ativo,
  }) async {
    return _apiClient.put('/categorias/$id', {
      'nome': nome,
      if (cor != null) 'cor': cor,
      if (icone != null) 'icone': icone,
      if (descricao != null) 'descricao': descricao,
      if (ativo != null) 'ativo': ativo,
    }, (json) => CategoriaModel.fromJson(json));
  }

  Future<CategoriaModel> desativar(String id) async {
    return _apiClient.patch(
      '/categorias/$id/desativar',
      {},
      (json) => CategoriaModel.fromJson(json),
    );
  }
  
  Future<CategoriaModel> reativar(String id) async {
    return _apiClient.patch(
      '/categorias/$id/ativar',
      {},
      (json) => CategoriaModel.fromJson(json),
    );
  }
}
