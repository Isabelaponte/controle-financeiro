package controle.financeiro.backend.mapper;

import controle.financeiro.backend.dto.request.despesa.cartao.AtualizaDespesaCartaoDTO;
import controle.financeiro.backend.dto.request.despesa.cartao.CriaDespesaCartaoDTO;
import controle.financeiro.backend.dto.response.DespesaCartaoResponseDTO;
import controle.financeiro.backend.model.*;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
public class DespesaCartaoMapper {

    public DespesaCartaoResponseDTO toResponseDTO(DespesaCartao despesa) {
        if (despesa == null) {
            return null;
        }

        DespesaCartaoResponseDTO dto = new DespesaCartaoResponseDTO();
        dto.setId(despesa.getId());
        dto.setValor(despesa.getValor());
        dto.setDescricao(despesa.getDescricao());
        dto.setDataDespesa(despesa.getDataDespesa());
        dto.setLembrete(despesa.getLembrete());
        dto.setPago(despesa.getPago());
        dto.setFixa(despesa.getFixa());
        dto.setQuantidadeParcelas(despesa.getQuantidadeParcelas());
        dto.setJuros(despesa.getJuros());

        double valorTotal = despesa.getValor() + (despesa.getJuros() != null ? despesa.getJuros() : 0.0);
        dto.setValorTotal(valorTotal);
        if (despesa.getQuantidadeParcelas() != null && despesa.getQuantidadeParcelas() > 0) {
            dto.setValorParcela(valorTotal / despesa.getQuantidadeParcelas());
        }

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

        if (despesa.getCartaoCredito() != null) {
            dto.setCartaoId(despesa.getCartaoCredito().getId());
            dto.setCartaoNome(despesa.getCartaoCredito().getNome());
        }

        if (despesa.getFatura() != null) {
            dto.setFaturaId(despesa.getFatura().getId());
        }

        return dto;
    }

    public List<DespesaCartaoResponseDTO> toResponseDTOList(List<DespesaCartao> despesas) {
        return despesas.stream()
                .map(this::toResponseDTO)
                .collect(Collectors.toList());
    }

    public DespesaCartao toEntity(CriaDespesaCartaoDTO dto, Usuario usuario, Categoria categoria,
                                  CartaoCredito cartao, Fatura fatura) {
        DespesaCartao despesa = new DespesaCartao();
        despesa.setValor(dto.getValor());
        despesa.setDescricao(dto.getDescricao());
        despesa.setDataDespesa(dto.getDataDespesa());
        despesa.setLembrete(dto.getLembrete());
        despesa.setPago(false);
        despesa.setFixa(dto.getFixa());
        despesa.setQuantidadeParcelas(dto.getQuantidadeParcelas());
        despesa.setJuros(dto.getJuros());
        despesa.setUsuario(usuario);
        despesa.setCategoria(categoria);
        despesa.setCartaoCredito(cartao);
        despesa.setFatura(fatura);
        return despesa;
    }

    public void updateEntity(AtualizaDespesaCartaoDTO dto, DespesaCartao despesa, Categoria categoria,
                             CartaoCredito cartao, Fatura fatura) {
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
        if (dto.getFixa() != null) {
            despesa.setFixa(dto.getFixa());
        }
        if (dto.getQuantidadeParcelas() != null) {
            despesa.setQuantidadeParcelas(dto.getQuantidadeParcelas());
        }
        if (dto.getJuros() != null) {
            despesa.setJuros(dto.getJuros());
        }
        if (categoria != null) {
            despesa.setCategoria(categoria);
        }
        if (cartao != null) {
            despesa.setCartaoCredito(cartao);
        }
        if (fatura != null) {
            despesa.setFatura(fatura);
        }
    }
}
