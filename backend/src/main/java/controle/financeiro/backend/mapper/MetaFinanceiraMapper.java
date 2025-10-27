package controle.financeiro.backend.mapper;

import controle.financeiro.backend.dto.request.meta.AtualizaMetaFinanceiraDTO;
import controle.financeiro.backend.dto.request.meta.CriaMetaFinanceira;
import controle.financeiro.backend.dto.response.MetaFinanceiraResponseDTO;
import controle.financeiro.backend.model.Categoria;
import controle.financeiro.backend.model.MetaFinanceira;
import controle.financeiro.backend.model.Usuario;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.stream.Collectors;

@Component
public class MetaFinanceiraMapper {

    public MetaFinanceiraResponseDTO toResponseDTO(MetaFinanceira meta) {
        if (meta == null) {
            return null;
        }

        MetaFinanceiraResponseDTO dto = new MetaFinanceiraResponseDTO();
        dto.setId(meta.getId());
        dto.setNome(meta.getNome());
        dto.setValorDesejado(meta.getValorDesejado());
        dto.setValorAtual(meta.getValorAtual());
        dto.setDataInicio(meta.getDataInicio());
        dto.setDataAlvo(meta.getDataAlvo());
        dto.setConcluida(meta.getConcluida());

        dto.setValorRestante(meta.getValorDesejado() - meta.getValorAtual());

        double percentual = (meta.getValorAtual() / meta.getValorDesejado()) * 100;
        dto.setPercentualConcluido(Math.min(percentual, 100.0)); // Máximo 100%

        if (meta.getDataAlvo() != null) {
            long dias = ChronoUnit.DAYS.between(LocalDate.now(), meta.getDataAlvo());
            dto.setDiasRestantes(dias);
        }

        if (meta.getCategoria() != null) {
            dto.setCategoriaId(meta.getCategoria().getId());
            dto.setCategoriaNome(meta.getCategoria().getNome());
        }

        if (meta.getUsuario() != null) {
            dto.setUsuarioId(meta.getUsuario().getId());
            dto.setUsuarioNome(meta.getUsuario().getNomeUsuario());
        }

        return dto;
    }

    public List<MetaFinanceiraResponseDTO> toResponseDTOList(List<MetaFinanceira> metas) {
        return metas.stream()
                .map(this::toResponseDTO)
                .collect(Collectors.toList());
    }

    public MetaFinanceira toEntity(CriaMetaFinanceira dto, Usuario usuario, Categoria categoria) {
        if (dto == null) {
            return null;
        }

        MetaFinanceira meta = new MetaFinanceira();
        meta.setNome(dto.getNome());
        meta.setValorDesejado(dto.getValorDesejado());
        meta.setValorAtual(dto.getValorAtual() != null ? dto.getValorAtual() : 0.0);
        meta.setDataInicio(dto.getDataInicio());
        meta.setDataAlvo(dto.getDataAlvo());
        meta.setConcluida(false);
        meta.setUsuario(usuario);
        meta.setCategoria(categoria);

        return meta;
    }

    public void updateEntity(AtualizaMetaFinanceiraDTO dto, MetaFinanceira meta, Categoria categoria) {
        if (dto == null || meta == null) {
            return;
        }

        if (dto.getNome() != null) {
            meta.setNome(dto.getNome());
        }

        if (dto.getValorDesejado() != null) {
            meta.setValorDesejado(dto.getValorDesejado());
        }

        if (dto.getDataInicio() != null) {
            meta.setDataInicio(dto.getDataInicio());
        }

        if (dto.getDataAlvo() != null) {
            meta.setDataAlvo(dto.getDataAlvo());
        }

        if (categoria != null) {
            meta.setCategoria(categoria);
        }
    }
}
