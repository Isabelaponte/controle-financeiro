package controle.financeiro.backend.dto.request.conta;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CriaContaDTO {
    @NotBlank(message = "Nome é obrigatório")
    @Size(max = 50, message = "Nome deve ter no máximo 50 caracteres")
    private String nome;

    @Size(max = 50, message = "Ícone deve ter no máximo 50 caracteres")
    private String icone;

    @NotBlank(message = "Tipo é obrigatório")
    @Size(max = 30, message = "Tipo deve ter no máximo 30 caracteres")
    private String tipo;

    private Double saldo = 0.0;

    @NotNull(message = "ID do usuário é obrigatório")
    private String usuarioId;

    private String categoriaId;
}
