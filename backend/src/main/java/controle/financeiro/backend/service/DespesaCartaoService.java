package controle.financeiro.backend.service;

import controle.financeiro.backend.dto.request.despesa.cartao.AtualizaDespesaCartaoDTO;
import controle.financeiro.backend.dto.request.despesa.cartao.CriaDespesaCartaoDTO;
import controle.financeiro.backend.dto.response.DespesaCartaoResponseDTO;
import controle.financeiro.backend.exception.RecursoNaoEcontradoException;
import controle.financeiro.backend.mapper.DespesaCartaoMapper;
import controle.financeiro.backend.model.*;
import controle.financeiro.backend.repository.*;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

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

        Fatura fatura = null;
        if (dto.getFaturaId() != null) {
            fatura = faturaRepository.findById(dto.getFaturaId())
                    .orElseThrow(() -> new RecursoNaoEcontradoException("Fatura não encontrada"));
        }

        DespesaCartao despesa = despesaCartaoMapper.toEntity(dto, usuario, categoria, cartao, fatura);
        DespesaCartao salva = despesaCartaoRepository.save(despesa);

        return despesaCartaoMapper.toResponseDTO(salva);
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

        despesaCartaoMapper.updateEntity(dto, despesa, categoria, cartao, fatura);
        DespesaCartao atualizada = despesaCartaoRepository.save(despesa);

        return despesaCartaoMapper.toResponseDTO(atualizada);
    }

    public void deletar(String id) {
        if (!despesaCartaoRepository.existsById(id)) {
            throw new RecursoNaoEcontradoException("Despesa não encontrada");
        }

        despesaCartaoRepository.deleteById(id);
    }
}
