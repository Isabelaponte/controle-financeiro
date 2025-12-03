package controle.financeiro.backend.controller;

import controle.financeiro.backend.dto.request.conta.AtualizaContaDTO;
import controle.financeiro.backend.dto.request.conta.CriaContaDTO;
import controle.financeiro.backend.dto.response.ContaResponseDTO;
import controle.financeiro.backend.service.ContaService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/contas")
@RequiredArgsConstructor
public class ContaController {

    private final ContaService contaService;

    @GetMapping("/{id}")
    public ResponseEntity<ContaResponseDTO> buscar(@PathVariable String id) {
        ContaResponseDTO conta = contaService.buscarPorId(id);
        return ResponseEntity.ok(conta);
    }

    @GetMapping("/usuario/{usuarioId}")
    public ResponseEntity<List<ContaResponseDTO>> listarPorUsuario(@PathVariable String usuarioId) {
        List<ContaResponseDTO> contas = contaService.listarPorUsuario(usuarioId);
        return ResponseEntity.ok(contas);
    }

    @GetMapping("/usuario/{usuarioId}/ativas")
    public ResponseEntity<List<ContaResponseDTO>> listarAtivasPorUsuario(@PathVariable String usuarioId) {
        List<ContaResponseDTO> contas = contaService.listarAtivasPorUsuario(usuarioId);
        return ResponseEntity.ok(contas);
    }

    @GetMapping("/usuario/{usuarioId}/saldo-total")
    public ResponseEntity<Map<String, Double>> calcularSaldoTotal(@PathVariable String usuarioId) {
        Double saldo = contaService.calcularSaldoTotal(usuarioId);
        return ResponseEntity.ok(Map.of("saldoTotal", saldo));
    }

    @PostMapping
    public ResponseEntity<ContaResponseDTO> criar(@Valid @RequestBody CriaContaDTO dto) {
        ContaResponseDTO criada = contaService.criar(dto);
        return ResponseEntity.status(HttpStatus.CREATED).body(criada);
    }

    @PutMapping("/{id}")
    public ResponseEntity<ContaResponseDTO> atualizar(
            @PathVariable String id,
            @Valid @RequestBody AtualizaContaDTO dto) {
        ContaResponseDTO atualizada = contaService.atualizar(id, dto);
        return ResponseEntity.ok(atualizada);
    }

    @PatchMapping("/{id}/adicionar-saldo")
    public ResponseEntity<ContaResponseDTO> adicionarSaldo(
            @PathVariable String id,
            @RequestBody Map<String, Double> body) {
        Double valor = body.get("valor");
        ContaResponseDTO atualizada = contaService.adicionarSaldo(id, valor);
        return ResponseEntity.ok(atualizada);
    }

    @PatchMapping("/{id}/subtrair-saldo")
    public ResponseEntity<ContaResponseDTO> subtrairSaldo(
            @PathVariable String id,
            @RequestBody Map<String, Double> body) {
        Double valor = body.get("valor");
        ContaResponseDTO atualizada = contaService.subtrairSaldo(id, valor);
        return ResponseEntity.ok(atualizada);
    }

    @PatchMapping("/{id}/desativar")
    public ResponseEntity<ContaResponseDTO> desativar(@PathVariable String id) {
        ContaResponseDTO desativada = contaService.desativar(id);
        return ResponseEntity.ok(desativada);
    }

    @PatchMapping("/{id}/ativar")
    public ResponseEntity<ContaResponseDTO> ativar(@PathVariable String id) {
        ContaResponseDTO ativada = contaService.ativar(id);
        return ResponseEntity.ok(ativada);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletar(@PathVariable String id) {
        contaService.deletar(id);
        return ResponseEntity.noContent().build();
    }

}
