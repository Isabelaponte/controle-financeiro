package controle.financeiro.backend.dto.request.categoria;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CriaCategoriaDTO {

    @NotBlank(message = "Nome é obrigatório")
    @Size(max = 25, message = "Nome deve ter no máximo 25 caracteres")
    private String nome;

    @Size(max = 7, message = "Cor deve estar no formato #RRGGBB")
    private String cor;

    private String icone;
    private String descricao;

    @NotNull(message = "ID do usuário é obrigatório")
    private String usuarioId;
}
