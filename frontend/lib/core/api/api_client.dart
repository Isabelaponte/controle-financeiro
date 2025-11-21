import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:frontend/core/constants/api_constants.dart';
import 'package:frontend/features/services/auth_service.dart';

class ApiClient {
  final http.Client _client;
  final AuthService _authService;

  ApiClient({http.Client? client, AuthService? authService})
    : _client = client ?? http.Client(),
      _authService = authService ?? AuthService();

  Future<Map<String, String>> get _headers async {
    final token = await _authService.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Uri _buildUri(String endpoint) =>
      Uri.parse('${ApiConstants.baseUrl}$endpoint');

  Future<T> get<T>(String endpoint, T Function(dynamic) fromJson) async {
    try {
      final headers = await _headers;
      final response = await _client.get(_buildUri(endpoint), headers: headers);
      return _handleResponse(response, fromJson);
    } on SocketException {
      throw ApiException('Sem conexão com a internet');
    }
  }

  Future<T> post<T>(
    String endpoint,
    Map<String, dynamic> body,
    T Function(dynamic) fromJson,
  ) async {
    try {
      final headers = await _headers;
      final response = await _client.post(
        _buildUri(endpoint),
        headers: headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response, fromJson);
    } on SocketException {
      throw ApiException('Sem conexão com a internet');
    }
  }

  Future<T> put<T>(
    String endpoint,
    Map<String, dynamic> body,
    T Function(dynamic) fromJson,
  ) async {
    try {
      final headers = await _headers;
      final response = await _client.put(
        _buildUri(endpoint),
        headers: headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response, fromJson);
    } on SocketException {
      throw ApiException('Sem conexão com a internet');
    }
  }

  Future<T> patch<T>(
    String endpoint,
    Map<String, dynamic> body,
    T Function(dynamic) fromJson,
  ) async {
    try {
      final headers = await _headers;
      final response = await _client.patch(
        _buildUri(endpoint),
        headers: headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response, fromJson);
    } on SocketException {
      throw ApiException('Sem conexão com a internet');
    }
  }

  Future<void> delete(String endpoint) async {
    try {
      final headers = await _headers;
      final response = await _client.delete(
        _buildUri(endpoint),
        headers: headers,
      );
      if (response.statusCode != 204 && response.statusCode != 200) {
        throw ApiException('Erro ao deletar: ${response.statusCode}');
      }
    } on SocketException {
      throw ApiException('Sem conexão com a internet');
    }
  }

  T _handleResponse<T>(http.Response response, T Function(dynamic) fromJson) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return fromJson(null);
      }
      final decoded = jsonDecode(response.body);
      return fromJson(decoded);
    } else if (response.statusCode == 401) {
      throw ApiException(
        'Sessão expirada. Faça login novamente.',
        isAuthError: true,
      );
    } else if (response.statusCode == 403) {
      throw ApiException('Acesso negado');
    } else if (response.statusCode == 404) {
      throw ApiException('Recurso não encontrado');
    } else if (response.statusCode == 400) {
      final decoded = jsonDecode(response.body);
      throw ApiException(decoded['message'] ?? 'Requisição inválida');
    } else if (response.statusCode == 500) {
      throw ApiException('Erro interno do servidor');
    } else {
      throw ApiException('Erro: ${response.statusCode}');
    }
  }
}

class ApiException implements Exception {
  final String message;
  final bool isAuthError;

  ApiException(this.message, {this.isAuthError = false});

  @override
  String toString() => message;
}
