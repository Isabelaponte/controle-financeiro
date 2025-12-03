import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/core/constants/api_constants.dart';
import 'package:frontend/features/models/transacao_model.dart';

class TransacaoService {
  final ApiClient _apiClient;

  TransacaoService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  /// Busca todas as transações do usuário (receitas + despesas)
  Future<List<TransacaoModel>> listarTodasTransacoes(String usuarioId) async {
    final results = await Future.wait([
      _buscarReceitas(usuarioId),
      _buscarDespesasGerais(usuarioId),
      _buscarDespesasCartao(usuarioId),
    ]);

    final List<TransacaoModel> todasTransacoes = [];
    todasTransacoes.addAll(results[0]);
    todasTransacoes.addAll(results[1]);
    todasTransacoes.addAll(results[2]);

    // Ordena por data (mais recente primeiro)
    todasTransacoes.sort((a, b) => b.data.compareTo(a.data));

    return todasTransacoes;
  }

  /// Busca transações por período
  Future<List<TransacaoModel>> listarPorPeriodo(
    String usuarioId,
    DateTime dataInicio,
    DateTime dataFim,
  ) async {
    final todasTransacoes = await listarTodasTransacoes(usuarioId);

    return todasTransacoes.where((transacao) {
      return transacao.data.isAfter(
            dataInicio.subtract(const Duration(days: 1)),
          ) &&
          transacao.data.isBefore(dataFim.add(const Duration(days: 1)));
    }).toList();
  }

  // === RECEITAS ===

  Future<List<TransacaoModel>> _buscarReceitas(String usuarioId) async {
    try {
      return await _apiClient.get(
        ApiConstants.receitasPorUsuario(usuarioId),
        (json) =>
            (json as List).map((e) => TransacaoModel.fromReceita(e)).toList(),
      );
    } catch (e) {
      return [];
    }
  }

  Future<TransacaoModel> criarReceita({
    required String usuarioId,
    required String contaId,
    required String descricao,
    required double valor,
    required DateTime dataRecebimento,
    String? categoriaId,
    String? formaPagamento,
    bool? fixa,
    bool? repete,
    bool? recebida,
    int? periodo,
  }) async {
    return _apiClient.post(ApiConstants.receitas, {
      'usuarioId': usuarioId,
      'contaId': contaId,
      'descricao': descricao,
      'valor': valor,
      'dataRecebimento': dataRecebimento.toIso8601String().split('T')[0],
      if (categoriaId != null) 'categoriaId': categoriaId,
      if (formaPagamento != null) 'formaPagamento': formaPagamento,
      if (fixa != null) 'fixa': fixa,
      if (repete != null) 'repete': repete,
      if (periodo != null) 'periodo': periodo,
      if (recebida != null) 'recebida': recebida,
    }, (json) => TransacaoModel.fromReceita(json));
  }

  Future<TransacaoModel> atualizarReceita(
    String id, {
    String? descricao,
    double? valor,
    DateTime? dataRecebimento,
    String? formaPagamento,
    bool? fixa,
    bool? repete,
    int? periodo,
    bool? recebida,
    String? contaId,
    String? categoriaId,
  }) async {
    final dados = <String, dynamic>{};

    if (descricao != null) dados['descricao'] = descricao;
    if (valor != null) dados['valor'] = valor;
    if (dataRecebimento != null) {
      dados['dataRecebimento'] = dataRecebimento.toIso8601String().split(
        'T',
      )[0];
    }
    if (formaPagamento != null) dados['formaPagamento'] = formaPagamento;
    if (fixa != null) dados['fixa'] = fixa;
    if (repete != null) dados['repete'] = repete;
    if (periodo != null) dados['periodo'] = periodo;
    if (recebida != null) dados['recebida'] = recebida;
    if (contaId != null) dados['contaId'] = contaId;
    if (categoriaId != null) dados['categoriaId'] = categoriaId;

    return _apiClient.put(
      ApiConstants.receitaPorId(id),
      dados,
      (json) => TransacaoModel.fromReceita(json),
    );
  }
  // === DESPESAS GERAIS ===

  Future<List<TransacaoModel>> _buscarDespesasGerais(String usuarioId) async {
    try {
      return await _apiClient.get(
        ApiConstants.despesasGeraisPorUsuario(usuarioId),
        (json) => (json as List)
            .map((e) => TransacaoModel.fromDespesaGeral(e))
            .toList(),
      );
    } catch (e) {
      return [];
    }
  }

  Future<TransacaoModel> criarDespesaGeral({
    required String usuarioId,
    required String categoriaId,
    required String descricao,
    required double valor,
    required DateTime dataVencimento,
    String? contaId,
    String? formaPagamento,
    DateTime? lembrete,
    bool? pago,
    bool? repetir,
    int? periodo,
  }) async {
    return _apiClient.post(ApiConstants.despesasGerais, {
      'usuarioId': usuarioId,
      'categoriaId': categoriaId,
      'descricao': descricao,
      'valor': valor,
      'dataVencimento': dataVencimento.toIso8601String().split('T')[0],
      if (contaId != null) 'contaId': contaId,
      if (formaPagamento != null) 'formaPagamento': formaPagamento,
      if (lembrete != null)
        'lembrete': lembrete.toIso8601String().split('T')[0],
      if (pago != null) 'pago': pago,
      if (repetir != null) 'repetir': repetir,
      if (periodo != null) 'periodo': periodo,
    }, (json) => TransacaoModel.fromDespesaGeral(json));
  }

