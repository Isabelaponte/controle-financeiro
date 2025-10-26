package controle.financeiro.backend.mapper;

import controle.financeiro.backend.dto.request.fatura.AtualizaFaturaDTO;
import controle.financeiro.backend.dto.request.fatura.CriaFaturaDTO;
import controle.financeiro.backend.dto.response.FaturaResponseDTO;
import controle.financeiro.backend.model.CartaoCredito;
import controle.financeiro.backend.model.Fatura;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.stream.Collectors;

@Component
public class FaturaMapper {

    public FaturaResponseDTO toResponseDTO(Fatura fatura) {
        if (fatura == null) {
            return null;
        }

        FaturaResponseDTO dto = new FaturaResponseDTO();
        dto.setId(fatura.getId());
        dto.setValorTotal(fatura.getValorTotal());
        dto.setDataVencimento(fatura.getDataVencimento());
        dto.setDataPagamento(fatura.getDataPagamento());
        dto.setStatusPagamento(fatura.getStatusPagamento());
        dto.setDataCriacao(fatura.getDataCriacao());
        dto.setDataAtualizacao(fatura.getDataAtualizacao());

        LocalDate hoje = LocalDate.now();
        dto.setVencida(fatura.getDataVencimento().isBefore(hoje) &&
                fatura.getStatusPagamento() != controle.financeiro.backend.enums.StatusPagamento.PAGO);

        long dias = ChronoUnit.DAYS.between(hoje, fatura.getDataVencimento());
        dto.setDiasParaVencimento((int) dias);

        if (fatura.getCartaoCredito() != null) {
            dto.setCartaoId(fatura.getCartaoCredito().getId());
            dto.setCartaoNome(fatura.getCartaoCredito().getNome());
        }

        return dto;
    }

    public List<FaturaResponseDTO> toResponseDTOList(List<Fatura> faturas) {
        return faturas.stream()
                .map(this::toResponseDTO)
                .collect(Collectors.toList());
    }

    public Fatura toEntity(CriaFaturaDTO dto, CartaoCredito cartao) {
        if (dto == null) {
            return null;
        }

        Fatura fatura = new Fatura();
        fatura.setDataVencimento(dto.getDataVencimento());
        fatura.setValorTotal(dto.getValorTotal());
        fatura.setStatusPagamento(controle.financeiro.backend.enums.StatusPagamento.PENDENTE);
        fatura.setCartaoCredito(cartao);

        return fatura;
    }

    public void updateEntity(AtualizaFaturaDTO dto, Fatura fatura) {
        if (dto == null || fatura == null) {
            return;
        }

        if (dto.getDataVencimento() != null) {
            fatura.setDataVencimento(dto.getDataVencimento());
        }

        if (dto.getValorTotal() != null) {
            fatura.setValorTotal(dto.getValorTotal());
        }

        if (dto.getDataPagamento() != null) {
            fatura.setDataPagamento(dto.getDataPagamento());
        }

        if (dto.getStatusPagamento() != null) {
            fatura.setStatusPagamento(dto.getStatusPagamento());
        }
    }
}
