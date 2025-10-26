package controle.financeiro.backend.model;

import controle.financeiro.backend.enums.FormaPagamento;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.UuidGenerator;

import java.util.Date;

@Entity
@Table(name = "receita")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Receita {
    @Id
    @GeneratedValue(generator = "uuid")
    @UuidGenerator
    private String id;

    @Column(name = "data_recebimento")
    private Date dataRecebimento;

    @Column
    private FormaPagamento formaPagamento;

    @Column
    private String anexo;

    @Column
    private Boolean fixa;

    @Column
    private Boolean repete;

    @Column
    private Integer periodo;

    @ManyToOne
    @JoinColumn(name = "FK_CONTA_ID")
    private Conta conta;

    @ManyToOne
    @JoinColumn(name = "FK_USUARIO_ID")
    private Usuario usuario;
}
