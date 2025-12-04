import 'package:flutter/material.dart';
import 'package:frontend/features/models/user_model.dart';
import 'package:frontend/features/services/auth_service.dart';

enum AuthStatus { uninitialized, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  AuthStatus _status = AuthStatus.uninitialized;
  UserModel? _user;
  String? _errorMessage;
  List<String>? _errorList;

  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  List<String>? get errorList => _errorList;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  Future<void> initialize() async {
    try {
      final token = await _authService.getToken();

      if (token != null && token.isNotEmpty) {
        _user = await _authService.getUser();
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    try {
      _errorMessage = null;
      _errorList = null;
      notifyListeners();

      final result = await _authService.login(email: email, password: password);

      if (result['success']) {
        _user = result['user'];
        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'];
        _errorList = result['errors'] != null
            ? List<String>.from(result['errors'])
            : null;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erro ao fazer login: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      _errorMessage = null;
      notifyListeners();

      final result = await _authService.register(
        name: name,
        email: email,
        password: password,
      );

      if (result['success']) {
        _user = result['user'];
        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'];
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erro ao fazer cadastro: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// Busca dados atualizados do usuário
  Future<bool> buscarUsuario() async {
    if (_user == null) return false;

    try {
      _errorMessage = null;
      notifyListeners();

      final result = await _authService.buscarUsuarioPorId(_user!.id);

      if (result['success']) {
        _user = result['user'];
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'];
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erro ao buscar usuário: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// Atualiza dados do usuário
  Future<bool> atualizarUsuario({String? nomeUsuario, String? email}) async {
    if (_user == null) return false;

    try {
      _errorMessage = null;
      notifyListeners();

      final result = await _authService.atualizarUsuario(
        id: _user!.id,
        nomeUsuario: nomeUsuario,
        email: email,
      );

      if (result['success']) {
        _user = result['user'];
        notifyListeners();

        return true;
      } else {
        _errorMessage = result['message'];
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erro ao atualizar usuário: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<bool> alterarSenha({
    required String senhaAtual,
    required String novaSenha,
    required String confirmarNovaSenha,
  }) async {
    if (_user == null) return false;

    try {
      _errorMessage = null;
      notifyListeners();

      final result = await _authService.alterarSenha(
        id: _user!.id,
        senhaAtual: senhaAtual,
        novaSenha: novaSenha,
        confirmarNovaSenha: confirmarNovaSenha,
      );

      if (result['success']) {
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'];
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erro ao alterar senha: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// Deleta conta do usuário
  Future<bool> deletarConta() async {
    if (_user == null) return false;

    try {
      _errorMessage = null;
      notifyListeners();

      final result = await _authService.deletarUsuario(_user!.id);

      if (result['success']) {
        _user = null;
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'];
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erro ao deletar conta: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    _status = AuthStatus.unauthenticated;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
