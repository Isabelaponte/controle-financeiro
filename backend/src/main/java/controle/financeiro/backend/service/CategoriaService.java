package controle.financeiro.backend.service;

import controle.financeiro.backend.dto.request.categoria.AtualizaCategoriaDTO;
import controle.financeiro.backend.dto.request.categoria.CriaCategoriaDTO;
import controle.financeiro.backend.dto.response.CategoriaResponseDTO;
import controle.financeiro.backend.exception.RecursoNaoEcontradoException;
import controle.financeiro.backend.exception.categoria.CategoriaNomeJaExisteException;
import controle.financeiro.backend.mapper.CategoriaMapper;
import controle.financeiro.backend.model.Categoria;
import controle.financeiro.backend.model.Usuario;
import controle.financeiro.backend.repository.CategoriaRepository;
import controle.financeiro.backend.repository.UsuarioRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class CategoriaService {

    private final CategoriaRepository categoriaRepository;
    private final UsuarioRepository usuarioRepository;
    private final CategoriaMapper categoriaMapper;

    public CategoriaResponseDTO criar(CriaCategoriaDTO dto) {
        Usuario usuario = usuarioRepository.findById(dto.getUsuarioId())
                .orElseThrow(() -> new RecursoNaoEcontradoException("Usuário não encontrado"));

        if (categoriaRepository.existsByNomeAndUsuarioId(dto.getNome(), dto.getUsuarioId())) {
            throw new CategoriaNomeJaExisteException("Já existe uma categoria com este nome");
        }

        Categoria categoria = categoriaMapper.toEntity(dto, usuario);
        Categoria salvar = categoriaRepository.save(categoria);

        return categoriaMapper.toResponseDTO(salvar);
    }

    public CategoriaResponseDTO buscarPorId(String id) {
        Categoria categoria = categoriaRepository.findById(id)
                .orElseThrow(() -> new RecursoNaoEcontradoException("Categoria não encontrada"));

        return categoriaMapper.toResponseDTO(categoria);
    }

    public List<CategoriaResponseDTO> listarPorUsuario(String usuarioId) {
        if (!usuarioRepository.existsById(usuarioId)) {
            throw new RecursoNaoEcontradoException("Usuário não encontrado");
        }

        List<Categoria> categorias = categoriaRepository.findByUsuarioId(usuarioId);
        return categoriaMapper.toResponseDTOList(categorias);
    }

    public List<CategoriaResponseDTO> listarAtivasPorUsuario(String usuarioId) {
        if (!usuarioRepository.existsById(usuarioId)) {
            throw new RecursoNaoEcontradoException("Usuário não encontrado");
        }

        List<Categoria> categorias = categoriaRepository.findByUsuarioIdAndAtivo(usuarioId, true);
        return categoriaMapper.toResponseDTOList(categorias);
    }

    public CategoriaResponseDTO atualizar(String id, AtualizaCategoriaDTO dto) {
        Categoria categoria = categoriaRepository.findById(id)
                .orElseThrow(() -> new RecursoNaoEcontradoException("Categoria não encontrada"));

        if (dto.getNome() != null && !categoria.getNome().equals(dto.getNome())) {
            if (categoriaRepository.existsByNomeAndUsuarioId(dto.getNome(), categoria.getUsuario().getId())) {
                throw new CategoriaNomeJaExisteException("Já existe uma categoria com este nome");
            }
        }

        categoriaMapper.updateEntity(dto, categoria);

        Categoria atualizada = categoriaRepository.save(categoria);
        return categoriaMapper.toResponseDTO(atualizada);
    }

    public CategoriaResponseDTO desativar(String id) {
        Categoria categoria = categoriaRepository.findById(id)
                .orElseThrow(() -> new RecursoNaoEcontradoException("Categoria não encontrada"));

        categoria.setAtivo(false);
        Categoria desativada = categoriaRepository.save(categoria);

        return categoriaMapper.toResponseDTO(desativada);
    }

    public CategoriaResponseDTO ativar(String id) {
        Categoria categoria = categoriaRepository.findById(id)
                .orElseThrow(() -> new RecursoNaoEcontradoException("Categoria não encontrada"));

        categoria.setAtivo(true);
        Categoria desativada = categoriaRepository.save(categoria);

        return categoriaMapper.toResponseDTO(desativada);
    }
}
