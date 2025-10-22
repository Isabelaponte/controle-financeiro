package controle.financeiro.backend.model;

import jakarta.persistence.*;
import org.hibernate.annotations.UuidGenerator;
import java.util.Date;

@Entity
@Table
public class CartaoCredito {

    @Id
    @UuidGenerator
    private String id;

    @Column(nullable = false)
    private String nome;

    @Column
    private String icone;

    @Column(nullable = false)
    private Double limiteTotal;

    @Column(nullable = false)
    private Date dataFechamento;

    @Column(nullable = false)
    private Date dataVencimento;

    @ManyToOne
    @JoinColumn(name = "FK_USUARIO_ID")
    private Usuario usuario;

    @ManyToOne
    @JoinColumn(name = "FK_CATEGORIA_ID")
    private Categoria categoria;

    public CartaoCredito() {}

    public CartaoCredito(String nome, String icone, Double limiteTotal, Date dataFechamento, Date dataVencimento, Usuario usuario, Categoria categoria) {
        this.nome = nome;
        this.icone = icone;
        this.limiteTotal = limiteTotal;
        this.dataFechamento = dataFechamento;
        this.dataVencimento = dataVencimento;
        this.usuario = usuario;
        this.categoria = categoria;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getIcone() {
        return icone;
    }

    public void setIcone(String icone) {
        this.icone = icone;
    }

    public Double getLimiteTotal() {
        return limiteTotal;
    }

    public void setLimiteTotal(Double limiteTotal) {
        this.limiteTotal = limiteTotal;
    }

    public Date getDataFechamento() {
        return dataFechamento;
    }

    public void setDataFechamento(Date dataFechamento) {
        this.dataFechamento = dataFechamento;
    }

    public Date getDataVencimento() {
        return dataVencimento;
    }

    public void setDataVencimento(Date dataVencimento) {
        this.dataVencimento = dataVencimento;
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
