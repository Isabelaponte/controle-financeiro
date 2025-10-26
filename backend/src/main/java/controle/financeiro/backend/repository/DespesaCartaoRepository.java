package controle.financeiro.backend.repository;

import controle.financeiro.backend.model.DespesaCartao;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface DespesaCartaoRepository extends JpaRepository<DespesaCartao, String> {

    List<DespesaCartao> findByUsuarioId(String usuarioId);

    List<DespesaCartao> findByUsuarioIdAndPago(String usuarioId, Boolean pago);

    List<DespesaCartao> findByUsuarioIdAndDataDespesaBetween(String usuarioId, LocalDate inicio, LocalDate fim);

    List<DespesaCartao> findByCartaoCreditoId(String cartaoId);

    List<DespesaCartao> findByFaturaId(String faturaId);

    List<DespesaCartao> findByCategoriaId(String categoriaId);

    List<DespesaCartao> findByFixa(Boolean fixa);
}
