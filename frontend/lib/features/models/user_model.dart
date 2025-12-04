class UserModel {
  final String id;
  final String nomeUsuario;
  final String email;

  UserModel({required this.id, required this.nomeUsuario, required this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      nomeUsuario: json['nomeUsuario'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nomeUsuario': nomeUsuario, 'email': email};
  }

  UserModel copyWith({String? id, String? nomeUsuario, String? email}) {
    return UserModel(
      id: id ?? this.id,
      nomeUsuario: nomeUsuario ?? this.nomeUsuario,
      email: email ?? this.email,
    );
  }
}
