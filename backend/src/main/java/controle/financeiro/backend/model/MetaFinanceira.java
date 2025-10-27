package controle.financeiro.backend.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.UuidGenerator;

import java.time.LocalDate;

@Entity
@Table(name = "meta_financeira")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class MetaFinanceira {
    @Id
    @GeneratedValue(generator = "uuid")
    @UuidGenerator
    private String id;

    @Column
    private String nome;

    @Column(name = "valor_desejado", nullable = false)
    private Double valorDesejado;

    @Column(name = "valor_atual")
    private Double valorAtual = 0.0;

    @Column(name = "data_inicio", nullable = false)
    private LocalDate dataInicio;

    @Column(name = "data_alvo")
    private LocalDate dataAlvo;

    @Column(nullable = false)
    private Boolean concluida = false;

    @ManyToOne
    @JoinColumn(name = "FK_CATEGORIA_ID")
    private Categoria categoria;

    @ManyToOne
    @JoinColumn(name = "FK_USUARIO_ID")
    private Usuario usuario;
}
