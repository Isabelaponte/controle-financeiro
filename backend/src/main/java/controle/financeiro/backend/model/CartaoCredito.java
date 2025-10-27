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
    @GeneratedValue(generator = "uuid")
    @UuidGenerator
    private String id;

    @Column(nullable = false)
    private String nome;

    @Column
    private String icone;

    @Column(name = "limite_total", nullable = false)
    private Double limiteTotal;

    @Column(name = "dia_fechamento", nullable = false)
    private Integer diaFechamento;

    @Column(name = "dia_vencimento", nullable = false)
    private Integer diaVencimento;

    @Column(nullable = false)
    private Boolean ativo = true;

    @ManyToOne
    @JoinColumn(name = "FK_USUARIO_ID")
    private Usuario usuario;

    @ManyToOne
    @JoinColumn(name = "FK_CATEGORIA_ID")
    private Categoria categoria;
}
