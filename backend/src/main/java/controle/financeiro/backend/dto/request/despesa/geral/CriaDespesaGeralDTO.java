package controle.financeiro.backend.dto.request.despesa.geral;


import controle.financeiro.backend.enums.StatusPagamento;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CriaDespesaGeralDTO {
    @NotNull(message = "Valor é obrigatório")
    @Positive(message = "Valor deve ser positivo")
    private Double valor;

    private String descricao;

    private LocalDate dataDespesa = LocalDate.now();

    private LocalDate dataVencimento;

    private LocalDate lembrete;

    @NotNull(message = "ID do usuário é obrigatório")
    private String usuarioId;

    private String categoriaId;

    private String contaId;

    private Integer periodo;

    private Boolean repetir;

    private Boolean pago;

    private StatusPagamento statusPagamento;
}
