package controle.financeiro.backend.mapper;

import controle.financeiro.backend.dto.request.receita.AtualizaReceitaDTO;
import controle.financeiro.backend.dto.request.receita.CriaReceitaDTO;
import controle.financeiro.backend.dto.response.ReceitaResponseDTO;
import controle.financeiro.backend.model.Categoria;
import controle.financeiro.backend.model.Conta;
import controle.financeiro.backend.model.Receita;
import controle.financeiro.backend.model.Usuario;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
public class ReceitaMapper {
    public ReceitaResponseDTO toResponseDTO(Receita receita) {
        if (receita == null) {
            return null;
        }

        ReceitaResponseDTO dto = new ReceitaResponseDTO();
        dto.setId(receita.getId());
        dto.setDescricao(receita.getDescricao());
        dto.setValor(receita.getValor());
        dto.setDataRecebimento(receita.getDataRecebimento());
        dto.setFormaPagamento(receita.getFormaPagamento());
        dto.setAnexo(receita.getAnexo());
        dto.setFixa(receita.getFixa());
        dto.setRepete(receita.getRepete());
        dto.setPeriodo(receita.getPeriodo());
        dto.setRecebida(receita.getRecebida());

        if (receita.getConta() != null) {
            dto.setContaId(receita.getConta().getId());
            dto.setContaNome(receita.getConta().getNome());
        }

        if (receita.getCategoria() != null) {
            dto.setCategoriaId(receita.getCategoria().getId());
            dto.setCategoriaNome(receita.getCategoria().getNome());
        }

        if (receita.getUsuario() != null) {
            dto.setUsuarioId(receita.getUsuario().getId());
            dto.setUsuarioNome(receita.getUsuario().getNomeUsuario());
        }

        return dto;
    }

    public List<ReceitaResponseDTO> toResponseDTOList(List<Receita> receitas) {
        return receitas.stream()
                .map(this::toResponseDTO)
                .collect(Collectors.toList());
    }

    public Receita toEntity(CriaReceitaDTO dto, Conta conta, Categoria categoria, Usuario usuario) {
        if (dto == null) {
            return null;
        }

        Receita receita = new Receita();
        receita.setDescricao(dto.getDescricao());
        receita.setValor(dto.getValor());
        receita.setDataRecebimento(dto.getDataRecebimento());
        receita.setFormaPagamento(dto.getFormaPagamento());
        receita.setAnexo(dto.getAnexo());
        receita.setFixa(dto.getFixa());
        receita.setRepete(dto.getRepete());
        receita.setPeriodo(dto.getPeriodo());
        receita.setRecebida(false);
        receita.setConta(conta);
        receita.setCategoria(categoria);
        receita.setUsuario(usuario);

        return receita;
    }

    public void updateEntity(AtualizaReceitaDTO dto, Receita receita, Conta conta, Categoria categoria) {
        if (dto == null || receita == null) {
            return;
        }

        if (dto.getDescricao() != null) {
            receita.setDescricao(dto.getDescricao());
        }

        if (dto.getValor() != null) {
            receita.setValor(dto.getValor());
        }

        if (dto.getDataRecebimento() != null) {
            receita.setDataRecebimento(dto.getDataRecebimento());
        }

        if (dto.getFormaPagamento() != null) {
            receita.setFormaPagamento(dto.getFormaPagamento());
        }

        if (dto.getAnexo() != null) {
            receita.setAnexo(dto.getAnexo());
        }

        if (dto.getFixa() != null) {
            receita.setFixa(dto.getFixa());
        }

        if (dto.getRepete() != null) {
            receita.setRepete(dto.getRepete());
        }

        if (dto.getPeriodo() != null) {
            receita.setPeriodo(dto.getPeriodo());
        }

        if (dto.getRecebida() != null) {
            receita.setRecebida(dto.getRecebida());
        }

        if (conta != null) {
            receita.setConta(conta);
        }

        if (categoria != null) {
            receita.setCategoria(categoria);
        }
    }
}
