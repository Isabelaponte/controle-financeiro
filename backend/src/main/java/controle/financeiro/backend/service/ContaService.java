package controle.financeiro.backend.service;

import controle.financeiro.backend.dto.request.conta.AtualizaContaDTO;
import controle.financeiro.backend.dto.request.conta.CriaContaDTO;
import controle.financeiro.backend.dto.response.ContaResponseDTO;
import controle.financeiro.backend.exception.RecursoNaoEcontradoException;
import controle.financeiro.backend.exception.conta.ContaNomeJaExisteException;
import controle.financeiro.backend.exception.conta.SaldoInsuficienteException;
import controle.financeiro.backend.mapper.ContaMapper;
import controle.financeiro.backend.model.Categoria;
import controle.financeiro.backend.model.Conta;
import controle.financeiro.backend.model.Usuario;
import controle.financeiro.backend.repository.CategoriaRepository;
import controle.financeiro.backend.repository.ContaRepository;
import controle.financeiro.backend.repository.UsuarioRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class ContaService {

    private final ContaRepository contaRepository;
    private final UsuarioRepository usuarioRepository;
    private final CategoriaRepository categoriaRepository;
    private final ContaMapper contaMapper;

    public ContaResponseDTO criar(CriaContaDTO dto) {
        Usuario usuario = usuarioRepository.findById(dto.getUsuarioId())
                .orElseThrow(() -> new RecursoNaoEcontradoException("Usuário não encontrado"));

        if (contaRepository.existsByNomeAndUsuarioId(dto.getNome(), dto.getUsuarioId())) {
            throw new ContaNomeJaExisteException("Já existe uma conta com este nome");
        }

        Categoria categoria = null;
        if (dto.getCategoriaId() != null) {
            categoria = categoriaRepository.findById(dto.getCategoriaId())
                    .orElseThrow(() -> new RecursoNaoEcontradoException("Categoria não encontrada"));
        }

        Conta conta = contaMapper.toEntity(dto, usuario, categoria);
        Conta salva = contaRepository.save(conta);

        return contaMapper.toResponseDTO(salva);
    }

    public ContaResponseDTO buscarPorId(String id) {
        Conta conta = contaRepository.findById(id)
                .orElseThrow(() -> new RecursoNaoEcontradoException("Conta não encontrada"));

        return contaMapper.toResponseDTO(conta);
    }

    public List<ContaResponseDTO> listarPorUsuario(String usuarioId) {
        if (!usuarioRepository.existsById(usuarioId)) {
            throw new RecursoNaoEcontradoException("Usuário não encontrado");
        }

        List<Conta> contas = contaRepository.findByUsuarioId(usuarioId);
        return contaMapper.toResponseDTOList(contas);
    }

    public List<ContaResponseDTO> listarAtivasPorUsuario(String usuarioId) {
        if (!usuarioRepository.existsById(usuarioId)) {
            throw new RecursoNaoEcontradoException("Usuário não encontrado");
        }

        List<Conta> contas = contaRepository.findByUsuarioIdAndAtiva(usuarioId, true);
        return contaMapper.toResponseDTOList(contas);
    }

    public Double calcularSaldoTotal(String usuarioId) {
        if (!usuarioRepository.existsById(usuarioId)) {
            throw new RecursoNaoEcontradoException("Usuário não encontrado");
        }

        Double saldo = contaRepository.calcularSaldoTotal(usuarioId);
        return saldo != null ? saldo : 0.0;
    }

    public ContaResponseDTO atualizar(String id, AtualizaContaDTO dto) {
        Conta conta = contaRepository.findById(id)
                .orElseThrow(() -> new RecursoNaoEcontradoException("Conta não encontrada"));

        if (dto.getNome() != null && !conta.getNome().equals(dto.getNome())) {
            if (contaRepository.existsByNomeAndUsuarioId(dto.getNome(), conta.getUsuario().getId())) {
                throw new ContaNomeJaExisteException("Já existe uma conta com este nome");
            }
        }

        Categoria categoria = null;
        if (dto.getCategoriaId() != null) {
            categoria = categoriaRepository.findById(dto.getCategoriaId())
                    .orElseThrow(() -> new RecursoNaoEcontradoException("Categoria não encontrada"));
        }

        contaMapper.updateEntity(dto, conta, categoria);

        Conta atualizada = contaRepository.save(conta);
        return contaMapper.toResponseDTO(atualizada);
    }

    public ContaResponseDTO adicionarSaldo(String id, Double valor) {
        if (valor <= 0) {
            throw new IllegalArgumentException("Valor deve ser positivo");
        }

        Conta conta = contaRepository.findById(id)
                .orElseThrow(() -> new RecursoNaoEcontradoException("Conta não encontrada"));

        conta.setSaldo(conta.getSaldo() + valor);
        Conta atualizada = contaRepository.save(conta);

        return contaMapper.toResponseDTO(atualizada);
    }

    public ContaResponseDTO subtrairSaldo(String id, Double valor) {
        if (valor <= 0) {
            throw new IllegalArgumentException("Valor deve ser positivo");
        }

        Conta conta = contaRepository.findById(id)
                .orElseThrow(() -> new RecursoNaoEcontradoException("Conta não encontrada"));

        if (conta.getSaldo() < valor) {
            throw new SaldoInsuficienteException("Saldo insuficiente na conta");
        }

        conta.setSaldo(conta.getSaldo() - valor);
        Conta atualizada = contaRepository.save(conta);

        return contaMapper.toResponseDTO(atualizada);
    }

    public ContaResponseDTO desativar(String id) {
        Conta conta = contaRepository.findById(id)
                .orElseThrow(() -> new RecursoNaoEcontradoException("Conta não encontrada"));

        conta.setAtiva(false);
        Conta desativada = contaRepository.save(conta);

        return contaMapper.toResponseDTO(desativada);
    }

    public ContaResponseDTO ativar(String id) {
        Conta conta = contaRepository.findById(id)
                .orElseThrow(() -> new RecursoNaoEcontradoException("Conta não encontrada"));

        conta.setAtiva(true);
        Conta desativada = contaRepository.save(conta);

        return contaMapper.toResponseDTO(desativada);
    }

    public void deletar(String id) {
        if (!contaRepository.existsById(id)) {
            throw new RecursoNaoEcontradoException("Conta não encontrada");
        }

        contaRepository.deleteById(id);
    }
}
