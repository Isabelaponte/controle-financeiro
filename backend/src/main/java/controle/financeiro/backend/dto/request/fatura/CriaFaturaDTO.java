package controle.financeiro.backend.dto.request.fatura;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CriaFaturaDTO {

    @NotNull(message = "Data de vencimento é obrigatória")
    private LocalDate dataVencimento;

    @PositiveOrZero(message = "Valor total deve ser zero ou positivo")
    private Double valorTotal = 0.0;

    @NotNull(message = "ID do cartão é obrigatório")
    private String cartaoId;
}
