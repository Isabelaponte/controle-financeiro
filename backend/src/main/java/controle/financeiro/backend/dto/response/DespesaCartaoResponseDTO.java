package controle.financeiro.backend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DespesaCartaoResponseDTO {

    private String id;
    private Double valor;
    private String descricao;
    private LocalDate dataDespesa;
    private LocalDate lembrete;
    private Boolean pago;
    private Boolean fixa;
    private Integer quantidadeParcelas;
    private Double juros;
    private Double valorTotal;
    private Double valorParcela;

    private String usuarioId;
    private String usuarioNome;

    private String categoriaId;
    private String categoriaNome;

    private String cartaoId;
    private String cartaoNome;

    private String faturaId;

    private LocalDateTime dataCriacao;
    private LocalDateTime dataAtualizacao;
}
