package controle.financeiro.backend.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.UuidGenerator;

import java.util.Date;

@Entity
@Inheritance(strategy = InheritanceType.TABLE_PER_CLASS)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public abstract class Despesa {
    @Id
    @GeneratedValue(generator = "uuid")
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
}
