package controle.financeiro.backend.service;

import controle.financeiro.backend.dto.request.despesa.geral.AtualizaDespesaGeralDTO;
import controle.financeiro.backend.dto.request.despesa.geral.CriaDespesaGeralDTO;
import controle.financeiro.backend.dto.response.DespesaGeralResponseDTO;
import controle.financeiro.backend.enums.StatusPagamento;
import controle.financeiro.backend.exception.RecursoNaoEcontradoException;
import controle.financeiro.backend.mapper.DespesaGeralMapper;
import controle.financeiro.backend.model.Categoria;
import controle.financeiro.backend.model.Conta;
import controle.financeiro.backend.model.DespesaGeral;
import controle.financeiro.backend.model.Usuario;
import controle.financeiro.backend.repository.CategoriaRepository;
import controle.financeiro.backend.repository.ContaRepository;
import controle.financeiro.backend.repository.DespesaGeralRepository;
import controle.financeiro.backend.repository.UsuarioRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class DespesaGeralService {

    private final ContaService contaService;
    private final DespesaGeralRepository despesaGeralRepository;
    private final UsuarioRepository usuarioRepository;
    private final CategoriaRepository categoriaRepository;
    private final ContaRepository contaRepository;
    private final DespesaGeralMapper despesaGeralMapper;

    public DespesaGeralResponseDTO criar(CriaDespesaGeralDTO dto) {
        Usuario usuario = usuarioRepository.findById(dto.getUsuarioId())
                .orElseThrow(() -> new RecursoNaoEcontradoException("Usuário não encontrado"));

        Categoria categoria = null;
        if (dto.getCategoriaId() != null) {
            categoria = categoriaRepository.findById(dto.getCategoriaId())
                    .orElseThrow(() -> new RecursoNaoEcontradoException("Categoria não encontrada"));
        }

        Conta conta = null;
        if (dto.getContaId() != null) {
            conta = contaRepository.findById(dto.getContaId())
                    .orElseThrow(() -> new RecursoNaoEcontradoException("Conta não encontrada"));
        }

        DespesaGeral despesa = despesaGeralMapper.toEntity(dto, usuario, categoria, conta);

        System.out.println(despesa);

        if (despesa.getPago()) {
            despesa.setStatusPagamento(StatusPagamento.PAGO);
        } else {
            despesa.setStatusPagamento(StatusPagamento.PENDENTE);
        }

        if (!despesa.getPago() && despesa.getDataVencimento().isAfter(LocalDate.now())) {
            despesa.setStatusPagamento(StatusPagamento.ATRASADO);
        }

        if (despesa.getPago()) {
            contaService.subtrairSaldo(conta.getId(), despesa.getValor());
        }

        DespesaGeral salva = despesaGeralRepository.save(despesa);

        return despesaGeralMapper.toResponseDTO(salva);
    }

    public DespesaGeralResponseDTO buscarPorId(String id) {
        DespesaGeral despesa = despesaGeralRepository.findById(id)
                .orElseThrow(() -> new RecursoNaoEcontradoException("Despesa não encontrada"));

        return despesaGeralMapper.toResponseDTO(despesa);
    }

    public List<DespesaGeralResponseDTO> listarPorUsuario(String usuarioId) {
        if (!usuarioRepository.existsById(usuarioId)) {
            throw new RecursoNaoEcontradoException("Usuário não encontrado");
        }

        List<DespesaGeral> despesas = despesaGeralRepository.findByUsuarioId(usuarioId);
        return despesaGeralMapper.toResponseDTOList(despesas);
    }

    public DespesaGeralResponseDTO atualizar(String id, AtualizaDespesaGeralDTO dto) {
        DespesaGeral despesa = despesaGeralRepository.findById(id)
                .orElseThrow(() -> new RecursoNaoEcontradoException("Despesa não encontrada"));

        Categoria categoria = null;
        if (dto.getCategoriaId() != null) {
            categoria = categoriaRepository.findById(dto.getCategoriaId())
                    .orElseThrow(() -> new RecursoNaoEcontradoException("Categoria não encontrada"));
        }

        Conta conta = null;
        if (dto.getContaId() != null) {
            conta = contaRepository.findById(dto.getContaId())
                    .orElseThrow(() -> new RecursoNaoEcontradoException("Conta não encontrada"));
        }

        if (despesa.getPago()) {
            despesa.setStatusPagamento(StatusPagamento.PAGO);
        } else {
            despesa.setStatusPagamento(StatusPagamento.PENDENTE);
        }

        if (!despesa.getPago() && despesa.getDataVencimento().isAfter(LocalDate.now())) {
            despesa.setStatusPagamento(StatusPagamento.ATRASADO);
        }

        if (despesa.getPago()) {
            contaService.subtrairSaldo(conta.getId(), despesa.getValor());
        }

        despesaGeralMapper.updateEntity(dto, despesa, categoria, conta);
        DespesaGeral atualizada = despesaGeralRepository.save(despesa);

        return despesaGeralMapper.toResponseDTO(atualizada);
    }

    public void deletar(String id) {
        if (!despesaGeralRepository.existsById(id)) {
            throw new RecursoNaoEcontradoException("Despesa não encontrada");
        }

        despesaGeralRepository.deleteById(id);
    }

    public DespesaGeralResponseDTO pagarDespesa(String id) {
        DespesaGeral despesa = despesaGeralRepository.findById(id)
                .orElseThrow(() -> new RecursoNaoEcontradoException("Despesa não encontrada"));

        if (despesa.getPago()) {
            throw new IllegalArgumentException("Despesa já está paga");
        }

        despesa.setPago(true);
        despesa.setStatusPagamento(StatusPagamento.PAGO);

        DespesaGeral paga = despesaGeralRepository.save(despesa);
        return despesaGeralMapper.toResponseDTO(paga);
    }
}
