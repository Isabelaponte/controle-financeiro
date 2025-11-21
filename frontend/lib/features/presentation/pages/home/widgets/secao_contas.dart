import 'package:flutter/material.dart';
import 'package:frontend/features/models/conta_model.dart';
import 'package:frontend/features/presentation/providers/conta_provider.dart';
import 'package:frontend/features/shared/widgets/logo_container.dart';
import 'package:frontend/features/shared/widgets/secao_card.dart';
import 'package:provider/provider.dart';
import 'package:frontend/core/app_colors.dart';

class SecaoContas extends StatelessWidget {
  const SecaoContas({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ContaProvider>(
      builder: (context, provider, _) {
        return SecaoCard(
          titulo: "Minhas contas",
          onAdd: () => _mostrarDialogAdicionarConta(context),
          children: _buildContent(provider),
        );
      },
    );
  }

  List<Widget> _buildContent(ContaProvider provider) {
    switch (provider.status) {
      case ContaStatus.loading:
        return [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: CircularProgressIndicator()),
          ),
        ];

      case ContaStatus.error:
        return [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Icon(Icons.error_outline, color: AppColors.red, size: 40),
                const SizedBox(height: 8),
                Text(
                  provider.errorMessage ?? 'Erro ao carregar contas',
                  style: TextStyle(color: AppColors.grayDark),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ];

      case ContaStatus.success:
        if (provider.contasAtivas.isEmpty) {
          return [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Nenhuma conta cadastrada',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ];
        }
        return provider.contasAtivas
            .map((conta) => ContaTile(conta: conta))
            .toList();

      default:
        return [];
    }
  }

  void _mostrarDialogAdicionarConta(BuildContext context) {
    // TODO: Implementar dialog para adicionar conta
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Adicionar conta - Em desenvolvimento')),
    );
  }
}

class ContaTile extends StatelessWidget {
  final ContaModel conta;

  const ContaTile({super.key, required this.conta});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: LogoContainer(cor: _getCorPorTipo(conta.tipo)),
      title: Text(
        conta.nome,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        conta.tipoFormatado,
        style: TextStyle(color: AppColors.grayDark, fontSize: 14),
      ),
      trailing: Text(
        conta.saldoFormatado,
        style: TextStyle(
          color: conta.saldo >= 0 ? AppColors.blue : AppColors.red,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () => _mostrarDetalhesConta(context, conta),
    );
  }

  Color _getCorPorTipo(String tipo) {
    switch (tipo.toUpperCase()) {
      case 'CORRENTE':
        return Colors.orange;
      case 'POUPANCA':
        return Colors.blue;
      case 'INVESTIMENTO':
        return Colors.green;
      case 'CARTEIRA':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  void _mostrarDetalhesConta(BuildContext context, ContaModel conta) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              conta.nome,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Tipo: ${conta.tipoFormatado}'),
            Text('Saldo: ${conta.saldoFormatado}'),
            if (conta.categoriaNome != null)
              Text('Categoria: ${conta.categoriaNome}'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    // TODO: Editar conta
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Editar'),
                ),
                TextButton.icon(
                  onPressed: () async {
                    Navigator.pop(context);
                    final provider = context.read<ContaProvider>();
                    await provider.desativarConta(conta.id);
                  },
                  icon: Icon(Icons.block, color: AppColors.red),
                  label: Text(
                    'Desativar',
                    style: TextStyle(color: AppColors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
