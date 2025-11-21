class MetaFinanceiraModel {
  final String id;
  final String nome;
  final double valorDesejado;
  final double valorAtual;
  final double valorRestante;
  final double percentualConcluido;
  final DateTime dataInicio;
  final DateTime? dataAlvo;
  final int? diasRestantes;
  final bool ativa;
  final bool concluida;
  final String? categoriaId;
  final String? categoriaNome;
  final String usuarioId;
  final String? usuarioNome;

  MetaFinanceiraModel({
    required this.id,
    required this.nome,
    required this.valorDesejado,
    required this.valorAtual,
    required this.valorRestante,
    required this.percentualConcluido,
    required this.dataInicio,
    this.dataAlvo,
    this.diasRestantes,
    required this.ativa,
    required this.concluida,
    this.categoriaId,
    this.categoriaNome,
    required this.usuarioId,
    this.usuarioNome,
  });

  factory MetaFinanceiraModel.fromJson(Map<String, dynamic> json) {
    return MetaFinanceiraModel(
      id: json['id'] as String,
      nome: json['nome'] as String,
      valorDesejado: (json['valorDesejado'] as num).toDouble(),
      valorAtual: (json['valorAtual'] as num?)?.toDouble() ?? 0.0,
      valorRestante: (json['valorRestante'] as num?)?.toDouble() ?? 0.0,
      percentualConcluido:
          (json['percentualConcluido'] as num?)?.toDouble() ?? 0.0,
      dataInicio: DateTime.parse(json['dataInicio'] as String),
      dataAlvo: json['dataAlvo'] != null
          ? DateTime.parse(json['dataAlvo'] as String)
          : null,
      diasRestantes: json['diasRestantes'] as int?,
      ativa: json['ativa'] as bool? ?? true,
      concluida: json['concluida'] as bool? ?? false,
      categoriaId: json['categoriaId'] as String?,
      categoriaNome: json['categoriaNome'] as String?,
      usuarioId: json['usuarioId'] as String,
      usuarioNome: json['usuarioNome'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'valorDesejado': valorDesejado,
      'valorAtual': valorAtual,
      'valorRestante': valorRestante,
      'percentualConcluido': percentualConcluido,
      'dataInicio': dataInicio.toIso8601String(),
      'dataAlvo': dataAlvo?.toIso8601String(),
      'diasRestantes': diasRestantes,
      'ativa': ativa,
      'concluida': concluida,
      'categoriaId': categoriaId,
      'categoriaNome': categoriaNome,
      'usuarioId': usuarioId,
      'usuarioNome': usuarioNome,
    };
  }

  // Helpers de formatação
  String get valorDesejadoFormatado {
    return 'R\$ ${valorDesejado.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  String get valorAtualFormatado {
    return 'R\$ ${valorAtual.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  String get valorRestanteFormatado {
    return 'R\$ ${valorRestante.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  // Progresso de 0.0 a 1.0 para LinearProgressIndicator
  double get progresso {
    if (valorDesejado == 0) return 0.0;
    return (valorAtual / valorDesejado).clamp(0.0, 1.0);
  }

  String get percentualFormatado {
    return '${percentualConcluido.toStringAsFixed(1)}%';
  }

  String get statusDias {
    if (concluida) return 'Concluída!';
    if (diasRestantes == null) return 'Sem prazo definido';
    if (diasRestantes! < 0) return 'Prazo expirado';
    if (diasRestantes == 0) return 'Último dia!';
    if (diasRestantes == 1) return '1 dia restante';
    return '$diasRestantes dias restantes';
  }

  bool get prazoExpirado => diasRestantes != null && diasRestantes! < 0;
  bool get prazoProximo =>
      diasRestantes != null && diasRestantes! <= 7 && diasRestantes! >= 0;
}

// Model para o resumo de metas
class ResumoMetasModel {
  final double totalDesejado;
  final double totalAcumulado;
  final double totalRestante;
  final double percentualGeral;

  ResumoMetasModel({
    required this.totalDesejado,
    required this.totalAcumulado,
    required this.totalRestante,
    required this.percentualGeral,
  });

  factory ResumoMetasModel.fromJson(Map<String, dynamic> json) {
    return ResumoMetasModel(
      totalDesejado: (json['totalDesejado'] as num?)?.toDouble() ?? 0.0,
      totalAcumulado: (json['totalAcumulado'] as num?)?.toDouble() ?? 0.0,
      totalRestante: (json['totalRestante'] as num?)?.toDouble() ?? 0.0,
      percentualGeral: (json['percentualGeral'] as num?)?.toDouble() ?? 0.0,
    );
  }

  String get totalDesejadoFormatado {
    return 'R\$ ${totalDesejado.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  String get totalAcumuladoFormatado {
    return 'R\$ ${totalAcumulado.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  String get totalRestanteFormatado {
    return 'R\$ ${totalRestante.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  String get percentualFormatado {
    return '${percentualGeral.toStringAsFixed(1)}%';
  }
}
