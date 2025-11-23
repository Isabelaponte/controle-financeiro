class ApiConstants {
  static const String baseUrl = 'http://localhost:8080/api';

  //Endpoints de autenticação
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String logoutEndpoint = '/auth/logout';

  //Endpoints de contas
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

  // Endpoints de Cartões de Crédito
  static const String cartoesCredito = '/cartoes-credito';
  static String cartaoCreditoPorId(String id) => '/cartoes-credito/$id';
  static String cartoesCreditoPorUsuario(String usuarioId) =>
      '/cartoes-credito/usuario/$usuarioId';
  static String cartoesCreditoAtivosPorUsuario(String usuarioId) =>
      '/cartoes-credito/usuario/$usuarioId/ativos';
  static String alterarLimiteCartao(String id) =>
      '/cartoes-credito/$id/alterar-limite';
  static String desativarCartaoCredito(String id) =>
      '/cartoes-credito/$id/desativar';

  // Endpoints de Metas Financeiras
  static const String metasFinanceiras = '/metas-financeiras';
  static String metaFinanceiraPorId(String id) => '/metas-financeiras/$id';
  static String metasPorUsuario(String usuarioId) =>
      '/metas-financeiras/usuario/$usuarioId';
  static String metasEmAndamento(String usuarioId) =>
      '/metas-financeiras/usuario/$usuarioId/em-andamento';
  static String metasConcluidas(String usuarioId) =>
      '/metas-financeiras/usuario/$usuarioId/concluidas';
  static String resumoMetas(String usuarioId) =>
      '/metas-financeiras/usuario/$usuarioId/resumo';
  static String adicionarValorMeta(String id) =>
      '/metas-financeiras/$id/adicionar-valor';
  static String subtrairValorMeta(String id) =>
      '/metas-financeiras/$id/subtrair-valor';
  static String marcarMetaConcluida(String id) =>
      '/metas-financeiras/$id/marcar-concluida';

  // Endpoints de Faturas
  static const String faturas = '/faturas';
  static String faturaPorId(String id) => '/faturas/$id';
  static String faturasPorCartao(String cartaoId) =>
      '/faturas/cartao/$cartaoId';
  static String faturasPendentesPorCartao(String cartaoId) =>
      '/faturas/cartao/$cartaoId/pendentes';
  static String faturasVencidas(String usuarioId) =>
      '/faturas/vencidas/$usuarioId';
  static String pagarFatura(String id) => '/faturas/$id/pagar';

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
}
