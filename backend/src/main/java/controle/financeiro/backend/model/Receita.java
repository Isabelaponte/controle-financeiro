package controle.financeiro.backend.model;

import controle.financeiro.backend.enums.FormaPagamento;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.UuidGenerator;

import java.time.LocalDate;

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
    private LocalDate dataRecebimento;

    @Column
    private Double valor;

    @Column(name = "forma_pagamento")
    private FormaPagamento formaPagamento;

    @Column
    private String anexo;

    @Column
    private String descricao;

    @Column
    private Boolean fixa;

    @Column
    private Boolean repete;

    @Column
    private Integer periodo;

    @Column
    private Boolean recebida;

    @ManyToOne
    @JoinColumn(name = "FK_CONTA_ID")
    private Conta conta;

    @ManyToOne
    @JoinColumn(name = "FK_CATEGORIA_ID")
    private Categoria categoria;

    @ManyToOne
    @JoinColumn(name = "FK_USUARIO_ID")
    private Usuario usuario;
}
