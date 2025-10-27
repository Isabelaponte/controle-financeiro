package controle.financeiro.backend.service;

import controle.financeiro.backend.dto.request.meta.AtualizaMetaFinanceiraDTO;
import controle.financeiro.backend.dto.request.meta.CriaMetaFinanceira;
import controle.financeiro.backend.dto.response.MetaFinanceiraResponseDTO;
import controle.financeiro.backend.exception.RecursoNaoEcontradoException;
import controle.financeiro.backend.mapper.MetaFinanceiraMapper;
import controle.financeiro.backend.model.Categoria;
import controle.financeiro.backend.model.MetaFinanceira;
import controle.financeiro.backend.model.Usuario;
import controle.financeiro.backend.repository.CategoriaRepository;
import controle.financeiro.backend.repository.MetaFinanceiraRepository;
import controle.financeiro.backend.repository.UsuarioRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Transactional
public class MetaFinanceiraService {

    private final MetaFinanceiraRepository metaRepository;
    private final UsuarioRepository usuarioRepository;
    private final CategoriaRepository categoriaRepository;
    private final MetaFinanceiraMapper metaMapper;

    public MetaFinanceiraResponseDTO criar(CriaMetaFinanceira dto) {
        Usuario usuario = usuarioRepository.findById(dto.getUsuarioId())
                .orElseThrow(() -> new RecursoNaoEcontradoException("Usuário não encontrado"));

        Categoria categoria = null;
        if (dto.getCategoriaId() != null) {
            categoria = categoriaRepository.findById(dto.getCategoriaId())
                    .orElseThrow(() -> new RecursoNaoEcontradoException("Categoria não encontrada"));
        }

        if (dto.getDataAlvo() != null && dto.getDataAlvo().isBefore(dto.getDataInicio())) {
            throw new IllegalArgumentException("Data alvo não pode ser anterior à data de início");
        }

        if (dto.getValorAtual() != null && dto.getValorAtual() > dto.getValorDesejado()) {
            throw new IllegalArgumentException("Valor atual não pode ser maior que o valor desejado");
        }

        MetaFinanceira meta = metaMapper.toEntity(dto, usuario, categoria);
        MetaFinanceira salva = metaRepository.save(meta);

        return metaMapper.toResponseDTO(salva);
    }

    public MetaFinanceiraResponseDTO buscarPorId(String id) {
        MetaFinanceira meta = metaRepository.findById(id)
                .orElseThrow(() -> new RecursoNaoEcontradoException("Meta financeira não encontrada"));

        return metaMapper.toResponseDTO(meta);
    }

    public List<MetaFinanceiraResponseDTO> listarPorUsuario(String usuarioId) {
        if (!usuarioRepository.existsById(usuarioId)) {
            throw new RecursoNaoEcontradoException("Usuário não encontrado");
        }

        List<MetaFinanceira> metas = metaRepository.findByUsuarioId(usuarioId);
        return metaMapper.toResponseDTOList(metas);
    }

    public List<MetaFinanceiraResponseDTO> listarMetasEmAndamento(String usuarioId) {
        if (!usuarioRepository.existsById(usuarioId)) {
            throw new RecursoNaoEcontradoException("Usuário não encontrado");
        }

        List<MetaFinanceira> metas = metaRepository.findMetasEmAndamento(usuarioId);
        return metaMapper.toResponseDTOList(metas);
    }

    public List<MetaFinanceiraResponseDTO> listarMetasConcluidas(String usuarioId) {
        if (!usuarioRepository.existsById(usuarioId)) {
            throw new RecursoNaoEcontradoException("Usuário não encontrado");
        }

        List<MetaFinanceira> metas = metaRepository.findByUsuarioIdAndConcluida(usuarioId, true);
        return metaMapper.toResponseDTOList(metas);
    }

