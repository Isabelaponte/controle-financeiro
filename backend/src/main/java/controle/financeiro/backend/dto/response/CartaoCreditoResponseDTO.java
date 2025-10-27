package controle.financeiro.backend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CartaoCreditoResponseDTO {

    private String id;
    private String nome;
    private String icone;
    private Double limiteTotal;
    private Integer diaFechamento;
    private Integer diaVencimento;
    private Boolean ativo;

    private String usuarioId;
    private String usuarioNome;

    private String categoriaId;
    private String categoriaNome;
}