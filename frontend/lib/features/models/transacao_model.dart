import 'package:frontend/features/models/fatura_model.dart';

enum TipoTransacao {
  receita,
  despesaGeral,
  despesaCartao;

  String get displayName {
    switch (this) {
      case TipoTransacao.receita:
        return 'Receita';
      case TipoTransacao.despesaGeral:
        return 'Despesa';
      case TipoTransacao.despesaCartao:
        return 'Despesa Cartão';
    }
  }
}

enum FormaPagamento {
  dinheiro,
  pix,
  transferencia,
  debito,
  credito;

  factory FormaPagamento.fromString(String value) {
    switch (value.toUpperCase()) {
      case 'DINHEIRO':
        return FormaPagamento.dinheiro;
      case 'PIX':
        return FormaPagamento.pix;
      case 'TRANSFERENCIA':
        return FormaPagamento.transferencia;
      case 'DEBITO':
        return FormaPagamento.debito;
      case 'CREDITO':
        return FormaPagamento.credito;
      default:
        return FormaPagamento.pix;
    }
  }
}

// Classe base unificada
class TransacaoModel {
  final String id;
  final String descricao;
  final double valor;
  final DateTime data;
  final TipoTransacao tipo;
  final bool pago;

  // Campos comuns
  final String? categoriaId;
  final String? categoriaNome;
  final String usuarioId;
  final String? usuarioNome;

  // Campos específicos de receita
  final FormaPagamento? formaPagamento;
  final bool? recebida;
  final bool? fixa;
  final bool? repete;
  final int? periodo;

  // Campos específicos de despesa geral
  final StatusPagamento? statusPagamento;
  final DateTime? lembrete;

  // Campos específicos de despesa cartão
  final int? quantidadeParcelas;
  final double? juros;
  final double? valorTotal;
  final double? valorParcela;

  // Relacionamentos
  final String? contaId;
  final String? contaNome;
  final String? cartaoId;
  final String? cartaoNome;
  final String? faturaId;

  TransacaoModel({
    required this.id,
    required this.descricao,
    required this.valor,
    required this.data,
    required this.tipo,
    required this.pago,
    this.categoriaId,
    this.categoriaNome,
    required this.usuarioId,
    this.usuarioNome,
    this.formaPagamento,
    this.recebida,
    this.fixa,
    this.repete,
    this.periodo,
    this.statusPagamento,
    this.lembrete,
    this.quantidadeParcelas,
    this.juros,
    this.valorTotal,
    this.valorParcela,
    this.contaId,
    this.contaNome,
    this.cartaoId,
    this.cartaoNome,
    this.faturaId,
  });

  // Factory para Receita
  factory TransacaoModel.fromReceita(Map<String, dynamic> json) {
    return TransacaoModel(
      id: json['id'] as String,
      descricao: json['descricao'] as String,
      valor: (json['valor'] as num).toDouble(),
      data: DateTime.parse(json['dataRecebimento'] as String),
      tipo: TipoTransacao.receita,
      pago: json['recebida'] as bool? ?? false,
      categoriaId: json['categoriaId'] as String?,
      categoriaNome: json['categoriaNome'] as String?,
      usuarioId: json['usuarioId'] as String,
      usuarioNome: json['usuarioNome'] as String?,
      formaPagamento: json['formaPagamento'] != null
          ? FormaPagamento.fromString(json['formaPagamento'] as String)
          : null,
      recebida: json['recebida'] as bool?,
      fixa: json['fixa'] as bool?,
      repete: json['repete'] as bool?,
      periodo: json['periodo'] as int?,
      contaId: json['contaId'] as String?,
      contaNome: json['contaNome'] as String?,
    );
  }

  // Factory para Despesa Geral
  factory TransacaoModel.fromDespesaGeral(Map<String, dynamic> json) {
    return TransacaoModel(
      id: json['id'] as String,
      descricao: json['descricao'] as String,
      valor: (json['valor'] as num).toDouble(),
      data: DateTime.parse(json['dataDespesa'] as String),
      tipo: TipoTransacao.despesaGeral,
      pago: json['pago'] as bool? ?? false,
      categoriaId: json['categoriaId'] as String?,
      categoriaNome: json['categoriaNome'] as String?,
      usuarioId: json['usuarioId'] as String,
      usuarioNome: json['usuarioNome'] as String?,
      statusPagamento: json['statusPagamento'] != null
          ? StatusPagamento.fromString(json['statusPagamento'] as String)
          : null,
      lembrete: json['lembrete'] != null
          ? DateTime.parse(json['lembrete'] as String)
          : null,
      repete: json['repetir'] as bool?,
      periodo: json['periodo'] as int?,
      contaId: json['contaId'] as String?,
      contaNome: json['contaNome'] as String?,
    );
  }

  // Factory para Despesa Cartão
  factory TransacaoModel.fromDespesaCartao(Map<String, dynamic> json) {
    return TransacaoModel(
      id: json['id'] as String,
      descricao: json['descricao'] as String,
      valor: (json['valor'] as num).toDouble(),
      data: DateTime.parse(json['dataDespesa'] as String),
      tipo: TipoTransacao.despesaCartao,
      pago: json['pago'] as bool? ?? false,
      categoriaId: json['categoriaId'] as String?,
      categoriaNome: json['categoriaNome'] as String?,
      usuarioId: json['usuarioId'] as String,
      usuarioNome: json['usuarioNome'] as String?,
      fixa: json['fixa'] as bool?,
      quantidadeParcelas: json['quantidadeParcelas'] as int?,
      juros: json['juros'] != null ? (json['juros'] as num).toDouble() : null,
      valorTotal: json['valorTotal'] != null
          ? (json['valorTotal'] as num).toDouble()
          : null,
      valorParcela: json['valorParcela'] != null
          ? (json['valorParcela'] as num).toDouble()
          : null,
      lembrete: json['lembrete'] != null
          ? DateTime.parse(json['lembrete'] as String)
          : null,
      cartaoId: json['cartaoId'] as String?,
      cartaoNome: json['cartaoNome'] as String?,
      faturaId: json['faturaId'] as String?,
    );
  }

  // Helpers de formatação
  String get valorFormatado {
    final sinal = tipo == TipoTransacao.receita ? '+' : '-';
    return '$sinal R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  String get origemFormatado {
    if (cartaoNome != null) return cartaoNome!;
    if (contaNome != null) return contaNome!;
    return 'Sem origem';
  }

  String get statusFormatado {
    if (tipo == TipoTransacao.receita) {
      return recebida == true ? 'Recebida' : 'A receber';
    } else {
      return pago ? 'Paga' : 'Pendente';
    }
  }

  bool get isReceita => tipo == TipoTransacao.receita;
  bool get isDespesa => tipo != TipoTransacao.receita;
}
