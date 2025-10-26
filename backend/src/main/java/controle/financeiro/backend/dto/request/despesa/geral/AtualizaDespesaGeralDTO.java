package controle.financeiro.backend.dto.request.despesa.geral;

import controle.financeiro.backend.enums.StatusPagamento;
import jakarta.validation.constraints.Positive;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AtualizaDespesaGeralDTO {
    @Positive(message = "Valor deve ser positivo")
    private Double valor;

    private String descricao;

    private LocalDate dataDespesa;

    private LocalDate lembrete;

    private Boolean pago;

    private String categoriaId;

    private String contaId;

    private Integer periodo;

    private Boolean repetir;

    private StatusPagamento statusPagamento;
}
