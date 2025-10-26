package controle.financeiro.backend.repository;

import controle.financeiro.backend.model.Fatura;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FaturaRepository extends JpaRepository<Fatura, String> {
    List<Fatura> findByCartaoCreditoId(String cartaoId);
}
