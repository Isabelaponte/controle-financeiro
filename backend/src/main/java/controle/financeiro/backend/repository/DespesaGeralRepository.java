package controle.financeiro.backend.repository;

import controle.financeiro.backend.enums.StatusPagamento;
import controle.financeiro.backend.model.DespesaGeral;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface DespesaGeralRepository extends JpaRepository<DespesaGeral, String> {

    List<DespesaGeral> findByUsuarioId(String usuarioId);

    List<DespesaGeral> findByUsuarioIdAndPago(String usuarioId, Boolean pago);

    List<DespesaGeral> findByUsuarioIdAndStatusPagamento(String usuarioId, StatusPagamento status);

    List<DespesaGeral> findByUsuarioIdAndDataDespesaBetween(String usuarioId, LocalDate inicio, LocalDate fim);

    List<DespesaGeral> findByCategoriaId(String categoriaId);
}
