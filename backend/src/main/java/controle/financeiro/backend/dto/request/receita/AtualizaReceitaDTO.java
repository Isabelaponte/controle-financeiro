package controle.financeiro.backend.dto.request.receita;

import controle.financeiro.backend.enums.FormaPagamento;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AtualizaReceitaDTO {

    @Size(max = 200, message = "Descrição deve ter no máximo 200 caracteres")
    private String descricao;

    @Positive(message = "Valor deve ser positivo")
    private Double valor;

    private LocalDate dataRecebimento;

    private FormaPagamento formaPagamento;

    @Size(max = 500, message = "Caminho do anexo deve ter no máximo 500 caracteres")
    private String anexo;

    private Boolean fixa;

    private Boolean repete;

    @Min(value = 1, message = "Período deve ser no mínimo 1 mês")
    @Max(value = 120, message = "Período deve ser no máximo 120 meses")
    private Integer periodo;

    private Boolean recebida;

    private String contaId;

    private String categoriaId;
}
