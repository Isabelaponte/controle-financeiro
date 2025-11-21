import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/core/constants/api_constants.dart';
import 'package:frontend/features/models/meta_financeira_model.dart';

class MetaFinanceiraService {
  final ApiClient _apiClient;

  MetaFinanceiraService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  /// Busca uma meta por ID
  Future<MetaFinanceiraModel> buscarPorId(String id) async {
    return _apiClient.get(
      ApiConstants.metaFinanceiraPorId(id),
      (json) => MetaFinanceiraModel.fromJson(json),
    );
  }

  /// Lista todas as metas de um usuário
  Future<List<MetaFinanceiraModel>> listarPorUsuario(String usuarioId) async {
    return _apiClient.get(
      ApiConstants.metasPorUsuario(usuarioId),
      (json) =>
          (json as List).map((e) => MetaFinanceiraModel.fromJson(e)).toList(),
    );
  }

  /// Lista metas em andamento
  Future<List<MetaFinanceiraModel>> listarEmAndamento(String usuarioId) async {
    return _apiClient.get(
      ApiConstants.metasEmAndamento(usuarioId),
      (json) =>
          (json as List).map((e) => MetaFinanceiraModel.fromJson(e)).toList(),
    );
  }

  /// Lista metas concluídas
  Future<List<MetaFinanceiraModel>> listarConcluidas(String usuarioId) async {
    return _apiClient.get(
      ApiConstants.metasConcluidas(usuarioId),
      (json) =>
          (json as List).map((e) => MetaFinanceiraModel.fromJson(e)).toList(),
    );
  }

  /// Busca o resumo das metas
  Future<ResumoMetasModel> buscarResumo(String usuarioId) async {
    return _apiClient.get(
      ApiConstants.resumoMetas(usuarioId),
      (json) => ResumoMetasModel.fromJson(json),
    );
  }

  /// Cria uma nova meta
  Future<MetaFinanceiraModel> criar({
    required String nome,
    required double valorDesejado,
    required DateTime dataInicio,
    required String usuarioId,
    double? valorAtual,
    DateTime? dataAlvo,
    String? categoriaId,
  }) async {
    return _apiClient.post(ApiConstants.metasFinanceiras, {
      'nome': nome,
      'valorDesejado': valorDesejado,
      'dataInicio': dataInicio.toIso8601String().split('T')[0],
      'usuarioId': usuarioId,
      if (valorAtual != null) 'valorAtual': valorAtual,
      if (dataAlvo != null)
        'dataAlvo': dataAlvo.toIso8601String().split('T')[0],
      if (categoriaId != null) 'categoriaId': categoriaId,
    }, (json) => MetaFinanceiraModel.fromJson(json));
  }

  /// Atualiza uma meta
  Future<MetaFinanceiraModel> atualizar(
    String id, {
    String? nome,
    double? valorDesejado,
    DateTime? dataInicio,
    DateTime? dataAlvo,
    String? categoriaId,
  }) async {
    return _apiClient.put(
      ApiConstants.metaFinanceiraPorId(id),
      {
        if (nome != null) 'nome': nome,
        if (valorDesejado != null) 'valorDesejado': valorDesejado,
        if (dataInicio != null)
          'dataInicio': dataInicio.toIso8601String().split('T')[0],
        if (dataAlvo != null)
          'dataAlvo': dataAlvo.toIso8601String().split('T')[0],
        if (categoriaId != null) 'categoriaId': categoriaId,
      },
      (json) => MetaFinanceiraModel.fromJson(json),
    );
  }

  /// Adiciona valor a uma meta
  Future<MetaFinanceiraModel> adicionarValor(String id, double valor) async {
    return _apiClient.patch(
      ApiConstants.adicionarValorMeta(id),
      {'valor': valor},
      (json) => MetaFinanceiraModel.fromJson(json),
    );
  }

  /// Subtrai valor de uma meta
  Future<MetaFinanceiraModel> subtrairValor(String id, double valor) async {
    return _apiClient.patch(
      ApiConstants.subtrairValorMeta(id),
      {'valor': valor},
      (json) => MetaFinanceiraModel.fromJson(json),
    );
  }

  /// Marca meta como concluída
  Future<MetaFinanceiraModel> marcarConcluida(String id) async {
    return _apiClient.patch(
      ApiConstants.marcarMetaConcluida(id),
      {},
      (json) => MetaFinanceiraModel.fromJson(json),
    );
  }

  /// Deleta uma meta
  Future<void> deletar(String id) async {
    await _apiClient.delete(ApiConstants.metaFinanceiraPorId(id));
  }
}
