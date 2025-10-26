package controle.financeiro.backend.service;

import controle.financeiro.backend.dto.request.fatura.AtualizaFaturaDTO;
import controle.financeiro.backend.dto.request.fatura.CriaFaturaDTO;
import controle.financeiro.backend.dto.response.FaturaResponseDTO;
import controle.financeiro.backend.enums.StatusPagamento;
import controle.financeiro.backend.exception.RecursoNaoEcontradoException;
import controle.financeiro.backend.mapper.FaturaMapper;
import controle.financeiro.backend.model.CartaoCredito;
import controle.financeiro.backend.model.Fatura;
import controle.financeiro.backend.repository.CartaoCreditoRepository;
import controle.financeiro.backend.repository.FaturaRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class FaturaService {

    private final FaturaRepository faturaRepository;
    private final CartaoCreditoRepository cartaoCreditoRepository;
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

    public List<FaturaResponseDTO> listarPorCartao(String cartaoId) {
        if (!cartaoCreditoRepository.existsById(cartaoId)) {
            throw new RecursoNaoEcontradoException("Cartão não encontrado");
        }

        List<Fatura> faturas = faturaRepository.findByCartaoCreditoId(cartaoId);
        return faturaMapper.toResponseDTOList(faturas);
    }

    public List<FaturaResponseDTO> listarPorUsuario(String usuarioId) {
        List<Fatura> faturas = faturaRepository.findByUsuarioId(usuarioId);
        return faturaMapper.toResponseDTOList(faturas);
    }

    public List<FaturaResponseDTO> listarVencidas() {
        List<Fatura> faturas = faturaRepository.findVencidas(LocalDate.now());
        return faturaMapper.toResponseDTOList(faturas);
    }

    public List<FaturaResponseDTO> listarPendentes(String cartaoId) {
        if (!cartaoCreditoRepository.existsById(cartaoId)) {
            throw new RecursoNaoEcontradoException("Cartão não encontrado");
        }

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
