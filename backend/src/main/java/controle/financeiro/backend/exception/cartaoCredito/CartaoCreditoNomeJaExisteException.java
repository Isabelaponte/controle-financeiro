package controle.financeiro.backend.exception.cartaoCredito;

public class CartaoCreditoNomeJaExisteException extends RuntimeException {
    public CartaoCreditoNomeJaExisteException(String mensagem) {
        super(mensagem);
    }
}