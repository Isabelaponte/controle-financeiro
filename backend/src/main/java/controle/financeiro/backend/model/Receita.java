package controle.financeiro.backend.model;

import controle.financeiro.backend.enums.FormaPagamento;
import jakarta.persistence.*;
import org.hibernate.annotations.UuidGenerator;

import java.util.Date;

@Entity
@Table
public class Receita {
    @Id
    @GeneratedValue
    @UuidGenerator
    private String id;

    @Column
    private Date dataRecebimento;

    @Column
    private FormaPagamento formaPagamento;

    @Column
    private String anexo;

    @Column
    private Boolean fixa;

    @Column
    private Boolean repete;

    @Column
    private Integer periodo;

    @ManyToOne
    @JoinColumn(name = "FK_CONTA_ID")
    private Conta conta;

    @ManyToOne
    @JoinColumn(name = "FK_USUARIO_ID")
    private Usuario usuario;

    public Receita(Date dataRecebimento, FormaPagamento formaPagamento, String anexo, Boolean fixa, Boolean repete, Integer periodo, Conta conta, Usuario usuario) {
        this.dataRecebimento = dataRecebimento;
        this.formaPagamento = formaPagamento;
        this.anexo = anexo;
        this.fixa = fixa;
        this.repete = repete;
        this.periodo = periodo;
        this.conta = conta;
        this.usuario = usuario;
    }

    public Receita(String id, Date dataRecebimento, FormaPagamento formaPagamento, String anexo, Boolean fixa, Boolean repete, Integer periodo, Conta conta, Usuario usuario) {
        this.id = id;
        this.dataRecebimento = dataRecebimento;
        this.formaPagamento = formaPagamento;
        this.anexo = anexo;
        this.fixa = fixa;
        this.repete = repete;
        this.periodo = periodo;
        this.conta = conta;
        this.usuario = usuario;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Date getDataRecebimento() {
        return dataRecebimento;
    }

    public void setDataRecebimento(Date dataRecebimento) {
        this.dataRecebimento = dataRecebimento;
    }

    public FormaPagamento getFormaPagamento() {
        return formaPagamento;
    }

    public void setFormaPagamento(FormaPagamento formaPagamento) {
        this.formaPagamento = formaPagamento;
    }

    public String getAnexo() {
        return anexo;
    }

    public void setAnexo(String anexo) {
        this.anexo = anexo;
    }

    public Boolean getFixa() {
        return fixa;
    }

    public void setFixa(Boolean fixa) {
        this.fixa = fixa;
    }

    public Boolean getRepete() {
        return repete;
    }

    public void setRepete(Boolean repete) {
        this.repete = repete;
    }

    public Integer getPeriodo() {
        return periodo;
    }

    public void setPeriodo(Integer periodo) {
        this.periodo = periodo;
    }

    public Conta getConta() {
        return conta;
    }

    public void setConta(Conta conta) {
        this.conta = conta;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }
}
