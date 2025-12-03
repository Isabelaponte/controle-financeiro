package controle.financeiro.backend.dto.request.despesa.cartao;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.PositiveOrZero;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CriaDespesaCartaoDTO {

    @NotNull(message = "Valor é obrigatório")
    @Positive(message = "Valor deve ser positivo")
    private Double valor;

    private String descricao;

    private LocalDate dataDespesa = LocalDate.now();

    private LocalDate lembrete;

    @NotNull(message = "ID do usuário é obrigatório")
    private String usuarioId;

    @NotNull(message = "ID da categoria é obrigatório")
    private String categoriaId;

    @NotNull(message = "ID do cartão é obrigatório")
    private String cartaoId;

    private String faturaId;

    private Boolean fixa = false;

    @PositiveOrZero(message = "Quantidade de parcelas deve ser zero ou positivo")
    private Integer quantidadeParcelas = 1;

    @PositiveOrZero(message = "Juros deve ser zero ou positivo")
    private Double juros = 0.0;
}
