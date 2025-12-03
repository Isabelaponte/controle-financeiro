package controle.financeiro.backend.service;

import controle.financeiro.backend.dto.response.ResumoMensalDTO;
import controle.financeiro.backend.exception.RecursoNaoEcontradoException;
import controle.financeiro.backend.model.Despesa;
import controle.financeiro.backend.model.Receita;
import controle.financeiro.backend.repository.DespesaCartaoRepository;
import controle.financeiro.backend.repository.DespesaGeralRepository;
import controle.financeiro.backend.repository.ReceitaRepository;
import controle.financeiro.backend.repository.UsuarioRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;

@Service
@RequiredArgsConstructor
public class ResumoService {

    private final ReceitaRepository receitaRepository;
    private final DespesaGeralRepository despesaGeralRepository;
    private final DespesaCartaoRepository despesaCartaoRepository;
    private final UsuarioRepository usuarioRepository;

    public ResumoMensalDTO getResumoMensal(String usuarioId) {
        if (!usuarioRepository.existsById(usuarioId)) {
            throw new RecursoNaoEcontradoException("Usuário não encontrado");
        }

        LocalDate hoje = LocalDate.now();
        int mes = hoje.getMonthValue();
        int ano = hoje.getYear();

        LocalDate dataInicio = LocalDate.of(ano, mes, 1);
        LocalDate dataFim = dataInicio.plusMonths(1).minusDays(1);

        Double totalGanhos = receitaRepository.findByUsuarioIdAndPeriodo(usuarioId, dataInicio, dataFim)
                .stream()
                .mapToDouble(Receita::getValor)
                .sum();

        Double despesasGerais = despesaGeralRepository
                .findByUsuarioIdAndDataVencimentoBetween(usuarioId, dataInicio, dataFim)
                .stream()
                .mapToDouble(Despesa::getValor)
                .sum();

        Double despesasCartao = despesaCartaoRepository
                .findByUsuarioIdAndDataDespesaBetween(usuarioId, dataInicio, dataFim)
                .stream()
                .mapToDouble(Despesa::getValor)
                .sum();

        Double totalGastos = despesasGerais + despesasCartao;
        Double saldo = totalGanhos - totalGastos;

        return new ResumoMensalDTO(totalGanhos, totalGastos, saldo, mes, ano);
    }
}