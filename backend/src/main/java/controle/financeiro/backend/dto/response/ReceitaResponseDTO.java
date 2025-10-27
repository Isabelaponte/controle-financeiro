package controle.financeiro.backend.dto.response;

import controle.financeiro.backend.enums.FormaPagamento;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ReceitaResponseDTO {

    private String id;
    private String descricao;
    private Double valor;
    private LocalDate dataRecebimento;
    private FormaPagamento formaPagamento;
    private String anexo;
    private Boolean fixa;
    private Boolean repete;
    private Integer periodo;
    private Boolean recebida;

    private String contaId;
    private String contaNome;

    private String categoriaId;
    private String categoriaNome;

    private String usuarioId;
    private String usuarioNome;
}
