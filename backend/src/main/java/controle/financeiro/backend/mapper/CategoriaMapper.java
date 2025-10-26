package controle.financeiro.backend.mapper;

import controle.financeiro.backend.dto.request.categoria.AtualizaCategoriaDTO;
import controle.financeiro.backend.dto.request.categoria.CriaCategoriaDTO;
import controle.financeiro.backend.dto.response.categoria.CategoriaResponseDTO;
import controle.financeiro.backend.model.Categoria;
import controle.financeiro.backend.model.Usuario;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
public class CategoriaMapper {
    public CategoriaResponseDTO toResponseDTO(Categoria categoria) {
        if (categoria == null) {
            return null;
        }

        CategoriaResponseDTO dto = new CategoriaResponseDTO();
        dto.setId(categoria.getId());
        dto.setNome(categoria.getNome());
        dto.setCor(categoria.getCor());
        dto.setIcone(categoria.getIcone());
        dto.setDescricao(categoria.getDescricao());
        dto.setAtivo(categoria.getAtivo());

        if (categoria.getUsuario() != null) {
            dto.setUsuarioId(categoria.getUsuario().getId());
            dto.setUsuarioNome(categoria.getUsuario().getNomeUsuario());
        }

        return dto;
    }

    public List<CategoriaResponseDTO> toResponseDTOList(List<Categoria> categorias) {
        return categorias.stream()
                .map(this::toResponseDTO)
                .collect(Collectors.toList());
    }

    public Categoria toEntity(CriaCategoriaDTO dto, Usuario usuario) {
        if (dto == null) {
            return null;
        }

        Categoria categoria = new Categoria();
        categoria.setNome(dto.getNome());
        categoria.setCor(dto.getCor());
        categoria.setIcone(dto.getIcone());
        categoria.setDescricao(dto.getDescricao());
        categoria.setAtivo(true);
        categoria.setUsuario(usuario);

        return categoria;
    }

    public void updateEntity(AtualizaCategoriaDTO dto, Categoria categoria) {
        if (dto == null || categoria == null) {
            return;
        }

        if (dto.getNome() != null) {
            categoria.setNome(dto.getNome());
        }

        if (dto.getCor() != null) {
            categoria.setCor(dto.getCor());
        }

        if (dto.getIcone() != null) {
            categoria.setIcone(dto.getIcone());
        }

        if (dto.getDescricao() != null) {
            categoria.setDescricao(dto.getDescricao());
        }

        if (dto.getAtivo() != null) {
            categoria.setAtivo(dto.getAtivo());
        }
    }
}
