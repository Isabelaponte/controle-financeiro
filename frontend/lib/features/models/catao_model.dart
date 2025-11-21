class CartaoCreditoModel {
  final String id;
  final String nome;
  final String? icone;
  final double limiteTotal;
  final int diaFechamento;
  final int diaVencimento;
  final bool ativo;
  final String usuarioId;
  final String? usuarioNome;
  final String? categoriaId;
  final String? categoriaNome;

  CartaoCreditoModel({
    required this.id,
    required this.nome,
    this.icone,
    required this.limiteTotal,
    required this.diaFechamento,
    required this.diaVencimento,
    required this.ativo,
    required this.usuarioId,
    this.usuarioNome,
    this.categoriaId,
    this.categoriaNome,
  });

  factory CartaoCreditoModel.fromJson(Map<String, dynamic> json) {
    return CartaoCreditoModel(
      id: json['id'] as String,
      nome: json['nome'] as String,
      icone: json['icone'] as String?,
      limiteTotal: (json['limiteTotal'] as num).toDouble(),
      diaFechamento: json['diaFechamento'] as int,
      diaVencimento: json['diaVencimento'] as int,
      ativo: json['ativo'] as bool,
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
      'limiteTotal': limiteTotal,
      'diaFechamento': diaFechamento,
      'diaVencimento': diaVencimento,
      'ativo': ativo,
      'usuarioId': usuarioId,
      'usuarioNome': usuarioNome,
      'categoriaId': categoriaId,
      'categoriaNome': categoriaNome,
    };
  }

  // Helpers de formatação
  String get limiteTotalFormatado {
    return 'R\$ ${limiteTotal.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  double calcularLimiteDisponivel(double faturaAtual) {
    return limiteTotal - faturaAtual;
  }

  String formatarLimiteDisponivel(double faturaAtual) {
    final disponivel = calcularLimiteDisponivel(faturaAtual);
    return 'R\$ ${disponivel.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  String formatarFatura(double valor) {
    return 'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  int get diasParaVencimento {
    final hoje = DateTime.now();
    final diaAtual = hoje.day;

    if (diaVencimento >= diaAtual) {
      return diaVencimento - diaAtual;
    } else {
      final ultimoDiaMes = DateTime(hoje.year, hoje.month + 1, 0).day;
      return (ultimoDiaMes - diaAtual) + diaVencimento;
    }
  }

  String get statusVencimento {
    final dias = diasParaVencimento;
    if (dias == 0) return 'Vence hoje';
    if (dias == 1) return 'Vence amanhã';
    if (dias <= 7) return 'Vence em $dias dias';
    return 'Vence dia $diaVencimento';
  }

  bool get proximoVencimento => diasParaVencimento <= 7;
}
