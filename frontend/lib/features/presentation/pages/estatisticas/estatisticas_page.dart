import 'package:flutter/material.dart';
import 'package:frontend/features/presentation/providers/cartao_provider.dart';
import 'package:frontend/features/presentation/providers/conta_provider.dart';
// import 'package:frontend/features/presentation/providers/meta_financeira_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/core/app_colors.dart';

class EstatisticasPage extends StatelessWidget {
  const EstatisticasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final contaProvider = context.watch<ContaProvider>();
    final cartaoProvider = context.watch<CartaoCreditoProvider>();
    // final metaProvider = context.watch<MetaFinanceiraProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estatísticas', style: TextStyle(fontSize: 16),),
        backgroundColor: AppColors.purpleLight,
        foregroundColor: AppColors.purpleDark,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumo Geral',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.purpleDark,
              ),
            ),
            const SizedBox(height: 20),

            // Card de Saldo Total
            _buildStatCard(
              titulo: 'Saldo Total',
              valor: contaProvider.saldoTotalFormatado,
              icon: Icons.account_balance_wallet,
              cor: AppColors.blue,
            ),
            const SizedBox(height: 12),

            // Card de Limite Total dos Cartões
            _buildStatCard(
              titulo: 'Limite Total Cartões',
              valor: cartaoProvider.limiteTotalFormatado,
              icon: Icons.credit_card,
              cor: AppColors.purpleAccent,
            ),
            const SizedBox(height: 12),

            // Card de Metas
            // if (metaProvider.resumo != null)
            //   _buildStatCard(
            //     titulo: 'Total em Metas',
            //     valor: metaProvider.resumo!.totalAcumuladoFormatado,
            //     subtitulo:
            //         '${metaProvider.resumo!.percentualFormatado} alcançado',
            //     icon: Icons.flag,
            //     cor: AppColors.green,
            //   ),

            const SizedBox(height: 32),

            Text(
              'Detalhamento',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.purpleDark,
              ),
            ),
            const SizedBox(height: 16),

            _buildInfoTile(
              'Contas Ativas',
              '${contaProvider.contas.length}',
              Icons.account_balance,
            ),
            _buildInfoTile(
              'Cartões Ativos',
              '${cartaoProvider.cartoes.length}',
              Icons.credit_card,
            ),
            // _buildInfoTile(
            //   'Metas em Andamento',
            //   '${metaProvider.metasEmAndamento.length}',
            //   Icons.flag,
            // ),
            // _buildInfoTile(
            //   'Metas Concluídas',
            //   '${metaProvider.metasConcluidas.length}',
            //   Icons.check_circle,
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String titulo,
    required String valor,
    String? subtitulo,
    required IconData icon,
    required Color cor,
  }) {
    return Card(
      color: AppColors.backgroundCard,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: cor, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(fontSize: 14, color: AppColors.grayDark),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    valor,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkPurple,
                    ),
                  ),
                  if (subtitulo != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitulo,
                      style: TextStyle(fontSize: 12, color: AppColors.grayDark),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String titulo, String valor, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: AppColors.purpleDark),
      title: Text(titulo),
      trailing: Text(
        valor,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