    public Map<String, Object> calcularResumo(String usuarioId) {
        if (!usuarioRepository.existsById(usuarioId)) {
            throw new RecursoNaoEcontradoException("Usuário não encontrado");
        }

        Double totalDesejado = metaRepository.calcularTotalDesejado(usuarioId);
        Double totalAcumulado = metaRepository.calcularTotalAcumulado(usuarioId);

        Map<String, Object> resumo = new HashMap<>();
        resumo.put("totalDesejado", totalDesejado != null ? totalDesejado : 0.0);
        resumo.put("totalAcumulado", totalAcumulado != null ? totalAcumulado : 0.0);
        resumo.put("totalRestante", (totalDesejado != null ? totalDesejado : 0.0) -
                (totalAcumulado != null ? totalAcumulado : 0.0));

        double percentualGeral = totalDesejado != null && totalDesejado > 0
                ? (totalAcumulado != null ? totalAcumulado : 0.0) / totalDesejado * 100
                : 0.0;
        resumo.put("percentualGeral", Math.min(percentualGeral, 100.0));

        return resumo;
    }

    public MetaFinanceiraResponseDTO atualizar(String id, AtualizaMetaFinanceiraDTO dto) {
        MetaFinanceira meta = metaRepository.findById(id)
                .orElseThrow(() -> new RecursoNaoEcontradoException("Meta financeira não encontrada"));

        Categoria categoria = null;
        if (dto.getCategoriaId() != null) {
            categoria = categoriaRepository.findById(dto.getCategoriaId())
                    .orElseThrow(() -> new RecursoNaoEcontradoException("Categoria não encontrada"));
        }

        LocalDate novaDataInicio = dto.getDataInicio() != null ? dto.getDataInicio() : meta.getDataInicio();
        LocalDate novaDataAlvo = dto.getDataAlvo() != null ? dto.getDataAlvo() : meta.getDataAlvo();

        if (novaDataAlvo != null && novaDataAlvo.isBefore(novaDataInicio)) {
            throw new IllegalArgumentException("Data alvo não pode ser anterior à data de início");
        }

        metaMapper.updateEntity(dto, meta, categoria);

        MetaFinanceira atualizada = metaRepository.save(meta);
        return metaMapper.toResponseDTO(atualizada);
    }

    public MetaFinanceiraResponseDTO adicionarValor(String id, Double valor) {
        if (valor <= 0) {
            throw new IllegalArgumentException("Valor deve ser positivo");
        }

        MetaFinanceira meta = metaRepository.findById(id)
                .orElseThrow(() -> new RecursoNaoEcontradoException("Meta financeira não encontrada"));

        if (meta.getConcluida()) {
            throw new IllegalArgumentException("Meta já foi concluída");
        }

        meta.setValorAtual(meta.getValorAtual() + valor);

        if (meta.getValorAtual() >= meta.getValorDesejado()) {
            meta.setConcluida(true);
        }

        MetaFinanceira atualizada = metaRepository.save(meta);
        return metaMapper.toResponseDTO(atualizada);
    }

    public MetaFinanceiraResponseDTO subtrairValor(String id, Double valor) {
        if (valor <= 0) {
            throw new IllegalArgumentException("Valor deve ser positivo");
        }

        MetaFinanceira meta = metaRepository.findById(id)
                .orElseThrow(() -> new RecursoNaoEcontradoException("Meta financeira não encontrada"));

        if (meta.getValorAtual() < valor) {
            throw new IllegalArgumentException("Valor atual insuficiente para subtração");
        }

        meta.setValorAtual(meta.getValorAtual() - valor);

        if (meta.getConcluida() && meta.getValorAtual() < meta.getValorDesejado()) {
            meta.setConcluida(false);
        }

        MetaFinanceira atualizada = metaRepository.save(meta);
        return metaMapper.toResponseDTO(atualizada);
    }

    public MetaFinanceiraResponseDTO marcarComoConcluida(String id) {
        MetaFinanceira meta = metaRepository.findById(id)
                .orElseThrow(() -> new RecursoNaoEcontradoException("Meta financeira não encontrada"));

        if (meta.getConcluida()) {
            throw new IllegalArgumentException("Meta já está concluída");
        }

        if (meta.getValorAtual() < meta.getValorDesejado()) {
            throw new IllegalArgumentException("Valor atual ainda não atingiu o valor desejado");
        }

        meta.setConcluida(true);
        MetaFinanceira atualizada = metaRepository.save(meta);

        return metaMapper.toResponseDTO(atualizada);
    }

    public void deletar(String id) {
        if (!metaRepository.existsById(id)) {
            throw new RecursoNaoEcontradoException("Meta financeira não encontrada");
        }

        metaRepository.deleteById(id);
    }
}
