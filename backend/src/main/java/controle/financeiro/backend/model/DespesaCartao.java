package controle.financeiro.backend.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;

@Entity
@Table(name = "despesa_cartao")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class DespesaCartao extends Despesa{
    @Column
    private Boolean fixa;

    @Column
    private Integer quantidadeParcelas;

    @Column
    private Double juros;

    @ManyToOne
    @JoinColumn(name = "FK_CARTAO_ID")
    private CartaoCredito cartaoCredito;

    @ManyToOne
    @JoinColumn(name = "FK_FATURA_ID")
    private Fatura fatura;
}
