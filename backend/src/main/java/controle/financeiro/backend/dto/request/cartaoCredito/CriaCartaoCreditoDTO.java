package controle.financeiro.backend.dto.request.cartaoCredito;

import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CriaCartaoCreditoDTO {

    @NotBlank(message = "Nome é obrigatório")
    @Size(max = 50, message = "Nome deve ter no máximo 50 caracteres")
    private String nome;

    private String icone;

    @NotNull(message = "Limite total é obrigatório")
    @Positive(message = "Limite total deve ser positivo")
    private Double limiteTotal;

    @NotNull(message = "Dia de fechamento é obrigatório")
    @Min(value = 1, message = "Dia de fechamento deve ser entre 1 e 31")
    @Max(value = 31, message = "Dia de fechamento deve ser entre 1 e 31")
    private Integer diaFechamento;

    @NotNull(message = "Dia de vencimento é obrigatório")
    @Min(value = 1, message = "Dia de vencimento deve ser entre 1 e 31")
    @Max(value = 31, message = "Dia de vencimento deve ser entre 1 e 31")
    private Integer diaVencimento;

    @NotNull(message = "ID do usuário é obrigatório")
    private String usuarioId;

    private String categoriaId;
}
