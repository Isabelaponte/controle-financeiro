package controle.financeiro.backend.dto.response;

public record LoginResponseDTO(
        String id,
        String nomeUsuario,
        String email,
        String token
) {}