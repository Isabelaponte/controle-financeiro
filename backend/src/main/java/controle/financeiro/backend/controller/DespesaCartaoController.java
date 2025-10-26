package controle.financeiro.backend.controller;

import controle.financeiro.backend.dto.request.despesa.cartao.AtualizaDespesaCartaoDTO;
import controle.financeiro.backend.dto.request.despesa.cartao.CriaDespesaCartaoDTO;
import controle.financeiro.backend.dto.response.DespesaCartaoResponseDTO;
import controle.financeiro.backend.service.DespesaCartaoService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/despesas-cartao")
@RequiredArgsConstructor
public class DespesaCartaoController {

    private final DespesaCartaoService despesaCartaoService;

    @GetMapping("/{id}")
    public ResponseEntity<DespesaCartaoResponseDTO> buscar(@PathVariable String id) {
        DespesaCartaoResponseDTO despesa = despesaCartaoService.buscarPorId(id);
        return ResponseEntity.ok(despesa);
    }

    @GetMapping("/usuario/{usuarioId}")
    public ResponseEntity<List<DespesaCartaoResponseDTO>> listarPorUsuario(@PathVariable String usuarioId) {
        List<DespesaCartaoResponseDTO> despesas = despesaCartaoService.listarPorUsuario(usuarioId);
        return ResponseEntity.ok(despesas);
    }

    @GetMapping("/cartao/{cartaoId}")
    public ResponseEntity<List<DespesaCartaoResponseDTO>> listarPorCartao(@PathVariable String cartaoId) {
        List<DespesaCartaoResponseDTO> despesas = despesaCartaoService.listarPorCartao(cartaoId);
        return ResponseEntity.ok(despesas);
    }

    @GetMapping("/fatura/{faturaId}")
    public ResponseEntity<List<DespesaCartaoResponseDTO>> listarPorFatura(@PathVariable String faturaId) {
        List<DespesaCartaoResponseDTO> despesas = despesaCartaoService.listarPorFatura(faturaId);
        return ResponseEntity.ok(despesas);
    }

    @PostMapping
    public ResponseEntity<DespesaCartaoResponseDTO> criar(@Valid @RequestBody CriaDespesaCartaoDTO dto) {
        DespesaCartaoResponseDTO criada = despesaCartaoService.criar(dto);
        return ResponseEntity.status(HttpStatus.CREATED).body(criada);
    }

    @PutMapping("/{id}")
    public ResponseEntity<DespesaCartaoResponseDTO> atualizar(
            @PathVariable String id,
            @Valid @RequestBody AtualizaDespesaCartaoDTO dto) {
        DespesaCartaoResponseDTO atualizada = despesaCartaoService.atualizar(id, dto);
        return ResponseEntity.ok(atualizada);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletar(@PathVariable String id) {
        despesaCartaoService.deletar(id);
        return ResponseEntity.noContent().build();
    }
}
