class ContaModel {
  final String id;
  final String nome;
  final String? icone;
  final String tipo;
  final double saldo;
  final bool ativa;
  final String usuarioId;
  final String? usuarioNome;
  final String? categoriaId;
  final String? categoriaNome;

  ContaModel({
    required this.id,
    required this.nome,
    this.icone,
    required this.tipo,
    required this.saldo,
    required this.ativa,
    required this.usuarioId,
    this.usuarioNome,
    this.categoriaId,
    this.categoriaNome,
  });

  factory ContaModel.fromJson(Map<String, dynamic> json) {
    return ContaModel(
      id: json['id'] as String,
      nome: json['nome'] as String,
      icone: json['icone'] as String?,
      tipo: json['tipo'] as String,
      saldo: (json['saldo'] as num).toDouble(),
      ativa: json['ativa'] as bool,
      usuarioId: json['usuarioId'] as String,
      usuarioNome: json['usuarioNome'] as String?,
      categoriaId: json['categoriaId'] as String?,
      categoriaNome: json['categoriaNome'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'icone': icone,
      'tipo': tipo,
      'saldo': saldo,
      'ativa': ativa,
      'usuarioId': usuarioId,
      'usuarioNome': usuarioNome,
      'categoriaId': categoriaId,
      'categoriaNome': categoriaNome,
    };
  }

  String get saldoFormatado {
    return 'R\$ ${saldo.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  String get tipoFormatado {
    switch (tipo.toUpperCase()) {
      case 'CORRENTE':
        return 'Conta Corrente';
      case 'POUPANCA':
        return 'Conta Poupança';
      case 'INVESTIMENTO':
        return 'Investimento';
      case 'CARTEIRA':
        return 'Carteira';
      default:
        return tipo;
    }
  }
}