  Future<TransacaoModel> atualizarDespesaGeral(
    String id, {
    String? descricao,
    double? valor,
    DateTime? dataVencimento,
    DateTime? lembrete,
    bool? pago,
    String? categoriaId,
    String? contaId,
    String? formaPagamento,
    int? periodo,
    bool? repetir,
  }) async {
    final dados = <String, dynamic>{};
    if (descricao != null) dados['descricao'] = descricao;
    if (valor != null) dados['valor'] = valor;
    if (dataVencimento != null) {
      dados['dataVencimento'] = dataVencimento.toIso8601String().split('T')[0];
    }
    if (lembrete != null) {
      dados['lembrete'] = lembrete.toIso8601String().split('T')[0];
    }
    if (pago != null) dados['pago'] = pago;
    if (categoriaId != null) dados['categoriaId'] = categoriaId;
    if (contaId != null) dados['contaId'] = contaId;
    if (formaPagamento != null) dados['formaPagamento'] = formaPagamento;
    if (periodo != null) dados['periodo'] = periodo;
    if (repetir != null) dados['repetir'] = repetir;

    return _apiClient.put(
      ApiConstants.despesaGeralPorId(id),
      dados,
      (json) => TransacaoModel.fromDespesaGeral(json),
    );
  }

  // === DESPESAS DE CARTÃO ===

  Future<List<TransacaoModel>> _buscarDespesasCartao(String usuarioId) async {
    try {
      return await _apiClient.get(
        ApiConstants.despesasCartaoPorUsuario(usuarioId),
        (json) => (json as List)
            .map((e) => TransacaoModel.fromDespesaCartao(e))
            .toList(),
      );
    } catch (e) {
      return [];
    }
  }

  Future<TransacaoModel> criarDespesaCartao({
    required String usuarioId,
    required String cartaoId,
    required String categoriaId,
    required String descricao,
    required double valor,
    String? faturaId,
    DateTime? lembrete,
    bool? fixa,
    int? quantidadeParcelas,
    double? juros,
  }) async {
    return _apiClient.post(
      ApiConstants.despesasCartao,
      {
        'usuarioId': usuarioId,
        'cartaoId': cartaoId,
        'categoriaId': categoriaId,
        'descricao': descricao,
        'valor': valor,
        if (faturaId != null) 'faturaId': faturaId,
        if (lembrete != null)
          'lembrete': lembrete.toIso8601String().split('T')[0],
        if (fixa != null) 'fixa': fixa,
        if (quantidadeParcelas != null)
          'quantidadeParcelas': quantidadeParcelas,
        if (juros != null) 'juros': juros,
      },
      (json) => TransacaoModel.fromDespesaCartao(json),
    );
  }

  Future<TransacaoModel> atualizarDespesaCartao(
    String id, {
    String? descricao,
    double? valor,
    DateTime? dataDespesa,
    DateTime? lembrete,
    bool? pago,
    String? categoriaId,
    String? cartaoId,
    String? faturaId,
    bool? fixa,
    int? quantidadeParcelas,
    double? juros,
  }) async {
    return _apiClient.put(
      ApiConstants.despesaCartaoPorId(id),
      {
        if (descricao != null) 'descricao': descricao,
        if (valor != null) 'valor': valor,
        if (dataDespesa != null)
          'dataDespesa': dataDespesa.toIso8601String().split('T')[0],
        if (lembrete != null)
          'lembrete': lembrete.toIso8601String().split('T')[0],
        if (pago != null) 'pago': pago,
        if (categoriaId != null) 'categoriaId': categoriaId,
        if (cartaoId != null) 'cartaoId': cartaoId,
        if (faturaId != null) 'faturaId': faturaId,
        if (fixa != null) 'fixa': fixa,
        if (quantidadeParcelas != null)
          'quantidadeParcelas': quantidadeParcelas,
        if (juros != null) 'juros': juros,
      },
      (json) => TransacaoModel.fromDespesaCartao(json),
    );
  }

  /// Deleta uma transação baseada no tipo
  Future<void> deletar(String id, TipoTransacao tipo) async {
    switch (tipo) {
      case TipoTransacao.receita:
        await _apiClient.delete(ApiConstants.receitaPorId(id));
        break;
      case TipoTransacao.despesaGeral:
        await _apiClient.delete(ApiConstants.despesaGeralPorId(id));
        break;
      case TipoTransacao.despesaCartao:
        await _apiClient.delete(ApiConstants.despesaCartaoPorId(id));
        break;
    }
  }
}
