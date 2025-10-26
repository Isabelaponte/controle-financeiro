package controle.financeiro.backend.mapper;

import controle.financeiro.backend.dto.request.despesa.geral.AtualizaDespesaGeralDTO;
import controle.financeiro.backend.dto.request.despesa.geral.CriaDespesaGeralDTO;
import controle.financeiro.backend.dto.response.DespesaGeralResponseDTO;
import controle.financeiro.backend.model.Categoria;
import controle.financeiro.backend.model.Conta;
import controle.financeiro.backend.model.DespesaGeral;
import controle.financeiro.backend.model.Usuario;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
public class DespesaGeralMapper {

    public DespesaGeralResponseDTO toResponseDTO(DespesaGeral despesa) {
        if (despesa == null) {
            return null;
        }

        DespesaGeralResponseDTO dto = new DespesaGeralResponseDTO();
        dto.setId(despesa.getId());
        dto.setValor(despesa.getValor());
        dto.setDescricao(despesa.getDescricao());
        dto.setDataDespesa(despesa.getDataDespesa());
        dto.setLembrete(despesa.getLembrete());
        dto.setPago(despesa.getPago());
        dto.setPeriodo(despesa.getPeriodo());
        dto.setRepetir(despesa.getRepetir());
        dto.setStatusPagamento(despesa.getStatusPagamento());
        dto.setDataCriacao(despesa.getDataCriacao());
        dto.setDataAtualizacao(despesa.getDataAtualizacao());

        if (despesa.getUsuario() != null) {
            dto.setUsuarioId(despesa.getUsuario().getId());
            dto.setUsuarioNome(despesa.getUsuario().getNomeUsuario());
        }

        if (despesa.getCategoria() != null) {
            dto.setCategoriaId(despesa.getCategoria().getId());
            dto.setCategoriaNome(despesa.getCategoria().getNome());
        }

        if (despesa.getConta() != null) {
            dto.setContaId(despesa.getConta().getId());
            dto.setContaNome(despesa.getConta().getTitulo());
        }

        return dto;
    }

    public List<DespesaGeralResponseDTO> toResponseDTOList(List<DespesaGeral> despesas) {
        return despesas.stream()
                .map(this::toResponseDTO)
                .collect(Collectors.toList());
    }

    public DespesaGeral toEntity(CriaDespesaGeralDTO dto, Usuario usuario, Categoria categoria, Conta conta) {
        DespesaGeral despesa = new DespesaGeral();
        despesa.setValor(dto.getValor());
        despesa.setDescricao(dto.getDescricao());
        despesa.setDataDespesa(dto.getDataDespesa());
        despesa.setLembrete(dto.getLembrete());
        despesa.setPago(false);
        despesa.setPeriodo(dto.getPeriodo());
        despesa.setRepetir(dto.getRepetir());
        despesa.setStatusPagamento(dto.getStatusPagamento());
        despesa.setUsuario(usuario);
        despesa.setCategoria(categoria);
        despesa.setConta(conta);
        return despesa;
    }

    public void updateEntity(AtualizaDespesaGeralDTO dto, DespesaGeral despesa, Categoria categoria, Conta conta) {
        if (dto.getValor() != null) {
            despesa.setValor(dto.getValor());
        }
        if (dto.getDescricao() != null) {
            despesa.setDescricao(dto.getDescricao());
        }
        if (dto.getDataDespesa() != null) {
            despesa.setDataDespesa(dto.getDataDespesa());
        }
        if (dto.getLembrete() != null) {
            despesa.setLembrete(dto.getLembrete());
        }
        if (dto.getPago() != null) {
            despesa.setPago(dto.getPago());
        }
        if (dto.getPeriodo() != null) {
            despesa.setPeriodo(dto.getPeriodo());
        }
        if (dto.getRepetir() != null) {
            despesa.setRepetir(dto.getRepetir());
        }
        if (dto.getStatusPagamento() != null) {
            despesa.setStatusPagamento(dto.getStatusPagamento());
        }
        if (categoria != null) {
            despesa.setCategoria(categoria);
        }
        if (conta != null) {
            despesa.setConta(conta);
        }
    }
}
