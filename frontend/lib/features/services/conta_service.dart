import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/core/constants/api_constants.dart';
import 'package:frontend/features/models/conta_model.dart';

class ContaService {
  final ApiClient _apiClient;

  ContaService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Busca uma conta por ID
  Future<ContaModel> buscarPorId(String id) async {
    return _apiClient.get(
      ApiConstants.contaPorId(id),
      (json) => ContaModel.fromJson(json),
    );
  }

  /// Lista todas as contas de um usuário
  Future<List<ContaModel>> listarPorUsuario(String usuarioId) async {
    return _apiClient.get(
      ApiConstants.contasPorUsuario(usuarioId),
      (json) => (json as List).map((e) => ContaModel.fromJson(e)).toList(),
    );
  }

  /// Lista apenas contas ativas de um usuário
  Future<List<ContaModel>> listarAtivasPorUsuario(String usuarioId) async {
    return _apiClient.get(
      ApiConstants.contasAtivasPorUsuario(usuarioId),
      (json) => (json as List).map((e) => ContaModel.fromJson(e)).toList(),
    );
  }

  /// Calcula o saldo total de todas as contas do usuário
  Future<double> calcularSaldoTotal(String usuarioId) async {
    return _apiClient.get(
      ApiConstants.saldoTotalPorUsuario(usuarioId),
      (json) => (json['saldoTotal'] as num).toDouble(),
    );
  }

  /// Cria uma nova conta
  Future<ContaModel> criar({
    required String nome,
    required String tipo,
    required double saldo,
    required String usuarioId,
    String? icone,
    String? categoriaId,
  }) async {
    return _apiClient.post(ApiConstants.contas, {
      'nome': nome,
      'tipo': tipo,
      'saldo': saldo,
      'usuarioId': usuarioId,
      if (icone != null) 'icone': icone,
      if (categoriaId != null) 'categoriaId': categoriaId,
    }, (json) => ContaModel.fromJson(json));
  }

  /// Atualiza uma conta existente
  Future<ContaModel> atualizar(
    String id, {
    String? nome,
    String? tipo,
    String? icone,
    String? categoriaId,
  }) async {
    return _apiClient.put(ApiConstants.contaPorId(id), {
      if (nome != null) 'nome': nome,
      if (tipo != null) 'tipo': tipo,
      if (icone != null) 'icone': icone,
      if (categoriaId != null) 'categoriaId': categoriaId,
    }, (json) => ContaModel.fromJson(json));
  }

  /// Adiciona saldo a uma conta
  Future<ContaModel> adicionarSaldo(String id, double valor) async {
    return _apiClient.patch(ApiConstants.adicionarSaldo(id), {
      'valor': valor,
    }, (json) => ContaModel.fromJson(json));
  }

  /// Subtrai saldo de uma conta
  Future<ContaModel> subtrairSaldo(String id, double valor) async {
    return _apiClient.patch(ApiConstants.subtrairSaldo(id), {
      'valor': valor,
    }, (json) => ContaModel.fromJson(json));
  }

  /// Desativa uma conta
  Future<ContaModel> desativar(String id) async {
    return _apiClient.patch(
      ApiConstants.desativarConta(id),
      {},
      (json) => ContaModel.fromJson(json),
    );
  }

  Future<ContaModel> reativar(String id) async {
    return _apiClient.patch(
      '/contas/$id/ativar',
      {},
      (json) => ContaModel.fromJson(json),
    );
  }

  /// Deleta uma conta
  Future<void> deletar(String id) async {
    await _apiClient.delete(ApiConstants.contaPorId(id));
  }
}
