package controle.financeiro.backend.service;

import controle.financeiro.backend.dto.request.fatura.AtualizaFaturaDTO;
import controle.financeiro.backend.dto.request.fatura.CriaFaturaDTO;
import controle.financeiro.backend.dto.response.FaturaResponseDTO;
import controle.financeiro.backend.enums.StatusPagamento;
import controle.financeiro.backend.exception.RecursoNaoEcontradoException;
import controle.financeiro.backend.mapper.FaturaMapper;
import controle.financeiro.backend.model.CartaoCredito;
import controle.financeiro.backend.model.DespesaCartao;
import controle.financeiro.backend.model.Fatura;
import controle.financeiro.backend.repository.CartaoCreditoRepository;
import controle.financeiro.backend.repository.DespesaCartaoRepository;
import controle.financeiro.backend.repository.FaturaRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class FaturaService {

    private final FaturaRepository faturaRepository;
    private final CartaoCreditoRepository cartaoCreditoRepository;
    private final DespesaCartaoRepository despesaCartaoRepository;
    private final FaturaMapper faturaMapper;

    public FaturaResponseDTO criar(CriaFaturaDTO dto) {
        CartaoCredito cartao = cartaoCreditoRepository.findById(dto.getCartaoId())
                .orElseThrow(() -> new RecursoNaoEcontradoException("Cartão de crédito não encontrado"));

        Fatura fatura = faturaMapper.toEntity(dto, cartao);
        Fatura salva = faturaRepository.save(fatura);

        return faturaMapper.toResponseDTO(salva);
    }

    public FaturaResponseDTO buscarPorId(String id) {
        Fatura fatura = faturaRepository.findById(id)
                .orElseThrow(() -> new RecursoNaoEcontradoException("Fatura não encontrada"));

        return faturaMapper.toResponseDTO(fatura);
    }

    private void verificarEProcessarFaturasVencidas(CartaoCredito cartao) {
        LocalDate hoje = LocalDate.now();

        List<Fatura> faturasPendentes = faturaRepository.findByCartaoCreditoIdAndStatusPagamento(
                cartao.getId(),
                StatusPagamento.PENDENTE
        );

        for (Fatura fatura : faturasPendentes) {
            if (fatura.getDataVencimento().isBefore(hoje)) {
                fatura.setStatusPagamento(StatusPagamento.ATRASADO);
                faturaRepository.save(fatura);
            }
        }
    }

    private void criarProximaFatura(CartaoCredito cartao, Fatura faturaAnterior) {
        LocalDate hoje = LocalDate.now();
        int diaVencimento = cartao.getDiaVencimento();

        LocalDate dataVencimento;

        if (faturaAnterior != null) {
            dataVencimento = faturaAnterior.getDataVencimento().plusMonths(1);
        } else {
            dataVencimento = hoje.withDayOfMonth(diaVencimento);
            if (dataVencimento.isBefore(hoje) || dataVencimento.isEqual(hoje)) {
                dataVencimento = dataVencimento.plusMonths(1);
            }
        }

        Fatura novaFatura = new Fatura();
        novaFatura.setCartaoCredito(cartao);
        novaFatura.setDataVencimento(dataVencimento);
        novaFatura.setValorTotal(0.0);
        novaFatura.setStatusPagamento(StatusPagamento.PENDENTE);

        faturaRepository.save(novaFatura);
    }

    private void garantirFaturaPendente(CartaoCredito cartao) {
        LocalDate hoje = LocalDate.now();

        Optional<Fatura> ultimaFatura = faturaRepository
                .findFirstByCartaoCreditoIdOrderByDataVencimentoDesc(cartao.getId());

        boolean precisaCriarNova = false;

        if (ultimaFatura.isEmpty()) {
            precisaCriarNova = true;
        } else {
            Fatura ultima = ultimaFatura.get();

            if (ultima.getDataVencimento().isBefore(hoje) ||
                    ultima.getDataVencimento().isEqual(hoje)) {
                precisaCriarNova = true;
            }
        }

        if (precisaCriarNova) {
            criarProximaFatura(cartao, ultimaFatura.orElse(null));
        }
    }

    public List<FaturaResponseDTO> listarPorCartao(String cartaoId) {
        CartaoCredito cartao = cartaoCreditoRepository.findById(cartaoId)
                .orElseThrow(() -> new RecursoNaoEcontradoException("Cartão não encontrado"));

        verificarEProcessarFaturasVencidas(cartao);
        garantirFaturaPendente(cartao);

        List<Fatura> faturas = faturaRepository.findByCartaoCreditoId(cartaoId);
        return faturaMapper.toResponseDTOList(faturas);
    }

    public List<FaturaResponseDTO> listarFaturasVencidas(String usuarioId) {
        List<Fatura> faturas = faturaRepository.findVencidasPorUsuario(
                usuarioId,
                LocalDate.now(),
                StatusPagamento.PAGO
        );
        return faturaMapper.toResponseDTOList(faturas);
    }

    public List<FaturaResponseDTO> listarPendentes(String cartaoId) {
        CartaoCredito cartao = cartaoCreditoRepository.findById(cartaoId)
                .orElseThrow(() -> new RecursoNaoEcontradoException("Cartão não encontrado"));

        verificarEProcessarFaturasVencidas(cartao);
        garantirFaturaPendente(cartao);

        List<Fatura> faturas = faturaRepository.findByCartaoCreditoIdAndStatusPagamento(
                cartaoId, StatusPagamento.PENDENTE);
        return faturaMapper.toResponseDTOList(faturas);
    }

    public FaturaResponseDTO atualizar(String id, AtualizaFaturaDTO dto) {
        Fatura fatura = faturaRepository.findById(id)
                .orElseThrow(() -> new RecursoNaoEcontradoException("Fatura não encontrada"));

        faturaMapper.updateEntity(dto, fatura);

        Fatura atualizada = faturaRepository.save(fatura);
        return faturaMapper.toResponseDTO(atualizada);
    }

    public FaturaResponseDTO pagarFatura(String id) {
        Fatura fatura = faturaRepository.findById(id)
                .orElseThrow(() -> new RecursoNaoEcontradoException("Fatura não encontrada"));

        if (fatura.getStatusPagamento() == StatusPagamento.PAGO) {
            throw new IllegalArgumentException("Fatura já está paga");
        }

        fatura.setStatusPagamento(StatusPagamento.PAGO);
        fatura.setDataPagamento(LocalDate.now());

        List<DespesaCartao> despesas = despesaCartaoRepository.findByFaturaId(id);
        for (DespesaCartao despesa : despesas) {
            despesa.setPago(true);
        }
        despesaCartaoRepository.saveAll(despesas);

        Fatura paga = faturaRepository.save(fatura);
        return faturaMapper.toResponseDTO(paga);
    }



    public void deletar(String id) {
        if (!faturaRepository.existsById(id)) {
            throw new RecursoNaoEcontradoException("Fatura não encontrada");
        }

        faturaRepository.deleteById(id);
    }
}
