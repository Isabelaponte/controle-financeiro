import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/core/constants/api_constants.dart';
import 'package:frontend/features/models/fatura_model.dart';

class FaturaService {
  final ApiClient _apiClient;

  FaturaService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Busca uma fatura por ID
  Future<FaturaModel> buscarPorId(String id) async {
    return _apiClient.get(
      ApiConstants.faturaPorId(id),
      (json) => FaturaModel.fromJson(json),
    );
  }

  /// Lista todas as faturas de um cartão
  Future<List<FaturaModel>> listarPorCartao(String cartaoId) async {
    return _apiClient.get(
      ApiConstants.faturasPorCartao(cartaoId),
      (json) => (json as List).map((e) => FaturaModel.fromJson(e)).toList(),
    );
  }

  /// Lista faturas pendentes de um cartão
  Future<List<FaturaModel>> listarPendentesPorCartao(String cartaoId) async {
    return _apiClient.get(
      ApiConstants.faturasPendentesPorCartao(cartaoId),
      (json) => (json as List).map((e) => FaturaModel.fromJson(e)).toList(),
    );
  }

  /// Busca a fatura atual (primeira pendente) de um cartão
  Future<FaturaModel?> buscarFaturaAtual(String cartaoId) async {
    try {
      final faturas = await listarPendentesPorCartao(cartaoId);
      if (faturas.isEmpty) return null;

      // Retorna a fatura mais próxima do vencimento
      faturas.sort((a, b) => a.dataVencimento.compareTo(b.dataVencimento));
      return faturas.first;
    } catch (e) {
      return null;
    }
  }

  /// Lista faturas vencidas do usuário
  Future<List<FaturaModel>> listarVencidas(String usuarioId) async {
    return _apiClient.get(
      ApiConstants.faturasVencidas(usuarioId),
      (json) => (json as List).map((e) => FaturaModel.fromJson(e)).toList(),
    );
  }

  /// Cria uma nova fatura
  Future<FaturaModel> criar({
    required String cartaoId,
    required double valorTotal,
    required DateTime dataVencimento,
  }) async {
    return _apiClient.post(ApiConstants.faturas, {
      'cartaoId': cartaoId,
      'valorTotal': valorTotal,
      'dataVencimento': dataVencimento.toIso8601String().split('T')[0],
    }, (json) => FaturaModel.fromJson(json));
  }

  /// Atualiza uma fatura
  Future<FaturaModel> atualizar(
    String id, {
    double? valorTotal,
    DateTime? dataVencimento,
  }) async {
    return _apiClient.put(ApiConstants.faturaPorId(id), {
      if (valorTotal != null) 'valorTotal': valorTotal,
      if (dataVencimento != null)
        'dataVencimento': dataVencimento.toIso8601String().split('T')[0],
    }, (json) => FaturaModel.fromJson(json));
  }

  /// Marca fatura como paga
  Future<FaturaModel> pagarFatura(String id) async {
    return _apiClient.patch(
      ApiConstants.pagarFatura(id),
      {},
      (json) => FaturaModel.fromJson(json),
    );
  }

  /// Deleta uma fatura
  Future<void> deletar(String id) async {
    await _apiClient.delete(ApiConstants.faturaPorId(id));
  }
}
