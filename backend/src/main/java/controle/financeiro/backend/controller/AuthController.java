package controle.financeiro.backend.controller;

import controle.financeiro.backend.dto.request.LoginRequestDTO;
import controle.financeiro.backend.dto.request.RegistroRequestDTO;
import controle.financeiro.backend.dto.response.LoginResponseDTO;
import controle.financeiro.backend.exception.usuario.CredenciaisInvalidasException;
import controle.financeiro.backend.exception.usuario.EmailJaExisteException;
import controle.financeiro.backend.model.Usuario;
import controle.financeiro.backend.repository.UsuarioRepository;
import controle.financeiro.backend.security.TokenService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final UsuarioRepository usuarioRepository;
    private final PasswordEncoder passwordEncoder;
    private final TokenService tokenService;

    @PostMapping("/login")
    public ResponseEntity<LoginResponseDTO> login(@Valid @RequestBody LoginRequestDTO body) {
        Optional<Usuario> usuarioOpt = this.usuarioRepository.findByEmail(body.email());

        if (usuarioOpt.isEmpty() || !passwordEncoder.matches(body.senha(), usuarioOpt.get().getSenha())) {
            throw new CredenciaisInvalidasException("Email ou senha incorretos");
        }

        Usuario usuario = usuarioOpt.get();
        String token = this.tokenService.generateToken(usuario);

        return ResponseEntity.ok(new LoginResponseDTO(usuario.getId() ,usuario.getNomeUsuario(), usuario.getEmail(), token));
    }

    @PostMapping("/register")
    public ResponseEntity<LoginResponseDTO> register(@Valid @RequestBody RegistroRequestDTO body) {

        if (this.usuarioRepository.findByEmail(body.email()).isPresent()) {
            throw new EmailJaExisteException("Email já cadastrado");
        }

        if (body.nomeUsuario() == null || body.nomeUsuario().trim().isEmpty()) {
            throw new IllegalArgumentException("Nome de usuário não pode ser vazio");
        }

        Usuario novoUsuario = new Usuario();
        novoUsuario.setNomeUsuario(body.nomeUsuario().trim());
        novoUsuario.setEmail(body.email().toLowerCase().trim());
        novoUsuario.setSenha(passwordEncoder.encode(body.senha()));

        this.usuarioRepository.save(novoUsuario);

        String token = this.tokenService.generateToken(novoUsuario);

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(new LoginResponseDTO(novoUsuario.getId(), novoUsuario.getNomeUsuario(), novoUsuario.getEmail(), token));
    }
}