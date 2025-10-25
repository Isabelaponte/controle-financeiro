package controle.financeiro.backend.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.UuidGenerator;

import java.util.Date;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
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
}
