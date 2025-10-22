package controle.financeiro.backend.model;

import jakarta.persistence.*;
import org.hibernate.annotations.UuidGenerator;

@Entity
@Table
public class Categoria {

    @Id
    @UuidGenerator
    private String id;

    @Column(unique = true, nullable = false)
    private String nome;

    @Column
    private String cor;

    @Column
    private String icone;

    @Column
    private String descricao;

    @Column
    private Boolean ativo;

    @ManyToOne
    @JoinColumn(name = "FK_USUARIO_ID")
    private Usuario usuario;

    public Categoria(String nome, String cor, String icone, String descricao, Boolean ativo, Usuario usuario) {
        this.nome = nome;
        this.cor = cor;
        this.icone = icone;
        this.descricao = descricao;
        this.ativo = ativo;
        this.usuario = usuario;
    }

    public Categoria(String id, String nome, String cor, String icone, String descricao, Boolean ativo, Usuario usuario) {
        this.id = id;
        this.nome = nome;
        this.cor = cor;
        this.icone = icone;
        this.descricao = descricao;
        this.ativo = ativo;
        this.usuario = usuario;
    }

    public String getId() {
        return id;
    }

    public String getNome() {
        return nome;
    }

    public String getCor() {
        return cor;
    }

    public String getIcone() {
        return icone;
    }

    public String getDescricao() {
        return descricao;
    }

    public Boolean getAtivo() {
        return ativo;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setId(String id) {
        this.id = id;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public void setCor(String cor) {
        this.cor = cor;
    }

    public void setIcone(String icone) {
        this.icone = icone;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public void setAtivo(Boolean ativo) {
        this.ativo = ativo;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }
}
