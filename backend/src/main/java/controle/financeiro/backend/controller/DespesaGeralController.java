package controle.financeiro.backend.controller;

import controle.financeiro.backend.dto.request.despesa.geral.AtualizaDespesaGeralDTO;
import controle.financeiro.backend.dto.request.despesa.geral.CriaDespesaGeralDTO;
import controle.financeiro.backend.dto.response.DespesaGeralResponseDTO;
import controle.financeiro.backend.service.DespesaGeralService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/despesas-gerais")
@RequiredArgsConstructor
public class DespesaGeralController {

    private final DespesaGeralService despesaGeralService;

    @GetMapping("/{id}")
    public ResponseEntity<DespesaGeralResponseDTO> buscar(@PathVariable String id) {
        DespesaGeralResponseDTO despesa = despesaGeralService.buscarPorId(id);
        return ResponseEntity.ok(despesa);
    }

    @GetMapping("/usuario/{usuarioId}")
    public ResponseEntity<List<DespesaGeralResponseDTO>> listarPorUsuario(@PathVariable String usuarioId) {
        List<DespesaGeralResponseDTO> despesas = despesaGeralService.listarPorUsuario(usuarioId);
        return ResponseEntity.ok(despesas);
    }

    @PostMapping
    public ResponseEntity<DespesaGeralResponseDTO> criar(@Valid @RequestBody CriaDespesaGeralDTO dto) {
        DespesaGeralResponseDTO criada = despesaGeralService.criar(dto);
        return ResponseEntity.status(HttpStatus.CREATED).body(criada);
    }

    @PutMapping("/{id}")
    public ResponseEntity<DespesaGeralResponseDTO> atualizar(
            @PathVariable String id,
            @Valid @RequestBody AtualizaDespesaGeralDTO dto) {
        DespesaGeralResponseDTO atualizada = despesaGeralService.atualizar(id, dto);
        return ResponseEntity.ok(atualizada);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletar(@PathVariable String id) {
        despesaGeralService.deletar(id);
        return ResponseEntity.noContent().build();
    }

    @PatchMapping("/{id}/pagar")
    public ResponseEntity<DespesaGeralResponseDTO> pagarDespesa(@PathVariable String id) {
        DespesaGeralResponseDTO paga = despesaGeralService.pagarDespesa(id);
        return ResponseEntity.ok(paga);
    }
}
