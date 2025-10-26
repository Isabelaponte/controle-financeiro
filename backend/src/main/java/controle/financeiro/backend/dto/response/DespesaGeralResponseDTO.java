package controle.financeiro.backend.dto.response;

import controle.financeiro.backend.enums.StatusPagamento;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DespesaGeralResponseDTO {
    private String id;
    private Double valor;
    private String descricao;
    private LocalDate dataDespesa;
    private LocalDate lembrete;
    private Boolean pago;
    private Integer periodo;
    private Boolean repetir;
    private StatusPagamento statusPagamento;

    private String usuarioId;
    private String usuarioNome;

    private String categoriaId;
    private String categoriaNome;

    private String contaId;
    private String contaNome;

    private LocalDateTime dataCriacao;
    private LocalDateTime dataAtualizacao;
}
