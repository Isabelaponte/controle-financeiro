package controle.financeiro.backend.service;

import controle.financeiro.backend.dto.request.usuario.AtualizaUsuarioDTO;
import controle.financeiro.backend.dto.request.usuario.CriaUsuarioDTO;
import controle.financeiro.backend.dto.request.usuario.AlterarSenhaUsuarioDTO;
import controle.financeiro.backend.dto.response.UsuarioResponseDTO;
import controle.financeiro.backend.exception.RecursoNaoEcontradoException;
import controle.financeiro.backend.exception.usuario.EmailJaExisteException;
import controle.financeiro.backend.exception.usuario.SenhaInvalidaException;
import controle.financeiro.backend.mapper.UsuarioMapper;
import controle.financeiro.backend.model.Usuario;
import controle.financeiro.backend.repository.UsuarioRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UsuarioService {
    private final UsuarioRepository usuarioRepository;
    private final UsuarioMapper usuarioMapper;

    public UsuarioService(UsuarioRepository usuarioRepository, UsuarioMapper usuarioMapper) {
        this.usuarioRepository = usuarioRepository;
        this.usuarioMapper = usuarioMapper;
    }

    public List<UsuarioResponseDTO> listarUsuarios() {
        List<Usuario> usuarios = usuarioRepository.findAll();
        return usuarioMapper.toResponseDTOList(usuarios);
    }

    public UsuarioResponseDTO buscarPorId(String id) {
        Usuario usuario = usuarioRepository.findById(id)
                .orElseThrow(() -> new RecursoNaoEcontradoException("Usuario com ID " + id + " não encontrado"));

        return usuarioMapper.toResponseDTO(usuario);
    }

    public UsuarioResponseDTO criarUsuario(CriaUsuarioDTO usuarioDTO) {
        if (usuarioRepository.existsByEmail(usuarioDTO.getEmail())) {
            throw new EmailJaExisteException("Email em uso");
        }

        Usuario usuario = usuarioMapper.toEntity(usuarioDTO);

        //criptografar senha

        Usuario salvarUsuario = usuarioRepository.save(usuario);
        return usuarioMapper.toResponseDTO(salvarUsuario);
    }

    public UsuarioResponseDTO alterarUsuario(String id, AtualizaUsuarioDTO usuarioDTO) {
        Usuario usuario = usuarioRepository.findById(id)
                .orElseThrow(() -> new RecursoNaoEcontradoException("Usuario com ID " + id + " não encontrado"));

        if (usuarioDTO.getEmail() != null && !usuario.getEmail().equals(usuarioDTO.getEmail())) {
            if (usuarioRepository.existsByEmail(usuarioDTO.getEmail())) {
                throw new EmailJaExisteException("Email em uso");
            }
        }

        usuarioMapper.updateEntity(usuarioDTO, usuario);

        Usuario usuarioAtualizado = usuarioRepository.save(usuario);

        return usuarioMapper.toResponseDTO(usuarioAtualizado);
    }

    public void alterarSenha(String id, AlterarSenhaUsuarioDTO dto) {
        Usuario usuario = usuarioRepository.findById(id)
                .orElseThrow(() -> new RecursoNaoEcontradoException("Usuario com ID " + id + " não encontrado"));

        if (!dto.getSenhaAtual().equals(usuario.getSenha())) {
            throw new SenhaInvalidaException("Senha atual incorreta");
        }

        if (!dto.getNovaSenha().equals(dto.getConfirmarNovaSenha())) {
            throw new IllegalArgumentException("As senhas não coincidem");
        }

        usuario.setSenha(dto.getNovaSenha());

        usuarioRepository.save(usuario);
    }

    public void deletarUsuario(String id) {
        if (!usuarioRepository.existsById(id)) {
            throw new RecursoNaoEcontradoException("Usuario com ID " + id + " não encontrado");
        }
        usuarioRepository.deleteById(id);
    }
}
