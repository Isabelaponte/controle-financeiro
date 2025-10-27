package controle.financeiro.backend.controller;

import controle.financeiro.backend.dto.request.cartaoCredito.AtualizaCartaoCreditoDTO;
import controle.financeiro.backend.dto.request.cartaoCredito.CriaCartaoCreditoDTO;
import controle.financeiro.backend.dto.response.CartaoCreditoResponseDTO;
import controle.financeiro.backend.service.CartaoCreditoService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/cartoes-credito")
@RequiredArgsConstructor
public class CartaoCreditoController {

    private final CartaoCreditoService cartaoService;

    @GetMapping("/{id}")
    public ResponseEntity<CartaoCreditoResponseDTO> buscar(@PathVariable String id) {
        CartaoCreditoResponseDTO cartao = cartaoService.buscarPorId(id);
        return ResponseEntity.ok(cartao);
    }

    @GetMapping("/usuario/{usuarioId}")
    public ResponseEntity<List<CartaoCreditoResponseDTO>> listarPorUsuario(@PathVariable String usuarioId) {
        List<CartaoCreditoResponseDTO> cartoes = cartaoService.listarPorUsuario(usuarioId);
        return ResponseEntity.ok(cartoes);
    }

    @GetMapping("/usuario/{usuarioId}/ativos")
    public ResponseEntity<List<CartaoCreditoResponseDTO>> listarAtivosPorUsuario(@PathVariable String usuarioId) {
        List<CartaoCreditoResponseDTO> cartoes = cartaoService.listarAtivosPorUsuario(usuarioId);
        return ResponseEntity.ok(cartoes);
    }

    @PostMapping
    public ResponseEntity<CartaoCreditoResponseDTO> criar(@Valid @RequestBody CriaCartaoCreditoDTO dto) {
        CartaoCreditoResponseDTO criado = cartaoService.criar(dto);
        return ResponseEntity.status(HttpStatus.CREATED).body(criado);
    }

    @PutMapping("/{id}")
    public ResponseEntity<CartaoCreditoResponseDTO> atualizar(
            @PathVariable String id,
            @Valid @RequestBody AtualizaCartaoCreditoDTO dto) {
        CartaoCreditoResponseDTO atualizado = cartaoService.atualizar(id, dto);
        return ResponseEntity.ok(atualizado);
    }

    @PatchMapping("/{id}/alterar-limite")
    public ResponseEntity<CartaoCreditoResponseDTO> alterarLimite(
            @PathVariable String id,
            @RequestBody Map<String, Double> body) {
        Double novoLimite = body.get("novoLimite");
        CartaoCreditoResponseDTO atualizado = cartaoService.alterarLimite(id, novoLimite);
        return ResponseEntity.ok(atualizado);
    }

    @PatchMapping("/{id}/desativar")
    public ResponseEntity<CartaoCreditoResponseDTO> desativar(@PathVariable String id) {
        CartaoCreditoResponseDTO desativado = cartaoService.desativar(id);
        return ResponseEntity.ok(desativado);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletar(@PathVariable String id) {
        cartaoService.deletar(id);
        return ResponseEntity.noContent().build();
    }
}
