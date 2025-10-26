package controle.financeiro.backend.exception.usuario;

public class EmailJaExisteException extends RuntimeException{

    public EmailJaExisteException(String message) {
        super(message);
    }
}
