package controle.financeiro.backend.model;

import controle.financeiro.backend.enums.StatusPagamento;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.hibernate.annotations.UuidGenerator;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Date;

@Entity
@Table(name = "fatura")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Fatura {
    @Id
    @GeneratedValue(generator = "uuid")
    @UuidGenerator
    private String id;

    @Column
    private Double valorTotal;

    @Column
    private LocalDate dataVencimento;

    @Column
    private LocalDate dataPagamento;

    @Column
    private StatusPagamento statusPagamento;

    @ManyToOne
    @JoinColumn(name = "FK_CARTAO_ID")
    private CartaoCredito cartaoCredito;

    @CreationTimestamp
    @Column(name = "data_criacao", nullable = false, updatable = false)
    private LocalDateTime dataCriacao;

    @UpdateTimestamp
    @Column(name = "data_atualizacao")
    private LocalDateTime dataAtualizacao;
}


