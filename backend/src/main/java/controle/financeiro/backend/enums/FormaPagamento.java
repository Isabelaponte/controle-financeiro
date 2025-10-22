package controle.financeiro.backend.enums;

import java.util.Arrays;

public enum FormaPagamento {
    PIX("PIX"),
    CREDITO("Crédito"),
    DEBITO("Débito");

    private String label;

    FormaPagamento(String label) {
        this.label = label;
    }

    public static FormaPagamento toEnum(String value) {
        return Arrays.stream(FormaPagamento.values())
                .filter(c -> value.equals(c.toString()))
                .findAny()
                .orElseThrow(IllegalArgumentException::new);
    }
}
