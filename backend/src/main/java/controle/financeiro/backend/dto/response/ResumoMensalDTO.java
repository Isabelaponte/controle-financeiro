package controle.financeiro.backend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ResumoMensalDTO {
    private Double totalGanhos;
    private Double totalGastos;
    private Double saldo;
    private int mes;
    private int ano;
}