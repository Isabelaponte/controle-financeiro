package controle.financeiro.backend.exception.usuario;

public class SenhaInvalidaException extends RuntimeException{
    public SenhaInvalidaException(String message) {
        super(message);
    }
}
