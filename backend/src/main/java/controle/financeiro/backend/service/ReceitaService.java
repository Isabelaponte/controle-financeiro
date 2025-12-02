package controle.financeiro.backend.service;

import controle.financeiro.backend.dto.request.receita.AtualizaReceitaDTO;
import controle.financeiro.backend.dto.request.receita.CriaReceitaDTO;
import controle.financeiro.backend.dto.response.ReceitaResponseDTO;
import controle.financeiro.backend.exception.RecursoNaoEcontradoException;
import controle.financeiro.backend.mapper.ReceitaMapper;
import controle.financeiro.backend.model.Categoria;
import controle.financeiro.backend.model.Conta;
import controle.financeiro.backend.model.Receita;
import controle.financeiro.backend.model.Usuario;
import controle.financeiro.backend.repository.CategoriaRepository;
import controle.financeiro.backend.repository.ContaRepository;
import controle.financeiro.backend.repository.ReceitaRepository;
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
public class ReceitaService {

    private final ContaService contaService;
    private final ReceitaRepository receitaRepository;
    private final UsuarioRepository usuarioRepository;
    private final ContaRepository contaRepository;
    private final CategoriaRepository categoriaRepository;
    private final ReceitaMapper receitaMapper;

    public ReceitaResponseDTO criar(CriaReceitaDTO dto) {
        Usuario usuario = usuarioRepository.findById(dto.getUsuarioId())
                .orElseThrow(() -> new RecursoNaoEcontradoException("Usuário não encontrado"));

        Conta conta = contaRepository.findById(dto.getContaId())
                .orElseThrow(() -> new RecursoNaoEcontradoException("Conta não encontrada"));

        if (!conta.getUsuario().getId().equals(dto.getUsuarioId())) {
            throw new IllegalArgumentException("Conta não pertence ao usuário");
        }

        Categoria categoria = null;
        if (dto.getCategoriaId() != null) {
            categoria = categoriaRepository.findById(dto.getCategoriaId())
                    .orElseThrow(() -> new RecursoNaoEcontradoException("Categoria não encontrada"));
        }

        if (dto.getRepete() && dto.getPeriodo() == null) {
            throw new IllegalArgumentException("Período é obrigatório quando receita é recorrente");
        }

        Receita receita = receitaMapper.toEntity(dto, conta, categoria, usuario);

        if (receita.getRecebida() == true) {
            contaService.adicionarSaldo(conta.getId(), receita.getValor());
        }

        Receita salva = receitaRepository.save(receita);

        return receitaMapper.toResponseDTO(salva);
    }

    public ReceitaResponseDTO buscarPorId(String id) {
        Receita receita = receitaRepository.findById(id)
                .orElseThrow(() -> new RecursoNaoEcontradoException("Receita não encontrada"));

        return receitaMapper.toResponseDTO(receita);
    }

    public List<ReceitaResponseDTO> listarPorUsuario(String usuarioId) {
        if (!usuarioRepository.existsById(usuarioId)) {
            throw new RecursoNaoEcontradoException("Usuário não encontrado");
        }

        List<Receita> receitas = receitaRepository.findByUsuarioId(usuarioId);
        return receitaMapper.toResponseDTOList(receitas);
    }

    public List<ReceitaResponseDTO> listarPorStatus(String usuarioId, Boolean recebida) {
        if (!usuarioRepository.existsById(usuarioId)) {
            throw new RecursoNaoEcontradoException("Usuário não encontrado");
        }

        List<Receita> receitas = receitaRepository.findByUsuarioIdAndRecebida(usuarioId, recebida);
        return receitaMapper.toResponseDTOList(receitas);
    }

    public List<ReceitaResponseDTO> listarPorPeriodo(String usuarioId, LocalDate dataInicio, LocalDate dataFim) {
        if (!usuarioRepository.existsById(usuarioId)) {
            throw new RecursoNaoEcontradoException("Usuário não encontrado");
        }

        List<Receita> receitas = receitaRepository.findByUsuarioIdAndPeriodo(usuarioId, dataInicio, dataFim);
        return receitaMapper.toResponseDTOList(receitas);
    }

