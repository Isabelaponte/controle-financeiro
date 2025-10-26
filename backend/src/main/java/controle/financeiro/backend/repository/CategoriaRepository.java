package controle.financeiro.backend.repository;

import controle.financeiro.backend.model.Categoria;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CategoriaRepository extends JpaRepository<Categoria, String> {
    List<Categoria> findByUsuarioId(String usuairioId);
    List<Categoria> findByUsuarioIdAndAtivo(String usuarioId, Boolean ativo);
    Optional<Categoria> findByNomeAndUsuarioId(String nome, String usuarioId);
    boolean existsByNomeAndUsuarioId(String nome, String usuarioId);
}
