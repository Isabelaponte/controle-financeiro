package controle.financeiro.backend.controller;

import controle.financeiro.backend.dto.request.receita.AtualizaReceitaDTO;
import controle.financeiro.backend.dto.request.receita.CriaReceitaDTO;
import controle.financeiro.backend.dto.response.ReceitaResponseDTO;
import controle.financeiro.backend.service.ReceitaService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/receitas")
@RequiredArgsConstructor
public class ReceitaController {

    private final ReceitaService receitaService;

    @PostMapping
    public ResponseEntity<ReceitaResponseDTO> criar(@Valid @RequestBody CriaReceitaDTO dto) {
        ReceitaResponseDTO criada = receitaService.criar(dto);
        return ResponseEntity.status(HttpStatus.CREATED).body(criada);
    }

    @GetMapping("/{id}")
    public ResponseEntity<ReceitaResponseDTO> buscar(@PathVariable String id) {
        ReceitaResponseDTO receita = receitaService.buscarPorId(id);
        return ResponseEntity.ok(receita);
    }

    @GetMapping("/usuario/{usuarioId}")
    public ResponseEntity<List<ReceitaResponseDTO>> listarPorUsuario(@PathVariable String usuarioId) {
        List<ReceitaResponseDTO> receitas = receitaService.listarPorUsuario(usuarioId);
        return ResponseEntity.ok(receitas);
    }

    @GetMapping("/usuario/{usuarioId}/status")
    public ResponseEntity<List<ReceitaResponseDTO>> listarPorStatus(
            @PathVariable String usuarioId,
            @RequestParam Boolean recebida) {
        List<ReceitaResponseDTO> receitas = receitaService.listarPorStatus(usuarioId, recebida);
        return ResponseEntity.ok(receitas);
    }

    @GetMapping("/usuario/{usuarioId}/periodo")
    public ResponseEntity<List<ReceitaResponseDTO>> listarPorPeriodo(
            @PathVariable String usuarioId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dataInicio,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dataFim) {
        List<ReceitaResponseDTO> receitas = receitaService.listarPorPeriodo(usuarioId, dataInicio, dataFim);
        return ResponseEntity.ok(receitas);
    }

    @GetMapping("/usuario/{usuarioId}/fixas")
    public ResponseEntity<List<ReceitaResponseDTO>> listarReceitasFixas(@PathVariable String usuarioId) {
        List<ReceitaResponseDTO> receitas = receitaService.listarReceitasFixas(usuarioId);
        return ResponseEntity.ok(receitas);
    }

    @GetMapping("/usuario/{usuarioId}/atrasadas")
    public ResponseEntity<List<ReceitaResponseDTO>> listarReceitasAtrasadas(@PathVariable String usuarioId) {
        List<ReceitaResponseDTO> receitas = receitaService.listarReceitasAtrasadas(usuarioId);
        return ResponseEntity.ok(receitas);
    }

    @GetMapping("/usuario/{usuarioId}/resumo")
    public ResponseEntity<Map<String, Double>> calcularResumo(@PathVariable String usuarioId) {
        Map<String, Double> resumo = receitaService.calcularResumo(usuarioId);
        return ResponseEntity.ok(resumo);
    }

    @PutMapping("/{id}")
    public ResponseEntity<ReceitaResponseDTO> atualizar(
            @PathVariable String id,
            @Valid @RequestBody AtualizaReceitaDTO dto) {
        ReceitaResponseDTO atualizada = receitaService.atualizar(id, dto);
        return ResponseEntity.ok(atualizada);
    }

    @PatchMapping("/{id}/marcar-recebida")
    public ResponseEntity<ReceitaResponseDTO> marcarComoRecebida(@PathVariable String id) {
        ReceitaResponseDTO atualizada = receitaService.marcarComoRecebida(id);
        return ResponseEntity.ok(atualizada);
    }

    @PatchMapping("/{id}/desmarcar-recebida")
    public ResponseEntity<ReceitaResponseDTO> desmarcarComoRecebida(@PathVariable String id) {
        ReceitaResponseDTO atualizada = receitaService.desmarcarComoRecebida(id);
        return ResponseEntity.ok(atualizada);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletar(@PathVariable String id) {
        receitaService.deletar(id);
        return ResponseEntity.noContent().build();
    }
}
