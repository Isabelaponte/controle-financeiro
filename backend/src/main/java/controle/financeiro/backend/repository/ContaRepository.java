package controle.financeiro.backend.repository;

import controle.financeiro.backend.model.Conta;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ContaRepository extends JpaRepository<Conta, String> {

    List<Conta> findByUsuarioId(String usuarioId);

    List<Conta> findByUsuarioIdAndAtiva(String usuarioId, Boolean ativa);

    Optional<Conta> findByNomeAndUsuarioId(String nome, String usuarioId);

    boolean existsByNomeAndUsuarioId(String nome, String usuarioId);

    List<Conta> findByTipo(String tipo);

    @Query("SELECT SUM(c.saldo) FROM Conta c WHERE c.usuario.id = :usuarioId AND c.ativa = true")
    Double calcularSaldoTotal(String usuarioId);
}
