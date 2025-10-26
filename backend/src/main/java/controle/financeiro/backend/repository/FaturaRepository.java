package controle.financeiro.backend.repository;

import controle.financeiro.backend.enums.StatusPagamento;
import controle.financeiro.backend.model.Fatura;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface FaturaRepository extends JpaRepository<Fatura, String> {
    List<Fatura> findByCartaoCreditoId(String cartaoId);

    List<Fatura> findByCartaoCreditoIdAndStatusPagamento(String cartaoId, StatusPagamento status);

    List<Fatura> findByDataVencimentoBetween(LocalDate inicio, LocalDate fim);

    List<Fatura> findByCartaoCreditoIdAndDataVencimentoBetween(String cartaoId, LocalDate inicio, LocalDate fim);

    @Query("SELECT f FROM fatura f WHERE f.dataVencimento < :hoje AND f.statusPagamento <> 'PAGO'")
    List<Fatura> findVencidas(LocalDate hoje);

    @Query("SELECT f FROM fatura f WHERE f.cartaoCredito.usuario.id = :usuarioId")
    List<Fatura> findByUsuarioId(String usuarioId);
}