    public List<ReceitaResponseDTO> listarReceitasFixas(String usuarioId) {
        if (!usuarioRepository.existsById(usuarioId)) {
            throw new RecursoNaoEcontradoException("Usuário não encontrado");
        }

        List<Receita> receitas = receitaRepository.findByUsuarioIdAndFixa(usuarioId, true);
        return receitaMapper.toResponseDTOList(receitas);
    }

    public List<ReceitaResponseDTO> listarReceitasAtrasadas(String usuarioId) {
        if (!usuarioRepository.existsById(usuarioId)) {
            throw new RecursoNaoEcontradoException("Usuário não encontrado");
        }

        List<Receita> receitas = receitaRepository.findReceitasAtrasadas(usuarioId, LocalDate.now());
        return receitaMapper.toResponseDTOList(receitas);
    }

    public Map<String, Double> calcularResumo(String usuarioId) {
        if (!usuarioRepository.existsById(usuarioId)) {
            throw new RecursoNaoEcontradoException("Usuário não encontrado");
        }

        Double totalRecebido = receitaRepository.calcularTotalRecebido(usuarioId);
        Double totalAReceber = receitaRepository.calcularTotalAReceber(usuarioId);

        Map<String, Double> resumo = new HashMap<>();
        resumo.put("totalRecebido", totalRecebido != null ? totalRecebido : 0.0);
        resumo.put("totalAReceber", totalAReceber != null ? totalAReceber : 0.0);
        resumo.put("totalGeral", (totalRecebido != null ? totalRecebido : 0.0) +
                (totalAReceber != null ? totalAReceber : 0.0));

        return resumo;
    }

    public ReceitaResponseDTO atualizar(String id, AtualizaReceitaDTO dto) {
        Receita receita = receitaRepository.findById(id)
                .orElseThrow(() -> new RecursoNaoEcontradoException("Receita não encontrada"));

        Conta conta = null;
        if (dto.getContaId() != null) {
            conta = contaRepository.findById(dto.getContaId())
                    .orElseThrow(() -> new RecursoNaoEcontradoException("Conta não encontrada"));

            if (!conta.getUsuario().getId().equals(receita.getUsuario().getId())) {
                throw new IllegalArgumentException("Conta não pertence ao usuário");
            }
        }

        Categoria categoria = null;
        if (dto.getCategoriaId() != null) {
            categoria = categoriaRepository.findById(dto.getCategoriaId())
                    .orElseThrow(() -> new RecursoNaoEcontradoException("Categoria não encontrada"));
        }

        receitaMapper.updateEntity(dto, receita, conta, categoria);

        Receita atualizada = receitaRepository.save(receita);
        return receitaMapper.toResponseDTO(atualizada);
    }

    public ReceitaResponseDTO marcarComoRecebida(String id) {
        Receita receita = receitaRepository.findById(id)
                .orElseThrow(() -> new RecursoNaoEcontradoException("Receita não encontrada"));

        if (receita.getRecebida()) {
            throw new IllegalArgumentException("Receita já foi marcada como recebida");
        }

        Conta conta = receita.getConta();
        conta.setSaldo(conta.getSaldo() + receita.getValor());
        contaRepository.save(conta);

        receita.setRecebida(true);
        Receita atualizada = receitaRepository.save(receita);

        return receitaMapper.toResponseDTO(atualizada);
    }

    public ReceitaResponseDTO desmarcarComoRecebida(String id) {
        Receita receita = receitaRepository.findById(id)
                .orElseThrow(() -> new RecursoNaoEcontradoException("Receita não encontrada"));

        if (!receita.getRecebida()) {
            throw new IllegalArgumentException("Receita não está marcada como recebida");
        }

        Conta conta = receita.getConta();
        if (conta.getSaldo() < receita.getValor()) {
            throw new IllegalArgumentException("Saldo insuficiente na conta para reverter o recebimento");
        }

        conta.setSaldo(conta.getSaldo() - receita.getValor());
        contaRepository.save(conta);

        receita.setRecebida(false);
        Receita atualizada = receitaRepository.save(receita);

        return receitaMapper.toResponseDTO(atualizada);
    }

    public void deletar(String id) {
        Receita receita = receitaRepository.findById(id)
                .orElseThrow(() -> new RecursoNaoEcontradoException("Receita não encontrada"));

        if (receita.getRecebida()) {
            throw new IllegalArgumentException("Não é possível deletar uma receita já recebida. Desmarque primeiro.");
        }

        receitaRepository.deleteById(id);
    }
}
