package controle.financeiro.backend.controller;

import controle.financeiro.backend.dto.request.fatura.AtualizaFaturaDTO;
import controle.financeiro.backend.dto.request.fatura.CriaFaturaDTO;
import controle.financeiro.backend.dto.response.FaturaResponseDTO;
import controle.financeiro.backend.service.FaturaService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/faturas")
@RequiredArgsConstructor
public class FaturaController {

    private final FaturaService faturaService;

    @GetMapping("/{id}")
    public ResponseEntity<FaturaResponseDTO> buscar(@PathVariable String id) {
        FaturaResponseDTO fatura = faturaService.buscarPorId(id);
        return ResponseEntity.ok(fatura);
    }

    @GetMapping("/cartao/{cartaoId}")
    public ResponseEntity<List<FaturaResponseDTO>> listarPorCartao(@PathVariable String cartaoId) {
        List<FaturaResponseDTO> faturas = faturaService.listarPorCartao(cartaoId);
        return ResponseEntity.ok(faturas);
    }

    @GetMapping("/cartao/{cartaoId}/pendentes")
    public ResponseEntity<List<FaturaResponseDTO>> listarPendentes(@PathVariable String cartaoId) {
        List<FaturaResponseDTO> faturas = faturaService.listarPendentes(cartaoId);
        return ResponseEntity.ok(faturas);
    }

    @GetMapping("/vencidas")
    public ResponseEntity<List<FaturaResponseDTO>> listarVencidas(@PathVariable String usuarioId) {
        List<FaturaResponseDTO> faturas = faturaService.listarFaturasVencidas(usuarioId);
        return ResponseEntity.ok(faturas);
    }

    @PostMapping
    public ResponseEntity<FaturaResponseDTO> criar(@Valid @RequestBody CriaFaturaDTO dto) {
        FaturaResponseDTO criada = faturaService.criar(dto);
        return ResponseEntity.status(HttpStatus.CREATED).body(criada);
    }

    @PutMapping("/{id}")
    public ResponseEntity<FaturaResponseDTO> atualizar(
            @PathVariable String id,
            @Valid @RequestBody AtualizaFaturaDTO dto) {
        FaturaResponseDTO atualizada = faturaService.atualizar(id, dto);
        return ResponseEntity.ok(atualizada);
    }

    @PatchMapping("/{id}/pagar")
    public ResponseEntity<FaturaResponseDTO> pagarFatura(@PathVariable String id) {
        FaturaResponseDTO paga = faturaService.pagarFatura(id);
        return ResponseEntity.ok(paga);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletar(@PathVariable String id) {
        faturaService.deletar(id);
        return ResponseEntity.noContent().build();
    }
}
