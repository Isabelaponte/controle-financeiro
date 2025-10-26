package controle.financeiro.backend.repository;

import controle.financeiro.backend.model.CartaoCredito;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CartaoCreditoRepository extends JpaRepository<CartaoCredito, String> {
    List<CartaoCredito> findByUsuarioId(String usuarioId);
}
