package controle.financeiro.backend.dto.request.cartaoCredito;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AtualizaCartaoCreditoDTO {

    @Size(max = 50, message = "Nome deve ter no máximo 50 caracteres")
    private String nome;

    @Size(max = 50, message = "Ícone deve ter no máximo 50 caracteres")
    private String icone;

    @Positive(message = "Limite total deve ser positivo")
    private Double limiteTotal;

    @Min(value = 1, message = "Dia de fechamento deve ser entre 1 e 31")
    @Max(value = 31, message = "Dia de fechamento deve ser entre 1 e 31")
    private Integer diaFechamento;

    @Min(value = 1, message = "Dia de vencimento deve ser entre 1 e 31")
    @Max(value = 31, message = "Dia de vencimento deve ser entre 1 e 31")
    private Integer diaVencimento;

    private Boolean ativo;

    private String categoriaId;
}