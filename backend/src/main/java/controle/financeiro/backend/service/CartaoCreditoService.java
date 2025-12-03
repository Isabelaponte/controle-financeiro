package controle.financeiro.backend.service;

import controle.financeiro.backend.dto.request.cartaoCredito.AtualizaCartaoCreditoDTO;
import controle.financeiro.backend.dto.request.cartaoCredito.CriaCartaoCreditoDTO;
import controle.financeiro.backend.dto.response.CartaoCreditoResponseDTO;
import controle.financeiro.backend.enums.StatusPagamento;
import controle.financeiro.backend.exception.RecursoNaoEcontradoException;
import controle.financeiro.backend.exception.cartaoCredito.CartaoCreditoNomeJaExisteException;
import controle.financeiro.backend.mapper.CartaoCreditoMapper;
import controle.financeiro.backend.model.CartaoCredito;
import controle.financeiro.backend.model.Categoria;
import controle.financeiro.backend.model.Fatura;
import controle.financeiro.backend.model.Usuario;
import controle.financeiro.backend.repository.CartaoCreditoRepository;
import controle.financeiro.backend.repository.CategoriaRepository;
import controle.financeiro.backend.repository.FaturaRepository;
import controle.financeiro.backend.repository.UsuarioRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class CartaoCreditoService {

    private final CartaoCreditoRepository cartaoRepository;
    private final UsuarioRepository usuarioRepository;
    private final CategoriaRepository categoriaRepository;
    private final FaturaRepository faturaRepository;
    private final CartaoCreditoMapper cartaoMapper;

    public CartaoCreditoResponseDTO criar(CriaCartaoCreditoDTO dto) {
        Usuario usuario = usuarioRepository.findById(dto.getUsuarioId())
                .orElseThrow(() -> new RecursoNaoEcontradoException("Usuário não encontrado"));

        if (cartaoRepository.existsByNomeAndUsuarioId(dto.getNome(), dto.getUsuarioId())) {
            throw new CartaoCreditoNomeJaExisteException("Já existe um cartão com este nome");
        }

        if (dto.getDiaVencimento() <= dto.getDiaFechamento()) {
            throw new IllegalArgumentException("Dia de vencimento deve ser após o dia de fechamento");
        }

        Categoria categoria = null;
        if (dto.getCategoriaId() != null) {
            categoria = categoriaRepository.findById(dto.getCategoriaId())
                    .orElseThrow(() -> new RecursoNaoEcontradoException("Categoria não encontrada"));
        }

        CartaoCredito cartao = cartaoMapper.toEntity(dto, usuario, categoria);
        CartaoCredito salvo = cartaoRepository.save(cartao);

        criarProximaFatura(salvo);

        return cartaoMapper.toResponseDTO(salvo);
    }

    private void criarProximaFatura(CartaoCredito cartao) {
        LocalDate hoje = LocalDate.now();
        int diaVencimento = cartao.getDiaVencimento();

        LocalDate dataVencimento = hoje.withDayOfMonth(diaVencimento);

        if (dataVencimento.isBefore(hoje) || dataVencimento.isEqual(hoje)) {
            dataVencimento = dataVencimento.plusMonths(1);
        }

        Fatura novaFatura = new Fatura();
        novaFatura.setCartaoCredito(cartao);
        novaFatura.setDataVencimento(dataVencimento);
        novaFatura.setValorTotal(0.0);
        novaFatura.setStatusPagamento(StatusPagamento.PENDENTE);

        faturaRepository.save(novaFatura);
    }

    public CartaoCreditoResponseDTO buscarPorId(String id) {
        CartaoCredito cartao = cartaoRepository.findById(id)
                .orElseThrow(() -> new RecursoNaoEcontradoException("Cartão de crédito não encontrado"));

        return cartaoMapper.toResponseDTO(cartao);
    }

    public List<CartaoCreditoResponseDTO> listarPorUsuario(String usuarioId) {
        if (!usuarioRepository.existsById(usuarioId)) {
            throw new RecursoNaoEcontradoException("Usuário não encontrado");
        }

        List<CartaoCredito> cartoes = cartaoRepository.findByUsuarioId(usuarioId);
        return cartaoMapper.toResponseDTOList(cartoes);
    }

    public List<CartaoCreditoResponseDTO> listarAtivosPorUsuario(String usuarioId) {
        if (!usuarioRepository.existsById(usuarioId)) {
            throw new RecursoNaoEcontradoException("Usuário não encontrado");
        }

        List<CartaoCredito> cartoes = cartaoRepository.findByUsuarioIdAndAtivo(usuarioId, true);
        return cartaoMapper.toResponseDTOList(cartoes);
    }

    public CartaoCreditoResponseDTO atualizar(String id, AtualizaCartaoCreditoDTO dto) {
        CartaoCredito cartao = cartaoRepository.findById(id)
                .orElseThrow(() -> new RecursoNaoEcontradoException("Cartão de crédito não encontrado"));

        if (dto.getNome() != null && !cartao.getNome().equals(dto.getNome())) {
            if (cartaoRepository.existsByNomeAndUsuarioId(dto.getNome(), cartao.getUsuario().getId())) {
                throw new CartaoCreditoNomeJaExisteException("Já existe um cartão com este nome");
            }
        }

        Integer novoFechamento = dto.getDiaFechamento() != null ? dto.getDiaFechamento() : cartao.getDiaFechamento();
        Integer novoVencimento = dto.getDiaVencimento() != null ? dto.getDiaVencimento() : cartao.getDiaVencimento();

        if (novoVencimento <= novoFechamento) {
            throw new IllegalArgumentException("Dia de vencimento deve ser após o dia de fechamento");
        }

        Categoria categoria = null;
        if (dto.getCategoriaId() != null) {
            categoria = categoriaRepository.findById(dto.getCategoriaId())
                    .orElseThrow(() -> new RecursoNaoEcontradoException("Categoria não encontrada"));
        }

        cartaoMapper.updateEntity(dto, cartao, categoria);

        CartaoCredito atualizado = cartaoRepository.save(cartao);
        return cartaoMapper.toResponseDTO(atualizado);
    }

    public CartaoCreditoResponseDTO alterarLimite(String id, Double novoLimite) {
        if (novoLimite <= 0) {
            throw new IllegalArgumentException("Limite deve ser positivo");
        }

        CartaoCredito cartao = cartaoRepository.findById(id)
                .orElseThrow(() -> new RecursoNaoEcontradoException("Cartão de crédito não encontrado"));

        cartao.setLimiteTotal(novoLimite);

        CartaoCredito atualizado = cartaoRepository.save(cartao);

        return cartaoMapper.toResponseDTO(atualizado);
    }

    public CartaoCreditoResponseDTO desativar(String id) {
        CartaoCredito cartao = cartaoRepository.findById(id)
                .orElseThrow(() -> new RecursoNaoEcontradoException("Cartão de crédito não encontrado"));

        cartao.setAtivo(false);
        CartaoCredito desativado = cartaoRepository.save(cartao);

        return cartaoMapper.toResponseDTO(desativado);
    }

    public void deletar(String id) {
        if (!cartaoRepository.existsById(id)) {
            throw new RecursoNaoEcontradoException("Cartão de crédito não encontrado");
        }

        cartaoRepository.deleteById(id);
    }
}
