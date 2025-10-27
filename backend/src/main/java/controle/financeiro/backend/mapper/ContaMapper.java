package controle.financeiro.backend.mapper;

import controle.financeiro.backend.dto.request.conta.AtualizaContaDTO;
import controle.financeiro.backend.dto.request.conta.CriaContaDTO;
import controle.financeiro.backend.dto.response.ContaResponseDTO;
import controle.financeiro.backend.model.Categoria;
import controle.financeiro.backend.model.Conta;
import controle.financeiro.backend.model.Usuario;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
public class ContaMapper {

    public ContaResponseDTO toResponseDTO(Conta conta) {
        if (conta == null) {
            return null;
        }

        ContaResponseDTO dto = new ContaResponseDTO();
        dto.setId(conta.getId());
        dto.setNome(conta.getNome());
        dto.setIcone(conta.getIcone());
        dto.setTipo(conta.getTipo());
        dto.setSaldo(conta.getSaldo());
        dto.setAtiva(conta.getAtiva());

        if (conta.getUsuario() != null) {
            dto.setUsuarioId(conta.getUsuario().getId());
            dto.setUsuarioNome(conta.getUsuario().getNomeUsuario());
        }

        if (conta.getCategoria() != null) {
            dto.setCategoriaId(conta.getCategoria().getId());
            dto.setCategoriaNome(conta.getCategoria().getNome());
        }

        return dto;
    }

    public List<ContaResponseDTO> toResponseDTOList(List<Conta> contas) {
        return contas.stream()
                .map(this::toResponseDTO)
                .collect(Collectors.toList());
    }

    public Conta toEntity(CriaContaDTO dto, Usuario usuario, Categoria categoria) {
        if (dto == null) {
            return null;
        }

        Conta conta = new Conta();
        conta.setNome(dto.getNome());
        conta.setIcone(dto.getIcone());
        conta.setTipo(dto.getTipo());
        conta.setSaldo(dto.getSaldo());
        conta.setAtiva(true);
        conta.setUsuario(usuario);
        conta.setCategoria(categoria);

        return conta;
    }

    public void updateEntity(AtualizaContaDTO dto, Conta conta, Categoria categoria) {
        if (dto == null || conta == null) {
            return;
        }

        if (dto.getNome() != null) {
            conta.setNome(dto.getNome());
        }

        if (dto.getIcone() != null) {
            conta.setIcone(dto.getIcone());
        }

        if (dto.getTipo() != null) {
            conta.setTipo(dto.getTipo());
        }

        if (dto.getSaldo() != null) {
            conta.setSaldo(dto.getSaldo());
        }

        if (dto.getAtiva() != null) {
            conta.setAtiva(dto.getAtiva());
        }

        if (categoria != null) {
            conta.setCategoria(categoria);
        }
    }
}
