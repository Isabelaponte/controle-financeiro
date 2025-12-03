package controle.financeiro.backend.service;

import controle.financeiro.backend.dto.request.despesa.cartao.AtualizaDespesaCartaoDTO;
import controle.financeiro.backend.dto.request.despesa.cartao.CriaDespesaCartaoDTO;
import controle.financeiro.backend.dto.response.DespesaCartaoResponseDTO;
import controle.financeiro.backend.enums.StatusPagamento;
import controle.financeiro.backend.exception.RecursoNaoEcontradoException;
import controle.financeiro.backend.mapper.DespesaCartaoMapper;
import controle.financeiro.backend.model.*;
import controle.financeiro.backend.repository.*;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class DespesaCartaoService {

    private final DespesaCartaoRepository despesaCartaoRepository;
    private final UsuarioRepository usuarioRepository;
    private final CategoriaRepository categoriaRepository;
    private final CartaoCreditoRepository cartaoCreditoRepository;
    private final FaturaRepository faturaRepository;
    private final DespesaCartaoMapper despesaCartaoMapper;

    public DespesaCartaoResponseDTO criar(CriaDespesaCartaoDTO dto) {
        Usuario usuario = usuarioRepository.findById(dto.getUsuarioId())
                .orElseThrow(() -> new RecursoNaoEcontradoException("Usuário não encontrado"));

        Categoria categoria = categoriaRepository.findById(dto.getCategoriaId())
                .orElseThrow(() -> new RecursoNaoEcontradoException("Categoria não encontrada"));

        CartaoCredito cartao = cartaoCreditoRepository.findById(dto.getCartaoId())
                .orElseThrow(() -> new RecursoNaoEcontradoException("Cartão de crédito não encontrado"));

        Fatura fatura;
        if (dto.getFaturaId() != null) {
            fatura = faturaRepository.findById(dto.getFaturaId())
                    .orElseThrow(() -> new RecursoNaoEcontradoException("Fatura não encontrada"));
        } else {
            fatura = buscarOuCriarFatura(cartao, dto.getDataDespesa());
        }

        DespesaCartao despesa = despesaCartaoMapper.toEntity(dto, usuario, categoria, cartao, fatura);
        DespesaCartao salva = despesaCartaoRepository.save(despesa);

        atualizarValorFatura(fatura);

        return despesaCartaoMapper.toResponseDTO(salva);
    }

    private Fatura buscarOuCriarFatura(CartaoCredito cartao, LocalDate dataDespesa) {
        LocalDate dataVencimento = calcularDataVencimento(cartao, dataDespesa);

        Optional<Fatura> faturaExistente = faturaRepository
                .findByCartaoCreditoIdAndDataVencimento(cartao.getId(), dataVencimento);

        if (faturaExistente.isPresent()) {
            return faturaExistente.get();
        }

        Fatura novaFatura = new Fatura();
        novaFatura.setCartaoCredito(cartao);
        novaFatura.setDataVencimento(dataVencimento);
        novaFatura.setValorTotal(0.0);
        novaFatura.setStatusPagamento(StatusPagamento.PENDENTE);

        return faturaRepository.save(novaFatura);
    }

    private LocalDate calcularDataVencimento(CartaoCredito cartao, LocalDate dataDespesa) {
        int diaVencimento = cartao.getDiaVencimento();
        int diaFechamento = cartao.getDiaFechamento();

        LocalDate dataFechamento = dataDespesa.withDayOfMonth(diaFechamento);

        if (dataDespesa.isAfter(dataFechamento)) {
            return dataDespesa.plusMonths(1).withDayOfMonth(diaVencimento);
        } else {
            return dataDespesa.withDayOfMonth(diaVencimento);
        }
    }

    private void atualizarValorFatura(Fatura fatura) {
        Double valorTotal = despesaCartaoRepository.somarValorPorFatura(fatura.getId());
        fatura.setValorTotal(valorTotal != null ? valorTotal : 0.0);
        faturaRepository.save(fatura);
    }

    public DespesaCartaoResponseDTO buscarPorId(String id) {
        DespesaCartao despesa = despesaCartaoRepository.findById(id)
                .orElseThrow(() -> new RecursoNaoEcontradoException("Despesa não encontrada"));

        return despesaCartaoMapper.toResponseDTO(despesa);
    }

    public List<DespesaCartaoResponseDTO> listarPorUsuario(String usuarioId) {
        if (!usuarioRepository.existsById(usuarioId)) {
            throw new RecursoNaoEcontradoException("Usuário não encontrado");
        }

        List<DespesaCartao> despesas = despesaCartaoRepository.findByUsuarioId(usuarioId);
        return despesaCartaoMapper.toResponseDTOList(despesas);
    }

    public List<DespesaCartaoResponseDTO> listarPorCartao(String cartaoId) {
        if (!cartaoCreditoRepository.existsById(cartaoId)) {
            throw new RecursoNaoEcontradoException("Cartão não encontrado");
        }

        List<DespesaCartao> despesas = despesaCartaoRepository.findByCartaoCreditoId(cartaoId);
        return despesaCartaoMapper.toResponseDTOList(despesas);
    }

    public List<DespesaCartaoResponseDTO> listarPorFatura(String faturaId) {
        if (!faturaRepository.existsById(faturaId)) {
            throw new RecursoNaoEcontradoException("Fatura não encontrada");
        }

        List<DespesaCartao> despesas = despesaCartaoRepository.findByFaturaId(faturaId);
        return despesaCartaoMapper.toResponseDTOList(despesas);
    }

    public DespesaCartaoResponseDTO atualizar(String id, AtualizaDespesaCartaoDTO dto) {
        DespesaCartao despesa = despesaCartaoRepository.findById(id)
                .orElseThrow(() -> new RecursoNaoEcontradoException("Despesa não encontrada"));

        Categoria categoria = null;
        if (dto.getCategoriaId() != null) {
            categoria = categoriaRepository.findById(dto.getCategoriaId())
                    .orElseThrow(() -> new RecursoNaoEcontradoException("Categoria não encontrada"));
        }

        CartaoCredito cartao = null;
        if (dto.getCartaoId() != null) {
            cartao = cartaoCreditoRepository.findById(dto.getCartaoId())
                    .orElseThrow(() -> new RecursoNaoEcontradoException("Cartão não encontrado"));
        }

        Fatura fatura = null;
        if (dto.getFaturaId() != null) {
            fatura = faturaRepository.findById(dto.getFaturaId())
                    .orElseThrow(() -> new RecursoNaoEcontradoException("Fatura não encontrada"));
        }

        Fatura faturaAntiga = despesa.getFatura();

        despesaCartaoMapper.updateEntity(dto, despesa, categoria, cartao, fatura);
        DespesaCartao atualizada = despesaCartaoRepository.save(despesa);

        if (faturaAntiga != null) {
            atualizarValorFatura(faturaAntiga);
        }
        if (atualizada.getFatura() != null &&
                (faturaAntiga == null || !faturaAntiga.getId().equals(atualizada.getFatura().getId()))) {
            atualizarValorFatura(atualizada.getFatura());
        }

        return despesaCartaoMapper.toResponseDTO(atualizada);
    }

    public void deletar(String id) {
        DespesaCartao despesa = despesaCartaoRepository.findById(id)
                .orElseThrow(() -> new RecursoNaoEcontradoException("Despesa não encontrada"));

        Fatura fatura = despesa.getFatura();

        despesaCartaoRepository.deleteById(id);

        if (fatura != null) {
            atualizarValorFatura(fatura);
        }
    }
}