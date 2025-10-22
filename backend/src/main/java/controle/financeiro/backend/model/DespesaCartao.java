package controle.financeiro.backend.model;

import jakarta.persistence.*;

import java.util.Date;

@Entity
@Table
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

    public DespesaCartao(Boolean pago, Date lembrete, Date dataDespesa, Double valor, String descricao, Usuario usuario, Categoria categoria, Boolean fixa, Integer quantidadeParcelas, Double juros, CartaoCredito cartaoCredito, Fatura fatura) {
        super(pago, lembrete, dataDespesa, valor, descricao, usuario, categoria);
        this.fixa = fixa;
        this.quantidadeParcelas = quantidadeParcelas;
        this.juros = juros;
        this.cartaoCredito = cartaoCredito;
        this.fatura = fatura;
    }

    public DespesaCartao(String id, Boolean pago, Date lembrete, Date dataDespesa, Double valor, String descricao, Usuario usuario, Categoria categoria, Boolean fixa, Integer quantidadeParcelas, Double juros, CartaoCredito cartaoCredito, Fatura fatura) {
        super(id, pago, lembrete, dataDespesa, valor, descricao, usuario, categoria);
        this.fixa = fixa;
        this.quantidadeParcelas = quantidadeParcelas;
        this.juros = juros;
        this.cartaoCredito = cartaoCredito;
        this.fatura = fatura;
    }

    public Boolean getFixa() {
        return fixa;
    }

    public void setFixa(Boolean fixa) {
        this.fixa = fixa;
    }

    public Integer getQuantidadeParcelas() {
        return quantidadeParcelas;
    }

    public void setQuantidadeParcelas(Integer quantidadeParcelas) {
        this.quantidadeParcelas = quantidadeParcelas;
    }

    public Double getJuros() {
        return juros;
    }

    public void setJuros(Double juros) {
        this.juros = juros;
    }

    public CartaoCredito getCartaoCredito() {
        return cartaoCredito;
    }

    public void setCartaoCredito(CartaoCredito cartaoCredito) {
        this.cartaoCredito = cartaoCredito;
    }

    public Fatura getFatura() {
        return fatura;
    }

    public void setFatura(Fatura fatura) {
        this.fatura = fatura;
    }
}
