package controle.financeiro.backend.dto.request.despesa.cartao;

import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.PositiveOrZero;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AtualizaDespesaCartaoDTO {

    @Positive(message = "Valor deve ser positivo")
    private Double valor;

    private String descricao;

    private LocalDate dataDespesa;

    private LocalDate lembrete;

    private Boolean pago;
    // a ideia é pagar a fatura e nao a despesa do cartao... devemos melhorar essa logica pra funcionar corrretamente.
    // Se a fatura estiver paga, aí sim a despesa relacionada a ela fica paga também

    private String categoriaId;

    private String cartaoId;

    private String faturaId;

    private Boolean fixa;

    @PositiveOrZero(message = "Quantidade de parcelas deve ser zero ou positivo")
    private Integer quantidadeParcelas;

    @PositiveOrZero(message = "Juros deve ser zero ou positivo")
    private Double juros;
}
