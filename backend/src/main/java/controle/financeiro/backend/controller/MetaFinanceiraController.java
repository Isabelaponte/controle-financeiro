package controle.financeiro.backend.controller;

import controle.financeiro.backend.dto.request.meta.AtualizaMetaFinanceiraDTO;
import controle.financeiro.backend.dto.response.MetaFinanceiraResponseDTO;
import controle.financeiro.backend.service.MetaFinanceiraService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/metas-financeiras")
@RequiredArgsConstructor
public class MetaFinanceiraController {

    private final MetaFinanceiraService metaService;

    @GetMapping("/{id}")
    public ResponseEntity<MetaFinanceiraResponseDTO> buscar(@PathVariable String id) {
        MetaFinanceiraResponseDTO meta = metaService.buscarPorId(id);
        return ResponseEntity.ok(meta);
    }

    @GetMapping("/usuario/{usuarioId}")
    public ResponseEntity<List<MetaFinanceiraResponseDTO>> listarPorUsuario(@PathVariable String usuarioId) {
        List<MetaFinanceiraResponseDTO> metas = metaService.listarPorUsuario(usuarioId);
        return ResponseEntity.ok(metas);
    }

    @GetMapping("/usuario/{usuarioId}/em-andamento")
    public ResponseEntity<List<MetaFinanceiraResponseDTO>> listarMetasEmAndamento(@PathVariable String usuarioId) {
        List<MetaFinanceiraResponseDTO> metas = metaService.listarMetasEmAndamento(usuarioId);
        return ResponseEntity.ok(metas);
    }

    @GetMapping("/usuario/{usuarioId}/concluidas")
    public ResponseEntity<List<MetaFinanceiraResponseDTO>> listarMetasConcluidas(@PathVariable String usuarioId) {
        List<MetaFinanceiraResponseDTO> metas = metaService.listarMetasConcluidas(usuarioId);
        return ResponseEntity.ok(metas);
    }

    @GetMapping("/usuario/{usuarioId}/resumo")
    public ResponseEntity<Map<String, Object>> calcularResumo(@PathVariable String usuarioId) {
        Map<String, Object> resumo = metaService.calcularResumo(usuarioId);
        return ResponseEntity.ok(resumo);
    }

    @PutMapping("/{id}")
    public ResponseEntity<MetaFinanceiraResponseDTO> atualizar(
            @PathVariable String id,
            @Valid @RequestBody AtualizaMetaFinanceiraDTO dto) {
        MetaFinanceiraResponseDTO atualizada = metaService.atualizar(id, dto);
        return ResponseEntity.ok(atualizada);
    }

    @PatchMapping("/{id}/adicionar-valor")
    public ResponseEntity<MetaFinanceiraResponseDTO> adicionarValor(
            @PathVariable String id,
            @RequestBody Map<String, Double> body) {
        Double valor = body.get("valor");
        MetaFinanceiraResponseDTO atualizada = metaService.adicionarValor(id, valor);
        return ResponseEntity.ok(atualizada);
    }

    @PatchMapping("/{id}/subtrair-valor")
    public ResponseEntity<MetaFinanceiraResponseDTO> subtrairValor(
            @PathVariable String id,
            @RequestBody Map<String, Double> body) {
        Double valor = body.get("valor");
        MetaFinanceiraResponseDTO atualizada = metaService.subtrairValor(id, valor);
        return ResponseEntity.ok(atualizada);
    }

    @PatchMapping("/{id}/marcar-concluida")
    public ResponseEntity<MetaFinanceiraResponseDTO> marcarComoConcluida(@PathVariable String id) {
        MetaFinanceiraResponseDTO atualizada = metaService.marcarComoConcluida(id);
        return ResponseEntity.ok(atualizada);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletar(@PathVariable String id) {
        metaService.deletar(id);
        return ResponseEntity.noContent().build();
    }
}
