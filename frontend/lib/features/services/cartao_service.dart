import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/core/constants/api_constants.dart';
import 'package:frontend/features/models/catao_model.dart';

class CartaoCreditoService {
  final ApiClient _apiClient;

  CartaoCreditoService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  /// Busca um cartão por ID
  Future<CartaoCreditoModel> buscarPorId(String id) async {
    return _apiClient.get(
      ApiConstants.cartaoCreditoPorId(id),
      (json) => CartaoCreditoModel.fromJson(json),
    );
  }

  /// Lista todos os cartões de um usuário
  Future<List<CartaoCreditoModel>> listarPorUsuario(String usuarioId) async {
    return _apiClient.get(
      ApiConstants.cartoesCreditoPorUsuario(usuarioId),
      (json) =>
          (json as List).map((e) => CartaoCreditoModel.fromJson(e)).toList(),
    );
  }

  /// Lista apenas cartões ativos de um usuário
  Future<List<CartaoCreditoModel>> listarAtivosPorUsuario(
    String usuarioId,
  ) async {
    return _apiClient.get(
      ApiConstants.cartoesCreditoAtivosPorUsuario(usuarioId),
      (json) =>
          (json as List).map((e) => CartaoCreditoModel.fromJson(e)).toList(),
    );
  }

  /// Cria um novo cartão de crédito
  Future<CartaoCreditoModel> criar({
    required String nome,
    required double limiteTotal,
    required int diaFechamento,
    required int diaVencimento,
    required String usuarioId,
    String? icone,
    String? categoriaId,
  }) async {
    return _apiClient.post(ApiConstants.cartoesCredito, {
      'nome': nome,
      'limiteTotal': limiteTotal,
      'diaFechamento': diaFechamento,
      'diaVencimento': diaVencimento,
      'usuarioId': usuarioId,
      if (icone != null) 'icone': icone,
      if (categoriaId != null) 'categoriaId': categoriaId,
    }, (json) => CartaoCreditoModel.fromJson(json));
  }

  /// Atualiza um cartão existente
  Future<CartaoCreditoModel> atualizar(
    String id, {
    String? nome,
    String? icone,
    double? limiteTotal,
    int? diaFechamento,
    int? diaVencimento,
    bool? ativo,
    String? categoriaId,
  }) async {
    return _apiClient.put(
      ApiConstants.cartaoCreditoPorId(id),
      {
        if (nome != null) 'nome': nome,
        if (icone != null) 'icone': icone,
        if (limiteTotal != null) 'limiteTotal': limiteTotal,
        if (diaFechamento != null) 'diaFechamento': diaFechamento,
        if (diaVencimento != null) 'diaVencimento': diaVencimento,
        if (ativo != null) 'ativo': ativo,
        if (categoriaId != null) 'categoriaId': categoriaId,
      },
      (json) => CartaoCreditoModel.fromJson(json),
    );
  }

  /// Altera o limite de um cartão
  Future<CartaoCreditoModel> alterarLimite(String id, double novoLimite) async {
    return _apiClient.patch(
      ApiConstants.alterarLimiteCartao(id),
      {'novoLimite': novoLimite},
      (json) => CartaoCreditoModel.fromJson(json),
    );
  }

  /// Desativa um cartão
  Future<CartaoCreditoModel> desativar(String id) async {
    return _apiClient.patch(
      ApiConstants.desativarCartaoCredito(id),
      {},
      (json) => CartaoCreditoModel.fromJson(json),
    );
  }

  Future<CartaoCreditoModel> ativar(String id) async {
    return _apiClient.patch(
      ApiConstants.ativarCartaoCredito(id),
      {},
      (json) => CartaoCreditoModel.fromJson(json),
    );
  }

  /// Deleta um cartão
  Future<void> deletar(String id) async {
    await _apiClient.delete(ApiConstants.cartaoCreditoPorId(id));
  }
}
