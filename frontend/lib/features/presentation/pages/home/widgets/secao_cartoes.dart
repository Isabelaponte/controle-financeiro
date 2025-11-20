import 'package:flutter/material.dart';
import 'package:frontend/core/app_colors.dart';
import 'package:frontend/features/shared/widgets/info_coluna.dart';
import 'package:frontend/features/shared/widgets/logo_container.dart';
import 'package:frontend/features/shared/widgets/secao_card.dart';

class SecaoCartoes extends StatelessWidget {
  const SecaoCartoes({super.key});

  @override
  Widget build(BuildContext context) {
    return SecaoCard(
      titulo: "Cartões de crédito",
      onAdd: () {},
      children: const [
        CartaoTile(
          nome: 'Itaú',
          vencimento: '- Vence amanhã',
          disponivel: 'R\$ 2500,00',
          faturaAtual: 'R\$ 2500,00',
        ),
        Divider(),
        CartaoTile(
          nome: 'Itaú',
          vencimento: '- Vence amanhã',
          disponivel: 'R\$ 2500,00',
          faturaAtual: 'R\$ 2500,00',
        ),
      ],
    );
  }
}

class CartaoTile extends StatelessWidget {
  final String nome;
  final String vencimento;
  final String disponivel;
  final String faturaAtual;

  const CartaoTile({
    super.key,
    required this.nome,
    required this.vencimento,
    required this.disponivel,
    required this.faturaAtual,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 16),
          const LogoContainer(cor: Colors.purple),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      nome,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      vencimento,
                      style: TextStyle(color: AppColors.grayDark, fontSize: 13),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    InfoColuna(label: 'Disponível', valor: disponivel),
                    const SizedBox(width: 50),
                    InfoColuna(
                      label: 'Fatura atual',
                      valor: faturaAtual,
                      corValor: AppColors.red,
                    ),
                    const Spacer(),
                    Text(
                      "Aberta",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.purpleAccent,
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
    );
  }
}
