class ApiConstants {
  static const String baseUrl = 'http://localhost:8080/api';

  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String logoutEndpoint = '/auth/logout';

  static const String contas = '/contas';
  static String contaPorId(String id) => '/contas/$id';
  static String contasPorUsuario(String usuarioId) =>
      '/contas/usuario/$usuarioId';
  static String contasAtivasPorUsuario(String usuarioId) =>
      '/contas/usuario/$usuarioId/ativas';
  static String saldoTotalPorUsuario(String usuarioId) =>
      '/contas/usuario/$usuarioId/saldo-total';
  static String adicionarSaldo(String id) => '/contas/$id/adicionar-saldo';
  static String subtrairSaldo(String id) => '/contas/$id/subtrair-saldo';
  static String desativarConta(String id) => '/contas/$id/desativar';

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
}
