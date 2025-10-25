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
}
