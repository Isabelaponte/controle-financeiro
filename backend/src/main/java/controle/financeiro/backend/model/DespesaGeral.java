package controle.financeiro.backend.model;

import controle.financeiro.backend.enums.StatusPagamento;
import jakarta.persistence.*;

import java.util.Date;

@Entity
@Table
public class DespesaGeral extends Despesa{
    @Column
    private Integer periodo;

    @Column
    private Boolean repetir;

    @ManyToOne
    @JoinColumn(name = "FK_CONTA_ID")
    private Conta conta;

    @Column
    private StatusPagamento statusPagamento;

    public DespesaGeral(Boolean pago, Date lembrete, Date dataDespesa, Double valor, String descricao, Usuario usuario, Categoria categoria, Integer periodo, Boolean repetir, Conta conta, StatusPagamento statusPagamento) {
        super(pago, lembrete, dataDespesa, valor, descricao, usuario, categoria);
        this.periodo = periodo;
        this.repetir = repetir;
        this.conta = conta;
        this.statusPagamento = statusPagamento;
    }

    public DespesaGeral(String id, Boolean pago, Date lembrete, Date dataDespesa, Double valor, String descricao, Usuario usuario, Categoria categoria, Integer periodo, Boolean repetir, Conta conta, StatusPagamento statusPagamento) {
        super(id, pago, lembrete, dataDespesa, valor, descricao, usuario, categoria);
        this.periodo = periodo;
        this.repetir = repetir;
        this.conta = conta;
        this.statusPagamento = statusPagamento;
    }

    public Integer getPeriodo() {
        return periodo;
    }

    public void setPeriodo(Integer periodo) {
        this.periodo = periodo;
    }

    public Boolean getRepetir() {
        return repetir;
    }

    public void setRepetir(Boolean repetir) {
        this.repetir = repetir;
    }

    public Conta getConta() {
        return conta;
    }

    public void setConta(Conta conta) {
        this.conta = conta;
    }

    public StatusPagamento getStatusPagamento() {
        return statusPagamento;
    }

    public void setStatusPagamento(StatusPagamento statusPagamento) {
        this.statusPagamento = statusPagamento;
    }
}
