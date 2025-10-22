package controle.financeiro.backend.model;

import controle.financeiro.backend.enums.StatusPagamento;
import jakarta.persistence.*;
import org.hibernate.annotations.UuidGenerator;

import java.util.Date;

@Entity
@Table
public class Fatura {
    @Id
    @UuidGenerator
    private String id;

    @Column
    private Double valorTotal;

    @Column
    private Date dataVencimento;

    @Column
    private StatusPagamento statusPagamento;

    @ManyToOne
    @JoinColumn(name = "FK_CARTAO_ID")
    private CartaoCredito cartaoCredito;

    public Fatura(Double valorTotal, Date dataVencimento, StatusPagamento statusPagamento, CartaoCredito cartaoCredito) {
        this.valorTotal = valorTotal;
        this.dataVencimento = dataVencimento;
        this.statusPagamento = statusPagamento;
        this.cartaoCredito = cartaoCredito;
    }

    public Fatura(String id, Double valorTotal, Date dataVencimento, StatusPagamento statusPagamento, CartaoCredito cartaoCredito) {
        this.id = id;
        this.valorTotal = valorTotal;
        this.dataVencimento = dataVencimento;
        this.statusPagamento = statusPagamento;
        this.cartaoCredito = cartaoCredito;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Double getValorTotal() {
        return valorTotal;
    }

    public void setValorTotal(Double valorTotal) {
        this.valorTotal = valorTotal;
    }

    public Date getDataVencimento() {
        return dataVencimento;
    }

    public void setDataVencimento(Date dataVencimento) {
        this.dataVencimento = dataVencimento;
    }

    public StatusPagamento getStatusPagamento() {
        return statusPagamento;
    }

    public void setStatusPagamento(StatusPagamento statusPagamento) {
        this.statusPagamento = statusPagamento;
    }

    public CartaoCredito getCartaoCredito() {
        return cartaoCredito;
    }

    public void setCartaoCredito(CartaoCredito cartaoCredito) {
        this.cartaoCredito = cartaoCredito;
    }
}


