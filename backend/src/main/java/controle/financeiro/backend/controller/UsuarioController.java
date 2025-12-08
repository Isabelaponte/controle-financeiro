package controle.financeiro.backend.controller;

import controle.financeiro.backend.dto.request.usuario.AtualizaUsuarioDTO;
import controle.financeiro.backend.dto.request.usuario.CriaUsuarioDTO;
import controle.financeiro.backend.dto.request.usuario.AlterarSenhaUsuarioDTO;
import controle.financeiro.backend.dto.response.UsuarioResponseDTO;
import controle.financeiro.backend.service.UsuarioService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/usuarios")
public class UsuarioController {

    private final UsuarioService usuarioService;

    public UsuarioController(UsuarioService usuarioService) {
        this.usuarioService = usuarioService;
    }

    @GetMapping()
    public ResponseEntity<List<UsuarioResponseDTO>> listarUsuarios() {
        List<UsuarioResponseDTO> usuarios = usuarioService.listarUsuarios();
        return ResponseEntity.ok(usuarios);
    }

    @GetMapping("/{id}")
    public ResponseEntity<UsuarioResponseDTO> buscarUsuarioPorId(@PathVariable String id) {
        UsuarioResponseDTO usuario = usuarioService.buscarPorId(id);
        return ResponseEntity.ok(usuario);
    }

    @PostMapping()
    public ResponseEntity<UsuarioResponseDTO> criarUsuario(@Valid @RequestBody CriaUsuarioDTO dto) {
        UsuarioResponseDTO usuario = usuarioService.criarUsuario(dto);
        return ResponseEntity.status(HttpStatus.CREATED).body(usuario);
    }

    @PutMapping("/{id}")
    public ResponseEntity<UsuarioResponseDTO> atualizar (@PathVariable String id,
                                                         @Valid @RequestBody AtualizaUsuarioDTO dto) {
        UsuarioResponseDTO usuario = usuarioService.alterarUsuario(id, dto);
        return ResponseEntity.ok(usuario);
    }

    @PutMapping("/{id}/senha")
    public ResponseEntity<Void> alterarSenha(@PathVariable String id,
                                             @Valid @RequestBody AlterarSenhaUsuarioDTO dto) {
        usuarioService.alterarSenha(id, dto);
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletarUsuario(@PathVariable String id) {
        usuarioService.desativarConta(id);
        return ResponseEntity.ok().build();
    }
}
