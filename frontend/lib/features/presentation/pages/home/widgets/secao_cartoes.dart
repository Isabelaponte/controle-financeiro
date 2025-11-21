import 'package:flutter/material.dart';
import 'package:frontend/features/models/catao_model.dart';
import 'package:frontend/features/presentation/providers/cartao_provider.dart';
import 'package:frontend/features/shared/widgets/info_coluna.dart';
import 'package:frontend/features/shared/widgets/logo_container.dart';
import 'package:frontend/features/shared/widgets/secao_card.dart';
import 'package:provider/provider.dart';
import 'package:frontend/core/app_colors.dart';

class SecaoCartoes extends StatelessWidget {
  const SecaoCartoes({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartaoCreditoProvider>(
      builder: (context, provider, _) {
        return SecaoCard(
          titulo: "Cartões de crédito",
          onAdd: () => _mostrarDialogAdicionarCartao(context),
          children: _buildContent(provider),
        );
      },
    );
  }

  List<Widget> _buildContent(CartaoCreditoProvider provider) {
    switch (provider.status) {
      case CartaoCreditoStatus.loading:
        return [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: CircularProgressIndicator()),
          ),
        ];

      case CartaoCreditoStatus.error:
        return [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Icon(Icons.error_outline, color: AppColors.red, size: 40),
                const SizedBox(height: 8),
                Text(
                  provider.errorMessage ?? 'Erro ao carregar cartões',
                  style: TextStyle(color: AppColors.grayDark),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ];

      case CartaoCreditoStatus.success:
        if (provider.cartoesAtivos.isEmpty) {
          return [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Nenhum cartão cadastrado',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ];
        }

        final cartoes = provider.cartoesAtivos;
        final widgets = <Widget>[];
        
        for (var i = 0; i < cartoes.length; i++) {
          widgets.add(CartaoTile(cartao: cartoes[i]));
          if (i < cartoes.length - 1) {
            widgets.add(const Divider());
          }
        }
        
        return widgets;

      default:
        return [];
    }
  }

  void _mostrarDialogAdicionarCartao(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Adicionar cartão - Em desenvolvimento')),
    );
  }
}

class CartaoTile extends StatelessWidget {
  final CartaoCreditoModel cartao;

  // TODO: Isso deveria vir de uma API de faturas
  // Por enquanto, usando valor mock
  final double faturaAtual;

  const CartaoTile({
    super.key,
    required this.cartao,
    this.faturaAtual = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final limiteDisponivel = cartao.calcularLimiteDisponivel(faturaAtual);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: InkWell(
        onTap: () => _mostrarDetalhesCartao(context),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 16),
            LogoContainer(cor: _getCorCartao()),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        cartao.nome,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '- ${cartao.statusVencimento}',
                        style: TextStyle(
                          color: cartao.proximoVencimento 
                              ? AppColors.red 
                              : AppColors.grayDark,
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      InfoColuna(
                        label: 'Disponível',
                        valor: cartao.formatarLimiteDisponivel(faturaAtual),
                        corValor: limiteDisponivel > 0 
                            ? AppColors.green 
                            : AppColors.red,
                      ),
                      const SizedBox(width: 50),
                      InfoColuna(
                        label: 'Fatura atual',
                        valor: cartao.formatarFatura(faturaAtual),
                        corValor: faturaAtual > 0 ? AppColors.red : null,
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.purpleLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          faturaAtual > 0 ? "Aberta" : "Fechada",
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.purpleAccent,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCorCartao() {
    // Pode usar o ícone ou categoria para definir a cor
    switch (cartao.categoriaNome?.toLowerCase()) {
      case 'nubank':
        return Colors.purple;
      case 'itaú':
        return Colors.orange;
      case 'bradesco':
        return Colors.red;
      case 'inter':
        return Colors.orange;
      default:
        return Colors.purple;
    }
  }

  void _mostrarDetalhesCartao(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cartao.nome,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Limite total', cartao.limiteTotalFormatado),
            _buildInfoRow('Disponível', cartao.formatarLimiteDisponivel(faturaAtual)),
            _buildInfoRow('Fatura atual', cartao.formatarFatura(faturaAtual)),
            _buildInfoRow('Dia de fechamento', '${cartao.diaFechamento}'),
            _buildInfoRow('Dia de vencimento', '${cartao.diaVencimento}'),
            if (cartao.categoriaNome != null)
              _buildInfoRow('Categoria', cartao.categoriaNome!),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    // TODO: Editar cartão
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Editar'),
                ),
                TextButton.icon(
                  onPressed: () async {
                    Navigator.pop(context);
                    final provider = context.read<CartaoCreditoProvider>();
                    await provider.desativarCartao(cartao.id);
                  },
                  icon: Icon(Icons.block, color: AppColors.red),
                  label: Text('Desativar', style: TextStyle(color: AppColors.red)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppColors.grayDark)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}