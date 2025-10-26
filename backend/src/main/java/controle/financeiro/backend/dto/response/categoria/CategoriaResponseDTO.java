package controle.financeiro.backend.dto.response.categoria;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CategoriaResponseDTO {
    private String id;
    private String nome;
    private String cor;
    private String icone;
    private String descricao;
    private Boolean ativo;
    private String usuarioId;
    private String usuarioNome;
}
