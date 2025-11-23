enum StatusPagamento {
  pendente,
  pago,
  atrasado;

  factory StatusPagamento.fromString(String value) {
    switch (value.toUpperCase()) {
      case 'PENDENTE':
        return StatusPagamento.pendente;
      case 'PAGO':
        return StatusPagamento.pago;
      case 'ATRASADO':
        return StatusPagamento.atrasado;
      default:
        return StatusPagamento.pendente;
    }
  }

  String get displayName {
    switch (this) {
      case StatusPagamento.pendente:
        return 'Pendente';
      case StatusPagamento.pago:
        return 'Pago';
      case StatusPagamento.atrasado:
        return 'Atrasado';
    }
  }
}

class FaturaModel {
  final String id;
  final double valorTotal;
  final DateTime dataVencimento;
  final DateTime? dataPagamento;
  final StatusPagamento statusPagamento;
  final bool vencida;
  final int diasParaVencimento;
  final String cartaoId;
  final String cartaoNome;
  final DateTime dataCriacao;
  final DateTime dataAtualizacao;

  FaturaModel({
    required this.id,
    required this.valorTotal,
    required this.dataVencimento,
    this.dataPagamento,
    required this.statusPagamento,
    required this.vencida,
    required this.diasParaVencimento,
    required this.cartaoId,
    required this.cartaoNome,
    required this.dataCriacao,
    required this.dataAtualizacao,
  });

  factory FaturaModel.fromJson(Map<String, dynamic> json) {
    return FaturaModel(
      id: json['id'] as String,
      valorTotal: (json['valorTotal'] as num).toDouble(),
      dataVencimento: DateTime.parse(json['dataVencimento'] as String),
      dataPagamento: json['dataPagamento'] != null
          ? DateTime.parse(json['dataPagamento'] as String)
          : null,
      statusPagamento: StatusPagamento.fromString(
        json['statusPagamento'] as String,
      ),
      vencida: json['vencida'] as bool? ?? false,
      diasParaVencimento: json['diasParaVencimento'] as int? ?? 0,
      cartaoId: json['cartaoId'] as String,
      cartaoNome: json['cartaoNome'] as String,
      dataCriacao: DateTime.parse(json['dataCriacao'] as String),
      dataAtualizacao: DateTime.parse(json['dataAtualizacao'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'valorTotal': valorTotal,
      'dataVencimento': dataVencimento.toIso8601String(),
      'dataPagamento': dataPagamento?.toIso8601String(),
      'statusPagamento': statusPagamento.name.toUpperCase(),
      'vencida': vencida,
      'diasParaVencimento': diasParaVencimento,
      'cartaoId': cartaoId,
      'cartaoNome': cartaoNome,
      'dataCriacao': dataCriacao.toIso8601String(),
      'dataAtualizacao': dataAtualizacao.toIso8601String(),
    };
  }

  // Helpers de formatação
  String get valorTotalFormatado {
    return 'R\$ ${valorTotal.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  String get statusVencimento {
    if (statusPagamento == StatusPagamento.pago) {
      return 'Paga';
    }
    if (vencida) {
      return 'Vencida';
    }
    if (diasParaVencimento == 0) {
      return 'Vence hoje';
    }
    if (diasParaVencimento == 1) {
      return 'Vence amanhã';
    }
    if (diasParaVencimento <= 7) {
      return 'Vence em $diasParaVencimento dias';
    }
    return 'Vence em ${dataVencimento.day}/${dataVencimento.month}';
  }

  bool get proximoVencimento =>
      diasParaVencimento <= 7 &&
      diasParaVencimento >= 0 &&
      statusPagamento != StatusPagamento.pago;

  bool get isPaga => statusPagamento == StatusPagamento.pago;
  bool get isPendente => statusPagamento == StatusPagamento.pendente;
}
