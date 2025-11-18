class ApiConstants {
  static const String baseUrl = 'http://localhost:8080';

  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String logoutEndpoint = '/auth/logout';

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
}
