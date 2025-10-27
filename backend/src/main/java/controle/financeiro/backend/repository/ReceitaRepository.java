package controle.financeiro.backend.repository;

import controle.financeiro.backend.enums.FormaPagamento;
import controle.financeiro.backend.model.Receita;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface ReceitaRepository extends JpaRepository<Receita, String> {
    List<Receita> findByUsuarioId(String usuarioId);

    List<Receita> findByUsuarioIdAndRecebida(String usuarioId, Boolean recebida);

    List<Receita> findByContaId(String contaId);

    List<Receita> findByCategoriaId(String categoriaId);

    List<Receita> findByUsuarioIdAndFixa(String usuarioId, Boolean fixa);

    @Query("SELECT r FROM Receita r WHERE r.usuario.id = :usuarioId " +
            "AND r.dataRecebimento BETWEEN :dataInicio AND :dataFim")
    List<Receita> findByUsuarioIdAndPeriodo(
            @Param("usuarioId") String usuarioId,
            @Param("dataInicio") LocalDate dataInicio,
            @Param("dataFim") LocalDate dataFim);

    @Query("SELECT r FROM Receita r WHERE r.usuario.id = :usuarioId " +
            "AND r.recebida = false AND r.dataRecebimento < :dataAtual")
    List<Receita> findReceitasAtrasadas(
            @Param("usuarioId") String usuarioId,
            @Param("dataAtual") LocalDate dataAtual);

    @Query("SELECT SUM(r.valor) FROM Receita r WHERE r.usuario.id = :usuarioId " +
            "AND r.recebida = true")
    Double calcularTotalRecebido(String usuarioId);

    @Query("SELECT SUM(r.valor) FROM Receita r WHERE r.usuario.id = :usuarioId " +
            "AND r.recebida = true AND r.dataRecebimento BETWEEN :dataInicio AND :dataFim")
    Double calcularTotalRecebidoPorPeriodo(
            @Param("usuarioId") String usuarioId,
            @Param("dataInicio") LocalDate dataInicio,
            @Param("dataFim") LocalDate dataFim);

    @Query("SELECT SUM(r.valor) FROM Receita r WHERE r.usuario.id = :usuarioId " +
            "AND r.recebida = false")
    Double calcularTotalAReceber(String usuarioId);

    List<Receita> findByUsuarioIdAndFormaPagamento(String usuarioId, FormaPagamento formaPagamento);
}
