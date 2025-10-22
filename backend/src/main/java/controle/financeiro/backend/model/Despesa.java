package controle.financeiro.backend.model;

import jakarta.persistence.*;
import org.hibernate.annotations.UuidGenerator;

import java.util.Date;

@Entity
public class Despesa {
    @Id
    @UuidGenerator
    private String id;

    @Column
    private Boolean pago;

    @Column
    private Date lembrete;

    @Column(nullable = false)
    private Date dataDespesa;

    @Column
    private Double valor;

    @Column
    private String descricao;

    @ManyToOne
    @JoinColumn(name = "FK_USUARIO_ID")
    private Usuario usuario;

    @ManyToOne
    @JoinColumn(name = "FK_CATEGORIA_ID")
    private Categoria categoria;

    public Despesa(Boolean pago, Date lembrete, Date dataDespesa, Double valor, String descricao, Usuario usuario, Categoria categoria) {
        this.pago = pago;
        this.lembrete = lembrete;
        this.dataDespesa = dataDespesa;
        this.valor = valor;
        this.descricao = descricao;
        this.usuario = usuario;
        this.categoria = categoria;
    }

    public Despesa(String id, Boolean pago, Date lembrete, Date dataDespesa, Double valor, String descricao, Usuario usuario, Categoria categoria) {
        this.id = id;
        this.pago = pago;
        this.lembrete = lembrete;
        this.dataDespesa = dataDespesa;
        this.valor = valor;
        this.descricao = descricao;
        this.usuario = usuario;
        this.categoria = categoria;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Boolean getPago() {
        return pago;
    }

    public void setPago(Boolean pago) {
        this.pago = pago;
    }

    public Date getLembrete() {
        return lembrete;
    }

    public void setLembrete(Date lembrete) {
        this.lembrete = lembrete;
    }

    public Date getDataDespesa() {
        return dataDespesa;
    }

    public void setDataDespesa(Date dataDespesa) {
        this.dataDespesa = dataDespesa;
    }

    public Double getValor() {
        return valor;
    }

    public void setValor(Double valor) {
        this.valor = valor;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }

    public Categoria getCategoria() {
        return categoria;
    }

    public void setCategoria(Categoria categoria) {
        this.categoria = categoria;
    }
}
