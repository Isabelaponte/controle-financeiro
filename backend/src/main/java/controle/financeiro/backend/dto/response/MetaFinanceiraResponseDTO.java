package controle.financeiro.backend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class MetaFinanceiraResponseDTO {
    private String id;
    private String nome;
    private Double valorDesejado;
    private Double valorAtual;
    private Double valorRestante;
    private Double percentualConcluido;
    private LocalDate dataInicio;
    private LocalDate dataAlvo;
    private Long diasRestantes;
    private Boolean ativa;
    private Boolean concluida;

    private String categoriaId;
    private String categoriaNome;

    private String usuarioId;
    private String usuarioNome;
}
