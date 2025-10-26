package controle.financeiro.backend.dto.request.usuario;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AtualizaUsuarioDTO {
    @Email(message = "Email inválido")
    private String email;

    @Size(min = 3, max = 50, message = "Nome deve ter entre 3 e 50 caracteres")
    private String nomeUsuario;
}