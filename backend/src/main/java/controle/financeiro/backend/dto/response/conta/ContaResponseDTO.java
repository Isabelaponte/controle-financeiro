package controle.financeiro.backend.dto.response.conta;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ContaResponseDTO {

    private String id;
    private String nome;
    private String icone;
    private String tipo;
    private Double saldo;
    private Boolean ativa;

    private String usuarioId;
    private String usuarioNome;

    private String categoriaId;
    private String categoriaNome;
}