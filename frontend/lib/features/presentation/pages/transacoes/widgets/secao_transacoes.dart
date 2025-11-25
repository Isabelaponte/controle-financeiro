import 'package:flutter/material.dart';
import 'package:frontend/core/app_colors.dart';
import 'package:frontend/features/models/transacao_model.dart';

class SecaoTransacoes extends StatelessWidget {
  final String titulo;
  final List<TransacaoModel> transacoes;

  const SecaoTransacoes({
    super.key,
    required this.titulo,
    required this.transacoes,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.backgroundCard,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppColors.grayDark,
              ),
            ),
            const SizedBox(height: 15),
            ...transacoes.map(
              (transacao) => TransacaoTile(transacao: transacao),
            ),
          ],
        ),
      ),
    );
  }
}

class TransacaoTile extends StatelessWidget {
  final TransacaoModel transacao;

  const TransacaoTile({super.key, required this.transacao});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _getCorTipo().withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(_getIconeTipo(), color: _getCorTipo()),
      ),
      title: Text(
        transacao.descricao,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        transacao.origemFormatado,
        style: TextStyle(color: AppColors.grayDark, fontSize: 13),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            transacao.valorFormatado,
            style: TextStyle(
              color: _getCorTipo(),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (transacao.categoriaNome != null)
            Text(
              transacao.categoriaNome!,
              style: TextStyle(color: AppColors.grayDark, fontSize: 12),
            ),
        ],
      ),
      onTap: () => _mostrarDetalhes(context),
    );
  }

  Color _getCorTipo() {
    switch (transacao.tipo) {
      case TipoTransacao.receita:
        return AppColors.green;
      case TipoTransacao.despesaGeral:
        return AppColors.red;
      case TipoTransacao.despesaCartao:
        return AppColors.blue;
    }
  }

  IconData _getIconeTipo() {
    switch (transacao.tipo) {
      case TipoTransacao.receita:
        return Icons.arrow_downward;
      case TipoTransacao.despesaGeral:
        return Icons.arrow_upward;
      case TipoTransacao.despesaCartao:
        return Icons.swap_horiz;
    }
  }

  void _mostrarDetalhes(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              transacao.descricao,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Valor', transacao.valorFormatado),
            _buildInfoRow('Tipo', transacao.tipo.name.toUpperCase()),
            _buildInfoRow(
              'Data',
              '${transacao.data.day}/${transacao.data.month}/${transacao.data.year}',
            ),
            _buildInfoRow('Origem', transacao.origemFormatado),
            if (transacao.categoriaNome != null)
              _buildInfoRow('Categoria', transacao.categoriaNome!),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    // TODO: Editar transação
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Editar'),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    // TODO: Deletar transação
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
}
