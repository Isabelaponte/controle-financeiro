package controle.financeiro.backend.mapper;

import controle.financeiro.backend.dto.request.usuario.AtualizaUsuarioDTO;
import controle.financeiro.backend.dto.request.usuario.CriaUsuarioDTO;
import controle.financeiro.backend.dto.response.usuario.UsuarioResponseDTO;
import controle.financeiro.backend.model.Usuario;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
public class UsuarioMapper {

    public UsuarioResponseDTO toResponseDTO(Usuario usuario) {
        if (usuario == null) {
            return null;
        }

        UsuarioResponseDTO usuarioResponseDTO = new UsuarioResponseDTO();

        usuarioResponseDTO.setId(usuario.getId());
        usuarioResponseDTO.setEmail(usuario.getEmail());
        usuarioResponseDTO.setNomeUsuario(usuario.getNomeUsuario());
        return usuarioResponseDTO;
    }

    public List<UsuarioResponseDTO> toResponseDTOList(List<Usuario> usuarios) {
        return usuarios.stream()
                .map(this::toResponseDTO)
                .collect(Collectors.toList());
    }

    public Usuario toEntity(CriaUsuarioDTO dto) {
        if (dto == null) {
            return null;
        }

        Usuario usuario = new Usuario();
        usuario.setEmail(dto.getEmail());
        usuario.setSenha(dto.getSenha());
        usuario.setNomeUsuario(dto.getNomeUsuario());
        return usuario;
    }

    public void updateEntity(AtualizaUsuarioDTO dto, Usuario usuario) {
        if (dto == null || usuario == null) {
            return;
        }

        if (dto.getEmail() != null) {
            usuario.setEmail(dto.getEmail());
        }

        if (dto.getNomeUsuario() != null) {
            usuario.setNomeUsuario(dto.getNomeUsuario());
        }
    }
}
