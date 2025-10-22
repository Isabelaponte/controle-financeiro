package controle.financeiro.backend.model;

import jakarta.persistence.*;
import org.hibernate.annotations.UuidGenerator;

@Entity
@Table
public class Conta {
    @Id
    @UuidGenerator
    private String id;

    @Column(nullable = false)
    private String titulo;

    @Column
    private String icone;

    @Column
    private String tipo;

    @Column
    private Double saldo;

    @ManyToOne
    @JoinColumn(name = "FK_USUARIO_ID")
    private Usuario usuario;

    @ManyToOne
    @JoinColumn(name = "FK_CATEGORIA_ID")
    private Categoria categoria;

    public Conta(String titulo, String icone, String tipo, Double saldo, Usuario usuario, Categoria categoria) {
        this.titulo = titulo;
        this.icone = icone;
        this.tipo = tipo;
        this.saldo = saldo;
        this.usuario = usuario;
        this.categoria = categoria;
    }

    public Conta(String id, String titulo, String icone, String tipo, Double saldo, Usuario usuario, Categoria categoria) {
        this.id = id;
        this.titulo = titulo;
        this.icone = icone;
        this.tipo = tipo;
        this.saldo = saldo;
        this.usuario = usuario;
        this.categoria = categoria;
    }

    public String getId() {
        return id;
    }

    public String getTitulo() {
        return titulo;
    }

    public String getIcone() {
        return icone;
    }

    public String getTipo() {
        return tipo;
    }

    public Double getSaldo() {
        return saldo;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public Categoria getCategoria() {
        return categoria;
    }

    public void setId(String id) {
        this.id = id;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public void setIcone(String icone) {
        this.icone = icone;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public void setSaldo(Double saldo) {
        this.saldo = saldo;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }

    public void setCategoria(Categoria categoria) {
        this.categoria = categoria;
    }
}
