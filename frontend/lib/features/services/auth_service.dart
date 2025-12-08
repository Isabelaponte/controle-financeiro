import 'dart:convert';
import 'package:frontend/features/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/api_constants.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  String? _token;

  String? get token => _token;

  Future<void> _saveToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ApiConstants.tokenKey, token);
  }

  Future<void> _saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ApiConstants.userKey, jsonEncode(user.toJson()));
  }

  Future<String?> getToken() async {
    if (_token != null) return _token;
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(ApiConstants.tokenKey);
    return _token;
  }

  Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(ApiConstants.userKey);
    if (userJson == null) return null;
    return UserModel.fromJson(jsonDecode(userJson));
  }

  Future<void> clearAuth() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(ApiConstants.tokenKey);
    await prefs.remove(ApiConstants.userKey);
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.loginEndpoint}'),
        headers: ApiConstants.headers,
        body: jsonEncode({'email': email, 'senha': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = data['token'] ?? data['access_token'] ?? '';
        final userData = data['user'] ?? data['data'] ?? data;

        final user = UserModel.fromJson(userData);

        await _saveToken(token);
        await _saveUser(user);

        return {'success': true, 'user': user, 'token': token};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Erro ao fazer login',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Erro de conexão: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.registerEndpoint}'),
        headers: ApiConstants.headers,
        body: jsonEncode({
          'nomeUsuario': name,
          'email': email,
          'senha': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = data['token'] ?? data['access_token'] ?? '';
        final userData = data['user'] ?? data['data'] ?? data;

        final user = UserModel.fromJson(userData);

        await _saveToken(token);
        await _saveUser(user);

        return {'success': true, 'user': user, 'token': token};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Erro ao fazer cadastro',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Erro de conexão: ${e.toString()}'};
    }
  }

  /// Busca usuário por ID
  Future<Map<String, dynamic>> buscarUsuarioPorId(String id) async {
    try {
      final token = await getToken();
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/usuarios/$id'),
        headers: {...ApiConstants.headers, 'Authorization': 'Bearer $token'},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final user = UserModel.fromJson(data);
        return {'success': true, 'user': user};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Erro ao buscar usuário',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Erro de conexão: ${e.toString()}'};
    }
  }

  /// Atualiza dados do usuário
  Future<Map<String, dynamic>> atualizarUsuario({
    required String id,
    String? nomeUsuario,
    String? email,
  }) async {
    try {
      final token = await getToken();

      final body = <String, dynamic>{};
      if (nomeUsuario != null) body['nomeUsuario'] = nomeUsuario;
      if (email != null) body['email'] = email;

      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}/usuarios/$id'),
        headers: {...ApiConstants.headers, 'Authorization': 'Bearer $token'},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final user = UserModel.fromJson(data);
        await _saveUser(user);
        return {'success': true, 'user': user};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Erro ao atualizar usuário',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Erro de conexão: ${e.toString()}'};
    }
  }

  /// Altera senha do usuário
  Future<Map<String, dynamic>> alterarSenha({
    required String id,
    required String senhaAtual,
    required String novaSenha,
    required String confirmarNovaSenha,
  }) async {
    try {
      final token = await getToken();

      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}/usuarios/$id/senha'),
        headers: {...ApiConstants.headers, 'Authorization': 'Bearer $token'},
        body: jsonEncode({
          'senhaAtual': senhaAtual,
          'novaSenha': novaSenha,
          'confirmarNovaSenha': confirmarNovaSenha,
        }),
      );

      if (response.statusCode == 204) {
        return {'success': true};
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Erro ao alterar senha',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Erro de conexão: ${e.toString()}'};
    }
  }

  /// Deleta usuário
  Future<Map<String, dynamic>> deletarUsuario(String id) async {
    try {
      final token = await getToken();

      final response = await http.delete(
        Uri.parse('${ApiConstants.baseUrl}/usuarios/$id'),
        headers: {...ApiConstants.headers, 'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 204) {
        await clearAuth();
        return {'success': true};
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Erro ao deletar usuário',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Erro de conexão: ${e.toString()}'};
    }
  }

  Future<void> logout() async {
    try {
      final token = await getToken();
      if (token != null) {
        await http.post(
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.logoutEndpoint}'),
          headers: {...ApiConstants.headers, 'Authorization': 'Bearer $token'},
        );
      }
    } catch (e) {
      // Ignora erros
    } finally {
      await clearAuth();
    }
  }

  Future<http.Response> authenticatedRequest(
    String endpoint, {
    String method = 'GET',
    Map<String, dynamic>? body,
  }) async {
    final token = await getToken();

    final headers = {...ApiConstants.headers, 'Authorization': 'Bearer $token'};

    final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');

    switch (method.toUpperCase()) {
      case 'POST':
        return await http.post(uri, headers: headers, body: jsonEncode(body));
      case 'PUT':
        return await http.put(uri, headers: headers, body: jsonEncode(body));
      case 'DELETE':
        return await http.delete(uri, headers: headers);
      default:
        return await http.get(uri, headers: headers);
    }
  }
}
