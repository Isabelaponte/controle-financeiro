package controle.financeiro.backend.model;

import jakarta.persistence.*;
import org.hibernate.annotations.UuidGenerator;

@Entity
@Table
public class MetaFinanceira {
    @Id
    @UuidGenerator
    private String id;

    @Column(nullable = false)
    private Double valorDesejado;

    @Column
    private Double valorAtual;

    @Column
    private Integer prazo;

    @ManyToOne
    @JoinColumn(name = "FK_CATEGORIA_ID")
    private Categoria categoria;

    @ManyToOne
    @JoinColumn(name = "FK_USUARIO_ID")
    private Usuario usuario;

    public MetaFinanceira(Double valorDesejado, Double valorAtual, Integer prazo, Categoria categoria, Usuario usuario) {
        this.valorDesejado = valorDesejado;
        this.valorAtual = valorAtual;
        this.prazo = prazo;
        this.categoria = categoria;
        this.usuario = usuario;
    }

    public MetaFinanceira(String id, Double valorDesejado, Double valorAtual, Integer prazo, Categoria categoria, Usuario usuario) {
        this.id = id;
        this.valorDesejado = valorDesejado;
        this.valorAtual = valorAtual;
        this.prazo = prazo;
        this.categoria = categoria;
        this.usuario = usuario;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Double getValorDesejado() {
        return valorDesejado;
    }

    public void setValorDesejado(Double valorDesejado) {
        this.valorDesejado = valorDesejado;
    }

    public Double getValorAtual() {
        return valorAtual;
    }

    public void setValorAtual(Double valorAtual) {
        this.valorAtual = valorAtual;
    }

    public Integer getPrazo() {
        return prazo;
    }

    public void setPrazo(Integer prazo) {
        this.prazo = prazo;
    }

    public Categoria getCategoria() {
        return categoria;
    }

    public void setCategoria(Categoria categoria) {
        this.categoria = categoria;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }
}
