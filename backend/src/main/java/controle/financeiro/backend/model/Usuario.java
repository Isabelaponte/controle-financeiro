package controle.financeiro.backend.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table
public class Usuario {
    @Id
    private String id;

    @Column(unique = true, nullable = false)
    private String email;

    @Column(nullable = false)
    private String senha;

    @Column(nullable = false)
    private String nomeUsuario;

    public Usuario(String email, String senha, String nomeUsuario) {
        this.email = email;
        this.senha = senha;
        this.nomeUsuario = nomeUsuario;
    }

    public Usuario(String id, String email, String senha, String nomeUsuario) {
        this.id = id;
        this.email = email;
        this.senha = senha;
        this.nomeUsuario = nomeUsuario;
    }

    public String getId() {
        return id;
    }

    public String getEmail() {
        return email;
    }

    public String getSenha() {
        return senha;
    }

    public String getNomeUsuario() {
        return nomeUsuario;
    }

    public void setId(String id) {
        this.id = id;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setSenha(String senha) {
        this.senha = senha;
    }

    public void setNomeUsuario(String nomeUsuario) {
        this.nomeUsuario = nomeUsuario;
    }
}


