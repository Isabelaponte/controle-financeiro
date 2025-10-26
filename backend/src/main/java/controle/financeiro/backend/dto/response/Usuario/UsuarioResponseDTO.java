package controle.financeiro.backend.dto.response.Usuario;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UsuarioResponseDTO {
    private String id;
    private String email;
    private String nomeUsuario;
}
