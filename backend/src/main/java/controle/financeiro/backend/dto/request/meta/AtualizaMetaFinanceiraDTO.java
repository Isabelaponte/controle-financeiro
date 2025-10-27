package controle.financeiro.backend.dto.request.meta;

import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AtualizaMetaFinanceiraDTO {
    @Size(max = 100, message = "Nome deve ter no máximo 100 caracteres")
    private String nome;

    @Positive(message = "Valor desejado deve ser positivo")
    private Double valorDesejado;

    private LocalDate dataInicio;

    private LocalDate dataAlvo;

    private Boolean ativa;

    private String categoriaId;
}
