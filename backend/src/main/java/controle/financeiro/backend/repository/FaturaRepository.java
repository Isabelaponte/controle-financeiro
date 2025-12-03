package controle.financeiro.backend.repository;

import controle.financeiro.backend.enums.StatusPagamento;
import controle.financeiro.backend.model.Fatura;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface FaturaRepository extends JpaRepository<Fatura, String> {
    List<Fatura> findByCartaoCreditoId(String cartaoId);

    List<Fatura> findByCartaoCreditoIdAndStatusPagamento(String cartaoId, StatusPagamento status);

    List<Fatura> findByDataVencimentoBetween(LocalDate inicio, LocalDate fim);

    List<Fatura> findByCartaoCreditoIdAndDataVencimentoBetween(String cartaoId, LocalDate inicio, LocalDate fim);

    Optional<Fatura> findFirstByCartaoCreditoIdOrderByDataVencimentoDesc(String cartaoId);

    @Query("SELECT f FROM Fatura f WHERE f.cartaoCredito.usuario.id = :usuarioId " +
            "AND f.dataVencimento < :hoje AND f.statusPagamento <> :status")
    List<Fatura> findVencidasPorUsuario(
            @Param("usuarioId") String usuarioId,
            @Param("hoje") LocalDate hoje,
            @Param("status") StatusPagamento status
    );

    Optional<Fatura> findByCartaoCreditoIdAndDataVencimento(String cartaoId, LocalDate dataVencimento);
}
