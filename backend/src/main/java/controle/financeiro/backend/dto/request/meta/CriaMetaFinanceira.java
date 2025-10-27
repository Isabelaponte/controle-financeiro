package controle.financeiro.backend.dto.request.meta;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CriaMetaFinanceira {

    @NotBlank(message = "Nome é obrigatório")
    @Size(max = 100, message = "Nome deve ter no máximo 100 caracteres")
    private String nome;

    @NotNull(message = "Valor desejado é obrigatório")
    @Positive(message = "Valor desejado deve ser positivo")
    private Double valorDesejado;

    private Double valorAtual = 0.0;

    @NotNull(message = "Data de início é obrigatória")
    private LocalDate dataInicio;

    private LocalDate dataAlvo;

    private String categoriaId;

    @NotNull(message = "ID do usuário é obrigatório")
    private String usuarioId;
}
