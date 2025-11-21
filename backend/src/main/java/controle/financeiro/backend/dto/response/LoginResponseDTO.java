package controle.financeiro.backend.dto.response;

public record LoginResponseDTO(
        String id,
        String name,
        String email,
        String token
) {}