package controle.financeiro.backend.model;

import controle.financeiro.backend.enums.StatusPagamento;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.UuidGenerator;

import java.util.Date;

@Entity
@Table
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Fatura {
    @Id
    @UuidGenerator
    private String id;

    @Column
    private Double valorTotal;

    @Column
    private Date dataVencimento;

    @Column
    private StatusPagamento statusPagamento;

    @ManyToOne
    @JoinColumn(name = "FK_CARTAO_ID")
    private CartaoCredito cartaoCredito;
}


