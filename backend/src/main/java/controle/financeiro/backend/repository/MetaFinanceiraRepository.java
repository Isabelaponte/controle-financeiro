package controle.financeiro.backend.repository;

import controle.financeiro.backend.model.MetaFinanceira;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface MetaFinanceiraRepository extends JpaRepository<MetaFinanceira, String> {
    List<MetaFinanceira> findByUsuarioId(String usuarioId);

    List<MetaFinanceira> findByUsuarioIdAndAtiva(String usuarioId, Boolean ativa);

    List<MetaFinanceira> findByUsuarioIdAndConcluida(String usuarioId, Boolean concluida);

    List<MetaFinanceira> findByCategoriaId(String categoriaId);

    @Query("SELECT m FROM MetaFinanceira m WHERE m.usuario.id = :usuarioId " +
            "AND m.concluida = false AND m.ativa = true")
    List<MetaFinanceira> findMetasEmAndamento(String usuarioId);

    @Query("SELECT m FROM MetaFinanceira m WHERE m.usuario.id = :usuarioId " +
            "AND m.dataAlvo < :dataAtual AND m.concluida = false AND m.ativa = true")
    List<MetaFinanceira> findMetasAtrasadas(
            @Param("usuarioId") String usuarioId,
            @Param("dataAtual") LocalDate dataAtual);

    @Query("SELECT m FROM MetaFinanceira m WHERE m.usuario.id = :usuarioId " +
            "AND m.valorAtual >= m.valorDesejado AND m.concluida = false")
    List<MetaFinanceira> findMetasAtingidasNaoConcluidas(String usuarioId);

    @Query("SELECT SUM(m.valorDesejado) FROM MetaFinanceira m " +
            "WHERE m.usuario.id = :usuarioId AND m.ativa = true AND m.concluida = false")
    Double calcularTotalDesejado(String usuarioId);

    @Query("SELECT SUM(m.valorAtual) FROM MetaFinanceira m " +
            "WHERE m.usuario.id = :usuarioId AND m.ativa = true AND m.concluida = false")
    Double calcularTotalAcumulado(String usuarioId);

    @Query("SELECT m FROM MetaFinanceira m WHERE m.usuario.id = :usuarioId " +
            "AND (m.valorAtual / m.valorDesejado) >= 0.8 AND m.concluida = false")
    List<MetaFinanceira> findMetasProximasDaConclusao(String usuarioId);
}
