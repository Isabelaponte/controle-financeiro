package controle.financeiro.backend.exception.categoria;

public class CategoriaNomeJaExisteException extends RuntimeException {
    public CategoriaNomeJaExisteException(String message) {
        super(message);
    }
}
