package controle.financeiro.backend.controller;

import controle.financeiro.backend.dto.response.ResumoMensalDTO;
import controle.financeiro.backend.service.ResumoService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/resumo")
@RequiredArgsConstructor
public class ResumoController {

    private final ResumoService resumoService;

    @GetMapping("/{id}/mensal")
    public ResponseEntity<ResumoMensalDTO> getResumoMensal(
            @PathVariable String id
    ) {
        ResumoMensalDTO resumo = resumoService.getResumoMensal(id);
        return ResponseEntity.ok(resumo);
    }
}