package controle.financeiro.backend.exception.conta;

public class ContaNomeJaExisteException extends RuntimeException {
    public ContaNomeJaExisteException(String mensagem) {
        super(mensagem);
    }
}
