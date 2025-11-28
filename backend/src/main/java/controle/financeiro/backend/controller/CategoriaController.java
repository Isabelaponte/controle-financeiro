package controle.financeiro.backend.controller;

import controle.financeiro.backend.dto.request.categoria.AtualizaCategoriaDTO;
import controle.financeiro.backend.dto.request.categoria.CriaCategoriaDTO;
import controle.financeiro.backend.dto.response.CategoriaResponseDTO;
import controle.financeiro.backend.service.CategoriaService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/categorias")
@RequiredArgsConstructor
public class CategoriaController {

    private final CategoriaService categoriaService;

    @GetMapping("/{id}")
    public ResponseEntity<CategoriaResponseDTO> buscar(@PathVariable String id) {
        CategoriaResponseDTO categoria = categoriaService.buscarPorId(id);
        return ResponseEntity.ok(categoria);
    }

    @GetMapping("/usuario/{usuarioId}")
    public ResponseEntity<List<CategoriaResponseDTO>> listarPorUsuario(@PathVariable String usuarioId) {
        List<CategoriaResponseDTO> categorias = categoriaService.listarPorUsuario(usuarioId);
        return ResponseEntity.ok(categorias);
    }

    @GetMapping("/usuario/{usuarioId}/ativas")
    public ResponseEntity<List<CategoriaResponseDTO>> listarAtivasPorUsuario(@PathVariable String usuarioId) {
        List<CategoriaResponseDTO> categorias = categoriaService.listarAtivasPorUsuario(usuarioId);
        return ResponseEntity.ok(categorias);
    }

    @PostMapping
    public ResponseEntity<CategoriaResponseDTO> criar(@Valid @RequestBody CriaCategoriaDTO dto) {
        CategoriaResponseDTO criada = categoriaService.criar(dto);
        return ResponseEntity.status(HttpStatus.CREATED).body(criada);
    }

    @PutMapping("/{id}")
    public ResponseEntity<CategoriaResponseDTO> atualizar(
            @PathVariable String id,
            @Valid @RequestBody AtualizaCategoriaDTO dto) {
        CategoriaResponseDTO atualizada = categoriaService.atualizar(id, dto);
        return ResponseEntity.ok(atualizada);
    }

    @PatchMapping("/{id}/desativar")
    public ResponseEntity<CategoriaResponseDTO> desativar(@PathVariable String id) {
        CategoriaResponseDTO desativada = categoriaService.desativar(id);
        return ResponseEntity.ok(desativada);
    }

    @PatchMapping("/{id}/ativar")
    public ResponseEntity<CategoriaResponseDTO> ativar(@PathVariable String id) {
        CategoriaResponseDTO desativada = categoriaService.ativar(id);
        return ResponseEntity.ok(desativada);
    }
}
