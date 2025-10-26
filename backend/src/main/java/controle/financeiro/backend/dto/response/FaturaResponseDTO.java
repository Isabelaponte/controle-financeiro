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
public class FaturaResponseDTO {

    private String id;
    private Double valorTotal;
    private LocalDate dataVencimento;
    private LocalDate dataPagamento;
    private StatusPagamento statusPagamento;
    private Boolean vencida;
    private Integer diasParaVencimento;

    private String cartaoId;
    private String cartaoNome;

    private LocalDateTime dataCriacao;
    private LocalDateTime dataAtualizacao;
}
