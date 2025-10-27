package controle.financeiro.backend.dto.request.receita;

import controle.financeiro.backend.enums.FormaPagamento;
import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CriaReceitaDTO {
    @NotBlank(message = "Descrição é obrigatória")
    @Size(max = 200, message = "Descrição deve ter no máximo 200 caracteres")
    private String descricao;

    @NotNull(message = "Valor é obrigatório")
    @Positive(message = "Valor deve ser positivo")
    private Double valor;

    @NotNull(message = "Data de recebimento é obrigatória")
    private LocalDate dataRecebimento;

    @NotNull(message = "Forma de pagamento é obrigatória")
    private FormaPagamento formaPagamento;

    @Size(max = 500, message = "Caminho do anexo deve ter no máximo 500 caracteres")
    private String anexo;

    private Boolean fixa = false;

    private Boolean repete = false;

    @Min(value = 1, message = "Período deve ser no mínimo 1 mês")
    @Max(value = 120, message = "Período deve ser no máximo 120 meses")
    private Integer periodo;

    @NotNull(message = "ID da conta é obrigatório")
    private String contaId;

    private String categoriaId;

    @NotNull(message = "ID do usuário é obrigatório")
    private String usuarioId;
}
