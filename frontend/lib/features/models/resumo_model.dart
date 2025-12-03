class ResumoMensal {
  final double totalGanhos;
  final double totalGastos;
  final double saldo;
  final int mes;
  final int ano;

  ResumoMensal({
    required this.totalGanhos,
    required this.totalGastos,
    required this.saldo,
    required this.mes,
    required this.ano,
  });

  factory ResumoMensal.fromJson(Map<String, dynamic> json) {
    return ResumoMensal(
      totalGanhos: (json['totalGanhos'] ?? 0.0).toDouble(),
      totalGastos: (json['totalGastos'] ?? 0.0).toDouble(),
      saldo: (json['saldo'] ?? 0.0).toDouble(),
      mes: json['mes'] ?? 0,
      ano: json['ano'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalGanhos': totalGanhos,
      'totalGastos': totalGastos,
      'saldo': saldo,
      'mes': mes,
      'ano': ano,
    };
  }

  String get totalGanhosFormatado {
    return 'R\$ ${totalGanhos.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  String get totalGastosFormatado {
    return 'R\$ ${totalGastos.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  String get saldoFormatado {
    return 'R\$ ${saldo.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  bool get temSaldoPositivo => saldo >= 0;
}