import 'package:flutter/material.dart';

class CategoriaModel {
  final String id;
  final String nome;
  final String? cor;
  final String? icone;
  final String? descricao;
  final bool ativo;
  final String usuarioId;
  final String? usuarioNome;

  CategoriaModel({
    required this.id,
    required this.nome,
    this.cor,
    this.icone,
    this.descricao,
    required this.ativo,
    required this.usuarioId,
    this.usuarioNome,
  });

  factory CategoriaModel.fromJson(Map<String, dynamic> json) {
    return CategoriaModel(
      id: json['id'] as String,
      nome: json['nome'] as String,
      cor: json['cor'] as String?,
      icone: json['icone'] as String?,
      descricao: json['descricao'] as String?,
      ativo: json['ativo'] as bool? ?? true,
      usuarioId: json['usuarioId'] as String,
      usuarioNome: json['usuarioNome'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'cor': cor,
      'icone': icone,
      'descricao': descricao,
      'ativo': ativo,
      'usuarioId': usuarioId,
      'usuarioNome': usuarioNome,
    };
  }

  Color get colorValue {
    if (cor == null || cor!.isEmpty) {
      return Colors.grey;
    }
    try {
      return Color(int.parse(cor!.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.grey;
    }
  }

  String get corHex {
    if (cor == null) return '#757575';
    return cor!;
  }
}
