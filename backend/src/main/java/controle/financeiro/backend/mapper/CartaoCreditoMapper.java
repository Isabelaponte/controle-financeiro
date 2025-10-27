package controle.financeiro.backend.mapper;

import controle.financeiro.backend.dto.request.cartaoCredito.AtualizaCartaoCreditoDTO;
import controle.financeiro.backend.dto.request.cartaoCredito.CriaCartaoCreditoDTO;
import controle.financeiro.backend.dto.response.CartaoCreditoResponseDTO;
import controle.financeiro.backend.model.CartaoCredito;
import controle.financeiro.backend.model.Categoria;
import controle.financeiro.backend.model.Usuario;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
public class CartaoCreditoMapper {
    public CartaoCreditoResponseDTO toResponseDTO(CartaoCredito cartao) {
        if (cartao == null) {
            return null;
        }

        CartaoCreditoResponseDTO dto = new CartaoCreditoResponseDTO();
        dto.setId(cartao.getId());
        dto.setNome(cartao.getNome());
        dto.setIcone(cartao.getIcone());
        dto.setLimiteTotal(cartao.getLimiteTotal());
        dto.setDiaFechamento(cartao.getDiaFechamento());
        dto.setDiaVencimento(cartao.getDiaVencimento());
        dto.setAtivo(cartao.getAtivo());

        if (cartao.getUsuario() != null) {
            dto.setUsuarioId(cartao.getUsuario().getId());
            dto.setUsuarioNome(cartao.getUsuario().getNomeUsuario());
        }

        if (cartao.getCategoria() != null) {
            dto.setCategoriaId(cartao.getCategoria().getId());
            dto.setCategoriaNome(cartao.getCategoria().getNome());
        }

        return dto;
    }

    public List<CartaoCreditoResponseDTO> toResponseDTOList(List<CartaoCredito> cartoes) {
        return cartoes.stream()
                .map(this::toResponseDTO)
                .collect(Collectors.toList());
    }

    public CartaoCredito toEntity(CriaCartaoCreditoDTO dto, Usuario usuario, Categoria categoria) {
        if (dto == null) {
            return null;
        }

        CartaoCredito cartao = new CartaoCredito();
        cartao.setNome(dto.getNome());
        cartao.setIcone(dto.getIcone());
        cartao.setLimiteTotal(dto.getLimiteTotal());
        cartao.setDiaFechamento(dto.getDiaFechamento());
        cartao.setDiaVencimento(dto.getDiaVencimento());
        cartao.setAtivo(true);
        cartao.setUsuario(usuario);
        cartao.setCategoria(categoria);

        return cartao;
    }

    public void updateEntity(AtualizaCartaoCreditoDTO dto, CartaoCredito cartao, Categoria categoria) {
        if (dto == null || cartao == null) {
            return;
        }

        if (dto.getNome() != null) {
            cartao.setNome(dto.getNome());
        }

        if (dto.getIcone() != null) {
            cartao.setIcone(dto.getIcone());
        }

        if (dto.getLimiteTotal() != null) {
            cartao.setLimiteTotal(dto.getLimiteTotal());
        }

        if (dto.getDiaFechamento() != null) {
            cartao.setDiaFechamento(dto.getDiaFechamento());
        }

        if (dto.getDiaVencimento() != null) {
            cartao.setDiaVencimento(dto.getDiaVencimento());
        }

        if (dto.getAtivo() != null) {
            cartao.setAtivo(dto.getAtivo());
        }

        if (categoria != null) {
            cartao.setCategoria(categoria);
        }
    }
}
