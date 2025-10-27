package controle.financeiro.backend.repository;

import controle.financeiro.backend.model.CartaoCredito;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CartaoCreditoRepository extends JpaRepository<CartaoCredito, String> {

    List<CartaoCredito> findByUsuarioId(String usuarioId);

    List<CartaoCredito> findByUsuarioIdAndAtivo(String usuarioId, Boolean ativo);

    Optional<CartaoCredito> findByNomeAndUsuarioId(String nome, String usuarioId);

    boolean existsByNomeAndUsuarioId(String nome, String usuarioId);

    @Query("SELECT SUM(c.limiteTotal) FROM CartaoCredito c WHERE c.usuario.id = :usuarioId AND c.ativo = true")
    Double calcularLimiteTotalDisponivel(String usuarioId);
}
