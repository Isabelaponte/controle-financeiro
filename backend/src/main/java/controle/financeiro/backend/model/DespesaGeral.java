package controle.financeiro.backend.model;

import controle.financeiro.backend.enums.StatusPagamento;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;
import java.util.Date;

@Entity
@Table(name = "despesa_geral")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class DespesaGeral extends Despesa{
    @Column
    private Integer periodo;

    @Column
    private Boolean repetir;

    @Column (name = "data_vencimento")
    private LocalDate dataVencimento;

    @ManyToOne
    @JoinColumn(name = "FK_CONTA_ID")
    private Conta conta;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private StatusPagamento statusPagamento = StatusPagamento.PENDENTE;
}
