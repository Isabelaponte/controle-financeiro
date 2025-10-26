package controle.financeiro.backend.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.UuidGenerator;
import java.util.Date;

@Entity
@Table(name = "cartao_credito")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CartaoCredito {

    @Id
    @UuidGenerator
    private String id;

    @Column(nullable = false)
    private String nome;

    @Column
    private String icone;

    @Column(name = "limite_total", nullable = false)
    private Double limiteTotal;

    @Column(name = "data_fechamento", nullable = false)
    private Date dataFechamento;

    @Column(name = "data_vencimento", nullable = false)
    private Date dataVencimento;

    @ManyToOne
    @JoinColumn(name = "FK_USUARIO_ID")
    private Usuario usuario;

    @ManyToOne
    @JoinColumn(name = "FK_CATEGORIA_ID")
    private Categoria categoria;
}
