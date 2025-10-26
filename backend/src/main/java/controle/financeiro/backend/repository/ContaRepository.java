package controle.financeiro.backend.repository;

import controle.financeiro.backend.model.Conta;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ContaRepository extends JpaRepository<Conta, String> {
    List<Conta> findByUsuarioId(String usuarioId);
    boolean existsByNomeAndUsuarioId(String nome, String usuarioId);
}
