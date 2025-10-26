package controle.financeiro.backend.enums;

import java.util.Arrays;

public enum StatusPagamento {
    ATRASADO("Atrasado"),
    FECHADO("Fechado"),
    ABERTO("Aberto"),
    PAGO("Pago"),
    PENDENTE("Pendente");

    private String label;

    StatusPagamento(String label) {
        this.label = label;
    }

    public static StatusPagamento toEnum(String value) {
        return Arrays.stream(StatusPagamento.values())
                .filter(c -> value.equals(c.toString()))
                .findAny()
                .orElseThrow(IllegalArgumentException::new);
    }
}
