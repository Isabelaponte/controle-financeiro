import 'package:flutter/material.dart';
import 'package:frontend/features/models/meta_financeira_model.dart';
import 'package:frontend/features/presentation/providers/meta_financeira_provider.dart';
import 'package:frontend/features/shared/widgets/secao_card.dart';
import 'package:provider/provider.dart';
import 'package:frontend/core/app_colors.dart';
import 'package:frontend/features/presentation/providers/auth_provider.dart';

class SecaoMetas extends StatelessWidget {
  const SecaoMetas({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MetaFinanceiraProvider>(
      builder: (context, provider, _) {
        return SecaoCard(
          titulo: "Minhas metas",
          onAdd: () => _mostrarDialogAdicionarMeta(context),
          children: _buildContent(context, provider),
        );
      },
    );
  }

  List<Widget> _buildContent(
    BuildContext context,
    MetaFinanceiraProvider provider,
  ) {
    switch (provider.status) {
      case MetaStatus.loading:
        return [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: CircularProgressIndicator()),
          ),
        ];

      case MetaStatus.error:
        return [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Icon(Icons.error_outline, color: AppColors.red, size: 40),
                const SizedBox(height: 8),
                Text(
                  provider.errorMessage ?? 'Erro ao carregar metas',
                  style: TextStyle(color: AppColors.grayDark),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ];

      case MetaStatus.success:
        if (provider.metasEmAndamento.isEmpty) {
          return [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Nenhuma meta em andamento',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ];
        }

        return provider.metasEmAndamento
            .map((meta) => MetaTile(meta: meta))
            .toList();

      default:
        return [];
    }
  }

  void _mostrarDialogAdicionarMeta(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Adicionar meta - Em desenvolvimento')),
    );
  }
}

class MetaTile extends StatelessWidget {
  final MetaFinanceiraModel meta;

  const MetaTile({super.key, required this.meta});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _mostrarDetalhesMeta(context),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    meta.nome,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.purpleLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    meta.categoriaNome ?? 'Geral',
                    style: TextStyle(fontSize: 12, color: AppColors.purpleDark),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              meta.statusDias,
              style: TextStyle(
                fontSize: 12,
                color: meta.prazoExpirado
                    ? AppColors.red
                    : meta.prazoProximo
                    ? Colors.orange
                    : AppColors.grayDark,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  meta.valorAtualFormatado,
                  style: TextStyle(fontSize: 13, color: AppColors.green),
                ),
                Text(
                  meta.valorDesejadoFormatado,
                  style: TextStyle(fontSize: 13, color: AppColors.grayDark),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: meta.progresso,
                minHeight: 8,
                backgroundColor: AppColors.grayLight,
                valueColor: AlwaysStoppedAnimation<Color>(
                  meta.concluida
                      ? AppColors.green
                      : meta.prazoExpirado
                      ? AppColors.red
                      : AppColors.purpleDark,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                meta.percentualFormatado,
                style: TextStyle(fontSize: 11, color: AppColors.grayDark),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarDetalhesMeta(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    meta.nome,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (meta.concluida)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.greenLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Concluída',
                      style: TextStyle(
                        color: AppColors.greenDark,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Valor atual', meta.valorAtualFormatado),
            _buildInfoRow('Valor desejado', meta.valorDesejadoFormatado),
            _buildInfoRow('Valor restante', meta.valorRestanteFormatado),
            _buildInfoRow('Progresso', meta.percentualFormatado),
            _buildInfoRow('Status', meta.statusDias),
            if (meta.categoriaNome != null)
              _buildInfoRow('Categoria', meta.categoriaNome!),
            const SizedBox(height: 16),

            // Barra de progresso maior
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: meta.progresso,
                minHeight: 16,
                backgroundColor: AppColors.grayLight,
                valueColor: AlwaysStoppedAnimation<Color>(
                  meta.concluida ? AppColors.green : AppColors.purpleDark,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Botões de ação
            if (!meta.concluida) ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _mostrarDialogAdicionarValor(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Adicionar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _mostrarDialogSubtrairValor(context),
                      icon: const Icon(Icons.remove),
                      label: const Text('Retirar'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    // TODO: Editar meta
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Editar'),
                ),
                TextButton.icon(
                  onPressed: () async {
                    Navigator.pop(context);
                    final provider = context.read<MetaFinanceiraProvider>();
                    final authProvider = context.read<AuthProvider>();
                    await provider.removerMeta(meta.id, authProvider.user!.id);
                  },
                  icon: Icon(Icons.delete, color: AppColors.red),
                  label: Text(
                    'Excluir',
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

  void _mostrarDialogAdicionarValor(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar valor'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Valor',
            prefixText: 'R\$ ',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              final valor = double.tryParse(
                controller.text.replaceAll(',', '.'),
              );
              if (valor != null && valor > 0) {
                Navigator.pop(context); // Fecha dialog
                Navigator.pop(context); // Fecha bottom sheet

                final provider = context.read<MetaFinanceiraProvider>();
                final authProvider = context.read<AuthProvider>();
                await provider.adicionarValor(
                  meta.id,
                  valor,
                  authProvider.user!.id,
                );
              }
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogSubtrairValor(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Retirar valor'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Valor',
            prefixText: 'R\$ ',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              final valor = double.tryParse(
                controller.text.replaceAll(',', '.'),
              );
              if (valor != null && valor > 0) {
                Navigator.pop(context);
                Navigator.pop(context);

                final provider = context.read<MetaFinanceiraProvider>();
                final authProvider = context.read<AuthProvider>();
                await provider.subtrairValor(
                  meta.id,
                  valor,
                  authProvider.user!.id,
                );
              }
            },
            child: const Text('Retirar'),
          ),
        ],
      ),
    );
  }
}
