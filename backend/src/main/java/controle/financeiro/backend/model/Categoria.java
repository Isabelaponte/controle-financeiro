package controle.financeiro.backend.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.UuidGenerator;

@Entity
@Table
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
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
}
