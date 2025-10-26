package controle.financeiro.backend.dto.request.fatura;

import controle.financeiro.backend.enums.StatusPagamento;
import jakarta.validation.constraints.PositiveOrZero;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AtualizaFaturaDTO {

    private LocalDate dataVencimento;

    @PositiveOrZero(message = "Valor total deve ser zero ou positivo")
    private Double valorTotal;

    private LocalDate dataPagamento;

    private StatusPagamento statusPagamento;
}
